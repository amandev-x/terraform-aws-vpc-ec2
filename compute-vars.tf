variable "ec2_instance" {
  description = "EC2 configuration"
  type = map(object({
    instance_type = string
    subnet_name   = string
    volume_size   = number
    volume_type   = string
  }))
}

variable "allowed_ssh_cidr" {
  description = "A secure IPs for SSH-Connection"
  type        = string
  default     = ""
}