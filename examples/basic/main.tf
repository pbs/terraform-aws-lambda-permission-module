module "lambda" {
  source = "github.com/pbs/terraform-aws-lambda-module?ref=1.3.2"

  handler  = "main.lambda_handler"
  filename = "./artifacts/deploy.zip"
  runtime  = "python3.9"

  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
}

module "topic" {
  source = "github.com/pbs/terraform-aws-sns-topic-module?ref=0.0.1"

  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
}

module "lambda_permission" {
  source = "../.."

  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.name
  principal     = "sns.amazonaws.com"
  source_arn    = module.topic.arn
}
