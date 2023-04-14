output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets_id" {
  value = toset([
    for subnet in aws_subnet.public_subnet : subnet.id
  ])
}

output "private_subnets_id" {
  value = toset([
    for subnet in aws_subnet.private_subnet : subnet.id
  ])
}
  
output "cidr_block" {
  value = aws_vpc.vpc.cidr_block
}
  
output "subnets_id" {
  value = concat(tolist([
    for subnet in aws_subnet.private_subnet : subnet.id
    ]),
    tolist([
      for subnet in aws_subnet.public_subnet : subnet.id
    ]),
  )

  depends_on = [aws_route_table_association.private, aws_route_table_association.public]

}


output "default_sg_id" {
  value = aws_security_group.default.id
}

output "security_groups_ids" {
  value = ["${aws_security_group.default.id}"]
}

output "public_route_table" {
  value = aws_route_table.public.id
}
