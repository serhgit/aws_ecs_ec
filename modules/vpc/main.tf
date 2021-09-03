resource "aws_vpc" "vpc_01"{
  cidr_block = var.vpc_cidr

  tags = {
    Name        = var.environment
    Environment = var.environment
  }
}
resource "aws_subnet" "private_vpc_subnets" {
  count = ( length(var.private_subnets) < length(var.availability_zones) ? length(var.private_subnets) : length(var.availability_zones) )

  vpc_id                  = aws_vpc.vpc_01.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name        = "private_subnet_${var.availability_zones[count.index]}"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "igw_01" {
  vpc_id = aws_vpc.vpc_01.id
   
  tags = {
    Name        = var.environment
    Environment = var.environment
  }
}



resource "aws_route_table" "internet_gw" {
  vpc_id = aws_vpc.vpc_01.id

  route = [
    {
      cidr_block                 = "0.0.0.0/0"
      gateway_id                 = aws_internet_gateway.igw_01.id

      #The paremeters listed below are required to be set
      #Otherwise terraform fails
      carrier_gateway_id         = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      nat_gateway_id             = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
    }
  ]

  tags = {
    Name = "${var.environment}_internet_gw"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "rt_association" {
  count = length(aws_subnet.private_vpc_subnets)

  subnet_id      = aws_subnet.private_vpc_subnets[count.index].id
  route_table_id = aws_route_table.internet_gw.id
}
