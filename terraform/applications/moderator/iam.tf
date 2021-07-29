#
# Moderator Developers ECR Read/Write Access Policy
#
data "aws_iam_policy_document" "ecr_rw" {
  statement {
    actions = [
      "ecr:DescribeImages",
      "ecr:GetAuthorizationToken",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
    ]

    resources = [
      module.ecr.ecr_arn,
    ]
  }
}

resource "aws_iam_policy" "ecr_rw" {
  name        = "policy"
  description = "Allow users & roles to push new Moderator ECR images"
  path        = "/moderator/"
  policy      = data.aws_iam_policy_document.ecr_rw.json
}

#
#   Moderator Developers Role & Permissions Setup
#
module "moderator_devs" {
  source       = "github.com/mozilla-it/terraform-modules//aws/maws-roles?ref=master"
  role_name    = "moderator-devs"
  role_mapping = ["mozilliansorg_mozilla-moderator-devs"]
  policy_arn   = [aws_iam_policy.ecr_rw.arn]
}
