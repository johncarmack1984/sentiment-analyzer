# Config-driven imports of durable, non-Zappa-managed resources.
# See IMPORTED.md for the ownership boundary between Terraform and Zappa.

# --- S3 buckets (Zappa deployment-artifact buckets, us-west-1) ---

import {
  to = aws_s3_bucket.zappa_dev
  id = "sentiment-analysis-zappa-dev"
}

import {
  to = aws_s3_bucket.zappa_prod
  id = "sentiment-analysis-zappa-prod"
}

# Only existing sub-resource on either bucket is the public access block.
# (versioning, policy, website, cors, lifecycle all probed: not configured)

import {
  to = aws_s3_bucket_public_access_block.zappa_dev
  id = "sentiment-analysis-zappa-dev"
}

import {
  to = aws_s3_bucket_public_access_block.zappa_prod
  id = "sentiment-analysis-zappa-prod"
}

# --- ACM certificate (us-east-1; used by Zappa-managed API Gateway custom domains) ---

import {
  to = aws_acm_certificate.themiscpage
  id = "arn:aws:acm:us-east-1:735853783919:certificate/76e3cfa6-afa2-4cee-91c1-7e57e66a4e43@us-east-1"
}

# --- IAM: Zappa Lambda execution roles + their inline policies ---

import {
  to = aws_iam_role.zappa_dev
  id = "sentiment-analysis-dev-ZappaLambdaExecutionRole"
}

import {
  to = aws_iam_role_policy.zappa_dev_permissions
  id = "sentiment-analysis-dev-ZappaLambdaExecutionRole:zappa-permissions"
}

import {
  to = aws_iam_role.zappa_production
  id = "sentiment-analysis-production-ZappaLambdaExecutionRole"
}

import {
  to = aws_iam_role_policy.zappa_production_permissions
  id = "sentiment-analysis-production-ZappaLambdaExecutionRole:zappa-permissions"
}

# --- IAM: deploy pipeline user, its policies and attachments ---

import {
  to = aws_iam_user.sentiment_analyzer_prod
  id = "sentiment-analyzer-prod"
}

# (The user's original four grants — AdministratorAccess, AWSLambda_FullAccess,
# ZappaRolePolicy, inline IamLimitedWrite — were imported here 2026-06-11 and
# then removed the same day in favor of aws_iam_policy.deploy; see deploy.tf.)

# --- IAM: pipeline group (note: "anlalyzer" misspelling is the real AWS name) ---
# The user is NOT a member of this group in AWS (group is empty), so there is
# no aws_iam_user_group_membership to import.

