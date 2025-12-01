variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR Block address for VPC "
}

variable "subnets" {
  description = "Map of subnet configurations"
  type = map(object({
    cidr_block        = string
    availability_zone = string
    public            = bool
  }))

  default = {
    "public-1" = {
      cidr_block        = "10.0.0.0/24"
      availability_zone = "ap-south-1a"
      public            = true
    }

    "private-1" = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "ap-south-1a"
      public            = false
    }
  }
}