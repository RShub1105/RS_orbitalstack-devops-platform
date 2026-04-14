variable "environment" { type = string }
variable "tags" { type = map(string) }
variable "db_username" { type = string }
variable "db_password" { type = string }
variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "eks_node_sg_id" { type = string }

