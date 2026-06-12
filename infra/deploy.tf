# Least-privilege replacement (2026-06-11) for the four grants the deploy user
# previously had: AdministratorAccess, AWSLambda_FullAccess, ZappaRolePolicy,
# and inline IamLimitedWrite (iam:* on every ARN type in the account).
# Scope = exactly what `zappa update production` performs (the only CI job):
# zip upload, function update, CFN stack refresh, API redeploy, keep-warm
# rescheduling, and read/pass of the TF-owned execution role.
# manage_roles=false in zappa_settings.json keeps Zappa out of IAM writes.

resource "aws_iam_policy" "deploy" {
  name        = "sentiment-analyzer-zappa-deploy"
  description = "Exactly what `zappa update production` needs; nothing else."
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "DeployBucket"
        Effect   = "Allow"
        Action   = ["s3:ListBucket", "s3:GetBucketLocation"]
        Resource = aws_s3_bucket.zappa_prod.arn
      },
      {
        Sid      = "DeployBucketObjects"
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = "${aws_s3_bucket.zappa_prod.arn}/*"
      },
      {
        Sid    = "UpdateFunction"
        Effect = "Allow"
        Action = [
          "lambda:GetFunction",
          "lambda:GetFunctionConfiguration",
          "lambda:GetFunctionConcurrency",
          "lambda:ListVersionsByFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "lambda:GetPolicy",
          "lambda:AddPermission",
          "lambda:RemovePermission",
        ]
        Resource = "arn:aws:lambda:us-west-1:735853783919:function:sentiment-analysis-production"
      },
      {
        Sid    = "ZappaStack"
        Effect = "Allow"
        Action = [
          "cloudformation:DescribeStacks",
          "cloudformation:DescribeStackResource",
          "cloudformation:ListStackResources",
          "cloudformation:UpdateStack",
        ]
        Resource = "arn:aws:cloudformation:us-west-1:735853783919:stack/sentiment-analysis-production/*"
      },
      {
        # API id 71gvo29q38 = the "Api" resource of CFN stack
        # sentiment-analysis-production; re-pin if the stack is ever rebuilt.
        Sid    = "ApiGatewayRedeploy"
        Effect = "Allow"
        Action = ["apigateway:GET", "apigateway:POST", "apigateway:PATCH"]
        Resource = [
          "arn:aws:apigateway:us-west-1::/restapis/71gvo29q38",
          "arn:aws:apigateway:us-west-1::/restapis/71gvo29q38/*",
        ]
      },
      {
        Sid    = "KeepWarmRule"
        Effect = "Allow"
        Action = [
          "events:DescribeRule",
          "events:PutRule",
          "events:PutTargets",
          "events:DeleteRule",
          "events:RemoveTargets",
          "events:ListTargetsByRule",
        ]
        Resource = "arn:aws:events:us-west-1:735853783919:rule/sentiment-analysis-production*"
      },
      {
        Sid      = "KeepWarmList"
        Effect   = "Allow"
        Action   = ["events:ListRules", "events:ListRuleNamesByTarget"]
        Resource = "*"
      },
      {
        Sid      = "ReadExecutionRole"
        Effect   = "Allow"
        Action   = ["iam:GetRole"]
        Resource = aws_iam_role.zappa_production.arn
      },
      {
        Sid      = "PassExecutionRole"
        Effect   = "Allow"
        Action   = ["iam:PassRole"]
        Resource = aws_iam_role.zappa_production.arn
        Condition = {
          StringEquals = { "iam:PassedToService" = "lambda.amazonaws.com" }
        }
      },
    ]
  })
}

resource "aws_iam_user_policy_attachment" "deploy" {
  user       = aws_iam_user.sentiment_analyzer_prod.name
  policy_arn = aws_iam_policy.deploy.arn
}
