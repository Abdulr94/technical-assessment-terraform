resource "aws_security_group" "sg" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id
  tags        = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "sg_rule_ingress" {
  count             = length(var.ingress_rules) > 0 ? length(var.ingress_rules) : 0
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = var.ingress_rules[count.index].cidr
  from_port         = var.ingress_rules[count.index].from_port
  ip_protocol       = var.ingress_rules[count.index].protocol
  to_port           = var.ingress_rules[count.index].to_port
}

resource "aws_vpc_security_group_egress_rule" "sg_rule_egress" {
  count             = length(var.egress_rules) > 0 ? length(var.egress_rules) : 0
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = var.egress_rules[count.index].cidr
  ip_protocol       = var.egress_rules[count.index].protocol
}