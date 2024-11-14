
variable "threshold" {
  default = "50"
  type = string
}

variable "prefix" {
  type = string
  default = "candidate51-cloudWatch-and-metrics-app"
}

variable "alarm_email" {
  type = string
}

variable "sqs_queue_arn" {
  description = "The ARN of the SQS queue to monitor"
  type        = string
}
