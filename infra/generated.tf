# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "sentiment-analysis-zappa-dev"
resource "aws_s3_bucket_public_access_block" "zappa_dev" {
  block_public_acls       = true
  block_public_policy     = true
  bucket                  = "sentiment-analysis-zappa-dev"
  ignore_public_acls      = true
  region                  = "us-west-1"
  restrict_public_buckets = true
}

# __generated__ by Terraform from "sentiment-analysis-zappa-prod"
resource "aws_s3_bucket_public_access_block" "zappa_prod" {
  block_public_acls       = true
  block_public_policy     = true
  bucket                  = "sentiment-analysis-zappa-prod"
  ignore_public_acls      = true
  region                  = "us-west-1"
  restrict_public_buckets = true
}

# __generated__ by Terraform from "sentiment-analysis-dev-ZappaLambdaExecutionRole:zappa-permissions"
resource "aws_iam_role_policy" "zappa_dev_permissions" {
  name = "zappa-permissions"
  policy = jsonencode({
    Statement = [{
      Action   = ["logs:*"]
      Effect   = "Allow"
      Resource = "arn:aws:logs:*:*:*"
      }, {
      Action   = ["lambda:InvokeFunction"]
      Effect   = "Allow"
      Resource = ["*"]
      }, {
      Action   = ["xray:PutTraceSegments", "xray:PutTelemetryRecords"]
      Effect   = "Allow"
      Resource = ["*"]
      }, {
      Action   = ["ec2:AttachNetworkInterface", "ec2:CreateNetworkInterface", "ec2:DeleteNetworkInterface", "ec2:DescribeInstances", "ec2:DescribeNetworkInterfaces", "ec2:DetachNetworkInterface", "ec2:ModifyNetworkInterfaceAttribute", "ec2:ResetNetworkInterfaceAttribute"]
      Effect   = "Allow"
      Resource = "*"
      }, {
      Action   = ["s3:*"]
      Effect   = "Allow"
      Resource = "arn:aws:s3:::*"
      }, {
      Action   = ["kinesis:*"]
      Effect   = "Allow"
      Resource = "arn:aws:kinesis:*:*:*"
      }, {
      Action   = ["sns:*"]
      Effect   = "Allow"
      Resource = "arn:aws:sns:*:*:*"
      }, {
      Action   = ["sqs:*"]
      Effect   = "Allow"
      Resource = "arn:aws:sqs:*:*:*"
      }, {
      Action   = ["dynamodb:*"]
      Effect   = "Allow"
      Resource = "arn:aws:dynamodb:*:*:*"
      }, {
      Action   = ["route53:*"]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
  role = "sentiment-analysis-dev-ZappaLambdaExecutionRole"
}

# __generated__ by Terraform from "sentiment-analyzer-prod"
resource "aws_iam_user" "sentiment_analyzer_prod" {
  name     = "sentiment-analyzer-prod"
  path     = "/"
  tags     = {}
  tags_all = {}
}

# __generated__ by Terraform from "sentiment-analysis-production-ZappaLambdaExecutionRole:zappa-permissions"
resource "aws_iam_role_policy" "zappa_production_permissions" {
  name = "zappa-permissions"
  policy = jsonencode({
    Statement = [{
      Action   = ["logs:*"]
      Effect   = "Allow"
      Resource = "arn:aws:logs:*:*:*"
      }, {
      Action   = ["lambda:InvokeFunction"]
      Effect   = "Allow"
      Resource = ["*"]
      }, {
      Action   = ["xray:PutTraceSegments", "xray:PutTelemetryRecords"]
      Effect   = "Allow"
      Resource = ["*"]
      }, {
      Action   = ["ec2:AttachNetworkInterface", "ec2:CreateNetworkInterface", "ec2:DeleteNetworkInterface", "ec2:DescribeInstances", "ec2:DescribeNetworkInterfaces", "ec2:DetachNetworkInterface", "ec2:ModifyNetworkInterfaceAttribute", "ec2:ResetNetworkInterfaceAttribute"]
      Effect   = "Allow"
      Resource = "*"
      }, {
      Action   = ["s3:*"]
      Effect   = "Allow"
      Resource = "arn:aws:s3:::*"
      }, {
      Action   = ["kinesis:*"]
      Effect   = "Allow"
      Resource = "arn:aws:kinesis:*:*:*"
      }, {
      Action   = ["sns:*"]
      Effect   = "Allow"
      Resource = "arn:aws:sns:*:*:*"
      }, {
      Action   = ["sqs:*"]
      Effect   = "Allow"
      Resource = "arn:aws:sqs:*:*:*"
      }, {
      Action   = ["dynamodb:*"]
      Effect   = "Allow"
      Resource = "arn:aws:dynamodb:*:*:*"
      }, {
      Action   = ["route53:*"]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
  role = "sentiment-analysis-production-ZappaLambdaExecutionRole"
}

# __generated__ by Terraform from "arn:aws:acm:us-east-1:735853783919:certificate/76e3cfa6-afa2-4cee-91c1-7e57e66a4e43@us-east-1"
resource "aws_acm_certificate" "themiscpage" {
  domain_name               = "themiscpage.com"
  key_algorithm             = "RSA_2048"
  region                    = "us-east-1"
  subject_alternative_names = ["*.themiscpage.com", "themiscpage.com"]
  tags                      = {}
  tags_all                  = {}
  validation_method         = "DNS"
  options {
    certificate_transparency_logging_preference = "ENABLED"
    export                                      = "DISABLED"
  }
}

# __generated__ by Terraform from "sentiment-analysis-dev-ZappaLambdaExecutionRole"
resource "aws_iam_role" "zappa_dev" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = ["apigateway.amazonaws.com", "lambda.amazonaws.com", "events.amazonaws.com"]
      }
      Sid = ""
    }]
    Version = "2012-10-17"
  })
  force_detach_policies = false
  max_session_duration  = 3600
  name                  = "sentiment-analysis-dev-ZappaLambdaExecutionRole"
  path                  = "/"
  tags                  = {}
  tags_all              = {}
}

# __generated__ by Terraform from "sentiment-analysis-production-ZappaLambdaExecutionRole"
resource "aws_iam_role" "zappa_production" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = ["events.amazonaws.com", "lambda.amazonaws.com", "apigateway.amazonaws.com"]
      }
      Sid = ""
    }]
    Version = "2012-10-17"
  })
  force_detach_policies = false
  max_session_duration  = 3600
  name                  = "sentiment-analysis-production-ZappaLambdaExecutionRole"
  path                  = "/"
  tags                  = {}
  tags_all              = {}
}

# __generated__ by Terraform from "sentiment-analysis-zappa-dev"
resource "aws_s3_bucket" "zappa_dev" {
  bucket              = "sentiment-analysis-zappa-dev"
  bucket_namespace    = "global"
  force_destroy       = false
  object_lock_enabled = false
  region              = "us-west-1"
  tags                = {}
  tags_all            = {}
}

# __generated__ by Terraform from "sentiment-analysis-zappa-prod"
resource "aws_s3_bucket" "zappa_prod" {
  bucket              = "sentiment-analysis-zappa-prod"
  bucket_namespace    = "global"
  force_destroy       = false
  object_lock_enabled = false
  region              = "us-west-1"
  tags                = {}
  tags_all            = {}
}
