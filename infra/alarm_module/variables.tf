
variable "threshold" {
  default = "60"
  type = string
}

variable "prefix" {
  type = string
  default = "candidate51-img-gen-app"
}

variable "alarm_email" {
  type = string
}

variable "sqs_queue_name" {
  description = "The name of the SQS queue to monitor"
  type        = string
}