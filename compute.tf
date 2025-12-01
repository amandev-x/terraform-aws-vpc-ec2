data "aws_ami" "ubuntu-ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "ec2-computes" {
  for_each = var.ec2_instance

  ami           = data.aws_ami.ubuntu-ami.id
  instance_type = each.value.instance_type
  key_name      = "test-server"
  subnet_id     = aws_subnet.subnets[each.value.subnet_name].id
  tags = merge(local.commonTags, {
    Name = "${each.key}-instance"
    Type = "${each.value.instance_type}"
  })
  associate_public_ip_address = var.subnets[each.value.subnet_name].public

  root_block_device {
    volume_size = each.value.volume_size
    volume_type = each.value.volume_type
  }
}