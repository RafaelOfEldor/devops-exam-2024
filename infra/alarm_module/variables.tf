
variable "threshold" {
  default = "2"
  type = string
}

variable "prefix" {
  type = string
  default = "candidate51-img-gen-app"
}

variable "alarm_email" {
  type = string
}

variable "sqs_queue_arn" {
  description = "The ARN of the SQS queue to monitor"
  type        = string
}