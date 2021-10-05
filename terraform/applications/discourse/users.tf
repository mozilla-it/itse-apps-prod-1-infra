####################
#      Users       #
####################

// Grant access to users via MAWS (prod only)
module "discourse_developers" {
  create_role  = var.environment == "prod" ? "1" : "0"
  source       = "github.com/mozilla-it/terraform-modules//aws/maws-roles?ref=master"
  role_name    = "maws-discourse-developers"
  role_mapping = ["aws_discourse_dev"]
  policy_arn   = var.environment == "prod" ? [aws_iam_policy.developers[0].arn] : [""]
}

resource "aws_iam_policy" "developers" {
  count  = var.environment == "prod" ? "1" : "0"
  name   = "discourseDevelopersPolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.developers.json
}

data "aws_iam_policy_document" "developers" {

  statement {
    sid       = "DiscourseS3"
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::discourse-*"]
  }

  statement {
    sid = "DiscourseSES"
    actions = [
      "ses:DescribeActiveReceiptRuleSet",
      "ses:DescribeReceiptRule",
      "ses:DescribeReceiptRuleSet",
      "ses:ListReceiptRuleSets"
    ]
    resources = ["*"]
  }

  statement {
    sid = "DiscourseLambdaRO"
    actions = [
      "lambda:GetAccountSettings",
      "lambda:ListFunctions",
      "lambda:ListTags",
      "lambda:GetEventSourceMapping",
      "lambda:ListEventSourceMappings"
    ]
    resources = ["arn:aws:lambda:::discourse-*"]
  }

  statement {
    sid = "DiscourseLambdaSourceMapping"
    actions = [
      "lambda:DeleteEventSourceMapping",
      "lambda:UpdateEventSourceMapping",
      "lambda:CreateEventSourceMapping"
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "lambda:FunctionArn"
      values   = ["arn:aws:lambda:*:*:function:discourse-*"]
    }
  }
}
