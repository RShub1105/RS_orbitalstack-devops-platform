variable "cluster_name" { type = string }
variable "environment" { type = string }
variable "tags" { type = map(string) }
variable "vpc_id" { type = string }
variable "private_subnets" { type = list(string) }

