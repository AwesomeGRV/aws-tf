

/*====
The VPC
======*/


resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.environment}-vpc"
    },
  )
}

/*====
Subnets
======*/
/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "ig" {
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_vpc.vpc]

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.environment}-igw"
    },
  )
}

/* Public subnet */
resource "aws_subnet" "public_subnet" {
  vpc_id                                         = aws_vpc.vpc.id
  for_each                                       = var.public_subnets
  cidr_block                                     = each.value
  availability_zone                              = each.key
  map_public_ip_on_launch                        = true
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  private_dns_hostname_type_on_launch            = "ip-name"
 

  depends_on = [aws_vpc.vpc]
}


/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.environment}-public-route-table"
    },
  )
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}


/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  vpc        = true
  for_each   = var.private_subnets
  depends_on = [aws_internet_gateway.ig]
  tags = merge(
    var.additional_tags,
    {
      Name = "${var.environment}-nat-eip"
    },
  )
}

/* NAT */
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip[each.key].id
  for_each      = var.public_subnets
  subnet_id     = aws_subnet.public_subnet[each.key].id
  depends_on    = [aws_subnet.public_subnet, aws_eip.nat_eip]

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.environment}-nat"
    },
  )
}

/* Private subnet */
resource "aws_subnet" "private_subnet" {
  vpc_id                                         = aws_vpc.vpc.id
  for_each                                       = var.private_subnets
  cidr_block                                     = each.value
  availability_zone                              = each.key
  map_public_ip_on_launch                        = false
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  private_dns_hostname_type_on_launch            = "ip-name"
  depends_on = [aws_vpc.vpc]
}

/* Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id   = aws_vpc.vpc.id
  for_each = var.private_subnets
  tags = merge(
    var.additional_tags,
    {
      Name = "${var.environment}-private-route-table"
    },
  )
}


resource "aws_route" "private_nat_gateway" {
  for_each               = var.private_subnets
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[each.key].id
  depends_on = [
    aws_route_table.private, aws_nat_gateway.nat, aws_subnet.private_subnet
  ]
}

/* Route table associations */
resource "aws_route_table_association" "public" {
  for_each       = var.public_subnets
  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.public.id
  depends_on     = [aws_subnet.public_subnet, aws_route_table.public]
}

resource "aws_route_table_association" "private" {
  for_each       = var.private_subnets
  subnet_id      = aws_subnet.private_subnet[each.key].id
  route_table_id = aws_route_table.private[each.key].id
  depends_on     = [aws_subnet.private_subnet, aws_route_table.private]
}

/*====
VPC's Default Security Group
======*/
resource "aws_security_group" "default" {
  name        = "${var.environment}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }


  tags = merge(
    var.additional_tags,
    {
      Name = "${var.environment}-default-sg"
    },
  )
}

