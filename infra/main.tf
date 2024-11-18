resource "aws_iam_role" "lambda_exec_role" {
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        }
      }
    ]
  })

  name = "${var.prefix}_lambda_exec_role"
}

resource "aws_iam_role_policy" "lambda_candidate51_task2_policy" {
  name = "${var.prefix}_LambdaCandidate51Task2Policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:PutObject",
          "bedrock:InvokeModel",
          "sqs:ReceiveMessage",
          "sqs:GetQueueAttributes",
          "sqs:DeleteMessage"
          ]
        "Resource": [
          "arn:aws:s3:::${var.bucket_name}/*",
          "arn:aws:sqs:${var.region}:${var.account_id}:${aws_sqs_queue.image_generation_queue.name}",
          "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-image-generator-v1"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_sqs.py"
  output_path = "${path.module}/lambda_sqs_payload.zip"
}

resource "aws_lambda_function" "sqs_lambda" {
  function_name    = "${var.prefix}_sqs_lambda"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_sqs.lambda_handler"
  runtime          = "python3.9"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)

  timeout          = 300

  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.image_generation_queue.arn
  function_name    = aws_lambda_function.sqs_lambda.arn
  batch_size       = 10
  enabled          = true
}

resource "aws_sqs_queue" "image_generation_queue" {
  name                       = "${var.prefix}_image_generation_queue"
  visibility_timeout_seconds = 300
}

output "sqs_queue_url" {
  value = aws_sqs_queue.image_generation_queue.url
}