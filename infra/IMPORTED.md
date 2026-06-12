# Terraform / Zappa ownership boundary

This Terraform root adopts only the **durable, non-Zappa-managed** resources of the
sentiment-analyzer app (AWS account 735853783919, region us-west-1, state in
`s3://john-carmack-terraform-state/sentiment-analyzer/terraform.tfstate`).

## Terraform owns (imported 2026-06-11)

### S3 (us-west-1)
- `aws_s3_bucket.zappa_dev` — `sentiment-analysis-zappa-dev`
- `aws_s3_bucket.zappa_prod` — `sentiment-analysis-zappa-prod`
- `aws_s3_bucket_public_access_block.zappa_dev` / `.zappa_prod` — the only
  sub-resource configured on either bucket. Versioning, bucket policy, website,
  CORS, and lifecycle were probed and do not exist (404 / unset), so they are
  intentionally absent here.

These are the buckets Zappa uploads deployment zips to (`s3_bucket` in
`zappa_settings.json`). Zappa uses them but does not create/destroy them via
CloudFormation, so they are safe to manage here.

### ACM (us-east-1)
- `aws_acm_certificate.themiscpage` —
  `arn:aws:acm:us-east-1:735853783919:certificate/76e3cfa6-afa2-4cee-91c1-7e57e66a4e43`
  (`themiscpage.com` + `*.themiscpage.com`, DNS-validated, Amazon-issued).
  Declared with per-resource `region = "us-east-1"` (required for edge-optimized
  API Gateway custom domains; also in use by two CloudFront distributions in
  account 968246515281). `zappa certify` only *references* this cert by ARN.

### IAM (global)
- `aws_iam_role.zappa_dev` / `aws_iam_role_policy.zappa_dev_permissions` —
  `sentiment-analysis-dev-ZappaLambdaExecutionRole` + inline `zappa-permissions`
- `aws_iam_role.zappa_production` / `aws_iam_role_policy.zappa_production_permissions` —
  `sentiment-analysis-production-ZappaLambdaExecutionRole` + inline `zappa-permissions`
- `aws_iam_user.sentiment_analyzer_prod` — deploy-pipeline user
- `aws_iam_policy.deploy` + `aws_iam_user_policy_attachment.deploy` —
  `sentiment-analyzer-zappa-deploy`, the user's ONLY grant (least-privilege,
  2026-06-11). The original four grants (AdministratorAccess,
  AWSLambda_FullAccess, ZappaRolePolicy attachment, inline `IamLimitedWrite`)
  were imported and then removed via Terraform the same day; see `deploy.tf`.
  The first CI deploy after this change validates the scope — an AccessDenied
  there means an action is missing from `deploy.tf`, not a broken pipeline.
- `aws_iam_group.pipeline_production` —
  `sentiment-anlalyzer-pipeline-production` (the "anlalyzer" misspelling is the
  real AWS name) + `aws_iam_group_policy.do_zappa_deployment`

Notes:
- The user is **not** a member of the group in AWS (the group is empty), so
  there is no `aws_iam_user_group_membership` to import.
- The user currently has **no access keys**; keys are never importable into
  Terraform anyway (secrets are only available at creation time).

`manage_roles` is now `false` in `zappa_settings.json` (with an explicit
`role_name` per stage), so Zappa neither creates nor updates the execution
roles; Terraform is their sole owner.

## Zappa owns (DO NOT import / manage here)

Managed by Zappa via its per-stage CloudFormation stacks and the
`zappa update|schedule|certify` lifecycle — importing them into Terraform would
cause the two tools to fight over state:

- Lambda functions `sentiment-analysis-dev` / `sentiment-analysis-production`
  (code, config, aliases, versions)
- API Gateway REST APIs, deployments, stages, and the custom domains
  `sentiment-dev.themiscpage.com` / `sentiment.themiscpage.com`
  (`zappa certify` manages base-path mappings + domain)
- CloudWatch log groups for the Lambdas/API Gateway
- CloudWatch Events / EventBridge keep-warm rules
  (`zappa schedule` / `zappa unschedule`)

## Lives elsewhere

- **DNS records** for `themiscpage.com` (including the `sentiment` /
  `sentiment-dev` CNAMEs and the ACM validation CNAME) are managed in
  `my-infra/dns`, not here.

## Day-2 rules

- `terraform plan` here must stay clean ("No changes.") between deliberate
  edits; a surprise diff means someone changed a bucket/cert/IAM resource out
  of band (or Zappa re-ran role management).
- Never add Lambda/API Gateway/log-group/event-rule resources to this root
  while the app is still deployed with Zappa.
