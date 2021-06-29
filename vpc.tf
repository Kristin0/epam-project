resource "aws_vpc" "epam-project" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "epam-project-vpc"
  }
}

data "aws_availability_zones" "zones" {}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)
  availability_zone = data.aws_availability_zones.zones.names[count.index]
  vpc_id = aws_vpc.epam-project.id
  cidr_block = var.private_subnets[count.index]
  tags = {
    Name = "${var.private_service_names[count.index]}"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  availability_zone = data.aws_availability_zones.zones.names[count.index]
  vpc_id = aws_vpc.epam-project.id
  cidr_block = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "web,api-gateway"
  }
}


resource "aws_internet_gateway" "epam-igw" {
  vpc_id = aws_vpc.epam-project.id
}

resource "aws_nat_gateway" "epam-ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public.*.id[0]

}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.epam-project.id 
  route   {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.epam-ngw.id
  }
  
  tags = {
    "Name" = "private-route-table-epam"
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)
  route_table_id = aws_route_table.private.id
  subnet_id = aws_subnet.private[count.index].id
}

resource "aws_eip" "eip" {}

resource "aws_security_group" "allow_4200_8080" {
  vpc_id = aws_vpc.epam-project.id
  
  dynamic "ingress" {
    for_each = ["4200", "8080"]
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  tags = {
    "Name" = "public_sg"
  }
}

resource "aws_security_group" "allow_5672_8500" {
  vpc_id = aws_vpc.epam-project.id
  
  dynamic "ingress" {
    for_each = ["8500", "5672"]
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  tags = {
    "Name" = "private_sg"
  }
}

resource "aws_security_group" "allow_8082" {
  vpc_id = aws_vpc.epam-project.id
  ingress {
      from_port = 8082
      to_port = 8082
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "private_sg"
  }
}

resource "aws_security_group" "allow_8084" {
  vpc_id = aws_vpc.epam-project.id
  ingress {
      from_port = 8084
      to_port = 8084
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "private_sg"
  }
}

/*
resource "aws_security_group_rule" "web_to_api_egress" {
  type = "egress"  
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp" 
    source_security_group_id = "${aws_security_group.allow_8080_api.id}"
    security_group_id = "${aws_security_group.allow_4200_web.id}"
  
}
resource "aws_security_group" "allow_8080_api" {
  vpc_id = aws_vpc.epam-project.id
  name = "sg 8080 for api-gateway"
  egress {
    from_port        = 8082
    to_port          = 8084
    protocol         = "tcp"
    security_groups = [aws_security_group.allow_8082_8084.id]
  }
  tags = {
    "Name" = "allow_8080_api"
  }

  
}
resource "aws_security_group_rule" "from_web_to_api" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  security_group_id = "${aws_security_group.allow_8080_api.id}"
  source_security_group_id = "${aws_security_group.allow_4200_web.id}"
}

resource "aws_security_group" "allow_8082_8084" {
  vpc_id = aws_vpc.epam-project.id
  name = "sg 8082-8084 for service one/two"
  egress {
    from_port        = 5672
    to_port          = 5672
    protocol         = "tcp"
    security_groups = [aws_security_group.allow_5672.id]
  }
  tags = {
    "Name" = "allow_8082_8084"
  }
}

resource "aws_security_group_rule" "from_api_to_service_one_two" {
  type = "ingress"
  from_port = 8082
  to_port = 8084
  protocol = "tcp"
  security_group_id = "${aws_security_group.allow_8082_8084.id}"
  source_security_group_id = "${aws_security_group.allow_8080_api.id}"
}

resource "aws_security_group" "allow_5672" {
  vpc_id = aws_vpc.epam-project.id
  tags = {
    "Name" = "allow_5672"
  }
  
}

resource "aws_security_group_rule" "from_service_one_two_to_rabbitmq" {
  type = "ingress"
  from_port = 5672
  to_port = 5672
  protocol = "tcp"
  security_group_id = "${aws_security_group.allow_5672.id}"
  source_security_group_id = "${aws_security_group.allow_8082_8084.id}"

} */