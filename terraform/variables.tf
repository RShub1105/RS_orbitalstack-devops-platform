variable "aws_region" {
  type        = string
  description = "AWS region for all resources"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "owner" {
  type        = string
  description = "Owner tag value"
}

variable "project" {
  type        = string
  default     = "orbital-stack"
  description = "Project tag value"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "db_username" {
  type        = string
  description = "TimescaleDB master username"
}

variable "db_password" {
  type        = string
  description = "TimescaleDB master password"
  sensitive   = true
}

