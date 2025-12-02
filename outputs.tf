output "vpc_id" {
  value = aws_vpc.main-VPC.id
}

output "subnet_ids" {
  description = "A list of Subnet IDs"
  value = {
    for k, subnet in aws_subnet.subnets : k => subnet.id
  }
}

output "public_subnet_ids" {
  description = "A list of public subnet IDs"
  value = [
    for k, subnet in var.subnets : aws_subnet.subnets[k].id
    if subnet.public
  ]
}

output "private_subnet_ids" {
  description = "A list of Private subnet IDs"
  value = [
    for k, subnet in var.subnets : aws_subnet.subnets[k].id
    if !subnet.public
  ]
}

output "ec2_instances" {
  description = "A detail overview of EC2 instances"
  value = {
    for k, instance in aws_instance.ec2-computes : k => {
      id               = instance.id
      public_ip        = instance.public_ip
      private_ip       = instance.private_ip
      has_public_ip    = instance.public_ip != "" ? true : false
      subnet_name      = var.ec2_instance[k].subnet_name
      subnet_id        = instance.subnet_id
      subnet_is_public = var.subnets[var.ec2_instance[k].subnet_name].public
    }
  }
}