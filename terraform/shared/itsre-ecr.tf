# Used primarily for automated users that required
# access to itsre ECR repositories (like mozilla-it/helm-charts)

data "aws_iam_policy_document" "ecr_readonly_access" {
  statement {
    sid    = "ReadOnlyAccess"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:DescribeImageScanFindings",
      "ecr:DescribeRepositories",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecr_readonly_access" {
  name = "ecr-readonly-iam"

  policy = data.aws_iam_policy_document.ecr_readonly_access.json

  tags = {
    Name      = "ecr-readonly-iam"
    Terraform = "true"
  }
}

module "iam_assumable_role_github_actions" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"

  create_role = true

  role_name = "ecr-readonly-iam"

  provider_url = "https://token.actions.githubusercontent.com"

  role_policy_arns = [
    aws_iam_policy.ecr_readonly_access.arn
  ]

  oidc_subjects_with_wildcards = [
    "repo:mozilla-it/helm-charts:*"
  ]

  tags = {
    Name      = "ecr-readonly-iam"
    Terraform = "true"
  }
}
