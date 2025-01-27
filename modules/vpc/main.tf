resource "aws_vpc" "vpc" {
  count      = var.vpc_cidr != null ? 1 : 0
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}


resource "aws_subnet" "subnet" {
  for_each          = var.subnets != [] ? var.subnets : {}
  vpc_id            = aws_vpc.vpc[0].id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}

resource "aws_internet_gateway" "igw" {
    count      = var.vpc_name != null ? 1 : 0
  vpc_id = aws_vpc.vpc[0].id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}


resource "aws_eip" "eip" {
  for_each = tomap({ for i, ngw in var.nat_gateways : i => ngw })
  domain   = "vpc"
}

resource "aws_nat_gateway" "natgw" {
  for_each = aws_eip.eip

  allocation_id = aws_eip.eip[each.key].id
  subnet_id     = var.nat_gateways[tonumber(each.key)].subnet_id

  tags = {
    Name = "${var.nat_gateways[tonumber(each.key)].name}-natgw"
  }
  depends_on = [aws_eip.eip]
}

resource "aws_route_table" "route-tb" {
  for_each = tomap({ for i, route-tbl in var.route_maps : i => route-tbl })

  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = each.value.routes == null ? [] : each.value.routes
    content {
      cidr_block             = route.value.cidr_block
      gateway_id             = route.value.gateway_id
      nat_gateway_id         = route.value.nat_gateway_id
      egress_only_gateway_id = route.value.egress_only_gateway_id
    }
  }
  tags = {
    Name = each.key
  }
}

resource "aws_route_table_association" "subnet_rtb_association" {
  for_each       = tomap({ for i, rtb in var.route_association : i => rtb })
  subnet_id      = each.value.subnet_id
  route_table_id = each.value.rtb_id
}