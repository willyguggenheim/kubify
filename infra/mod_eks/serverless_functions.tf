data "archive_file" "functions_archive_files" {
  type             = "zip"
  source_file      = "${path.module}/../../backend/${var.functions}/app"
  output_file_mode = "0666"
  output_path      = "${path.module}/../../._kubify_work/${var.functions}.zip"
}

resource "aws_lambda_function" "functions" {
  filename      = "${path.module}/../../._kubify_work/${var.functions}.zip"
  function_name = var.functions
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "entrypoint"

  source_code_hash = filebase64sha256("${path.module}/../../._kubify_work/${var.functions}.zip")

  runtime = "python3.x"

  environment {
    variables = {
      ENV = var.env_name
    }
  }
}