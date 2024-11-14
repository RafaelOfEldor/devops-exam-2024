resource "aws_cloudwatch_metric_alarm" "sqs_delay_alarm" {
  alarm_name  = "${var.prefix}-ApproximateAgeOfOldestMessageAlarm"
  namespace   = "AWS/SQS"
  metric_name = "ApproximateAgeOfOldestMessage"

  comparison_operator = "GreaterThanThreshold"
  threshold           = var.threshold
  evaluation_periods  = 2
  period              = 60
  statistic           = "Maximum"

  alarm_description = "This alarm goes off as soon as the age of the oldest message exceeds the threshold."
  alarm_actions     = [aws_sns_topic.user_updates.arn]

  dimensions = {
    QueueName = var.sqs_queue_arn
  }

}

resource "aws_sns_topic" "user_updates" {
  name = "${var.prefix}-alarm-topic"
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.user_updates.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}