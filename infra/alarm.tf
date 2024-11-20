module "alarm" {
  source = "./alarm_module"
  alarm_email = var.alarm_email
  sqs_queue_name = aws_sqs_queue.image_generation_queue.name
}