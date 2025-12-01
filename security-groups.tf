resource "aws_security_group" "compute-SG" {
    name = "EC2-SG"
    vpc_id = aws_vpc.main-VPC.id 

    ingress  {
        from_port = 22
        to_port = 22 
        protocol = "tcp"
        cidr_blocks = var.allowed_ssh_cidr[*]
    }

     ingress  {
        from_port = "443"
        to_port = "443"
        protocol = "tcp"
        cidr_blocks = "0.0.0.0/0"
    }

    ingress  {
        from_port = 80
        to_port = 80 
        protocol = "tcp"
        cidr_blocks = "0.0.0.0/0"
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = "0.0.0.0/0"
    }
}