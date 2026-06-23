variable "project_name" {
  type    = string
  default = "nuvrapay"
}

variable "vpc_cidr" {
  type    = string
  default = "10.50.0.0/16"
}

variable "alarm_email" {
  type    = string
  default = "nuvraverse@gmail.com"
}
