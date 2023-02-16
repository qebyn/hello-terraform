variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "DefaultName"
}

variable "app_name" {
  description = "Value of the App tag for the EC2 instance"
  type        = string
  default     = "vue2048"
}

variable "region" {
  type = string
  default = "eu-west-1"
}

