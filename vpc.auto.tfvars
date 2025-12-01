vpc_cidr_block = "11.0.0.0/16"

subnets = {
  "public-subnet-1a" = {
    cidr_block        = "11.0.0.0/24"
    availability_zone = "ap-south-1a"
    public            = true
  }

  "private-subnet-1b" = {
    cidr_block        = "11.0.1.0/24"
    availability_zone = "ap-south-1b"
    public            = false
  }
}