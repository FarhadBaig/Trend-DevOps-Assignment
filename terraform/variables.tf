
variable "aws_region" {
  description = "AWS region for the Trend DevOps assignment"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used to tag resources"
  type        = string
  default     = "trend-devops"
}

variable "my_ip_cidr" {
  description = "Your public IP in CIDR format, for example 203.0.113.25/32"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.my_ip_cidr))
    error_message = "Provide a valid IPv4 CIDR, ideally your public IP with /32."
  }
}
