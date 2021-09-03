output "id" {
  value = aws_vpc.vpc_01.id
}

output "cidr_block" {
  value = aws_vpc.vpc_01.cidr_block
}

output "igw" {
  value = aws_internet_gateway.igw_01.id
}

output "private_subnet_ids" {
  value = "${aws_subnet.private_vpc_subnets.*.id}"
}

output "route_table_ids" {
  value = "${aws_route_table.internet_gw.*.id}"
}
