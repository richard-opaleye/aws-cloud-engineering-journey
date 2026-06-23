resource "aws_sqs_queue" "dlq" {
  name                      = "${var.project_name}-payments-dlq"
  message_retention_seconds = 1209600

  tags = { Name = "${var.project_name}-payments-dlq" }
}

resource "aws_sqs_queue" "payments" {
  name                       = "${var.project_name}-payments"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 86400
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 3
  })

  tags = { Name = "${var.project_name}-payments" }
}
