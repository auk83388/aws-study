
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "allowed_ip" {
  description = "my IP address"
  type        = string
  default     = ""
}

variable "db_username" {
  description = "RDS databese username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS database password"
  type        = string
  sensitive   = true
}

