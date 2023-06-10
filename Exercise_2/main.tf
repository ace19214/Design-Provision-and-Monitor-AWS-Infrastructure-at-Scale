terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region  = var.aws_region
}


data "aws_iam_policy_document" "role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

data "archive_file" "greet_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/${var.lambda_name}.py"
  output_path = "${path.module}/${var.lambda_file}"
}

resource "aws_iam_role" "iam_lambda" {
  name               = "iam_lambda"
  assume_role_policy = data.aws_iam_policy_document.role.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${var.lambda_name}"
}

resource "aws_lambda_function" "greet_lambda" {
  role             = aws_iam_role.iam_lambda.arn
  filename         = var.lambda_file
  function_name    = var.lambda_name
  handler          = "${var.lambda_name}.${var.lambda_handler_name}"
  runtime          = var.lambda_runtime

  environment {
    variables = {
      greeting = var.hello_world
    }
  }
  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.example,
  ]
}
