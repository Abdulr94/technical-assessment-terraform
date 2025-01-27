resource "aws_network_interface" "eni" {
  subnet_id       = var.subnet_id
  security_groups = var.sgList
  tags = {
    Name = "${var.ec2name}-eni"
  }
}

resource "aws_instance" "ec2" {
  ami           = var.ami_id
  instance_type = var.family
  key_name      = var.keypair

  network_interface {
    network_interface_id = aws_network_interface.eni.id
    device_index         = 0
  }

  tags = {
    Name = var.ec2name
  }
}

resource "aws_eip" "lb" {
  for_each = var.publicip ? { "eip" = aws_instance.ec2.id } : {}
  instance = each.value
  domain   = "vpc"
}

resource "aws_eip_association" "eip_assoc" {
  for_each      = var.publicip ? aws_eip.lb : {}
  instance_id   = aws_instance.ec2.id
  allocation_id = aws_eip.lb[each.key].id
}
