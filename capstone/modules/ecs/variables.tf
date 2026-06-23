variable "project_name"      { type = string }
variable "vpc_id"            { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "alb_sg_id"         { type = string }
variable "ecs_sg_id"         { type = string }
variable "sqs_queue_arn"     { type = string }
