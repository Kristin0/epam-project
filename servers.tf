
data "aws_ami" "ubuntu" {
  most_recent  = true 
  owners = [ "099720109477" ]
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

 

resource "aws_instance" "web-api" {
  count = length(aws_subnet.public)
  subnet_id = aws_subnet.public.*.id[count.index]
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.allow_4200_8080.id}"]
  tags = {
    Name = "web-api"
  }
}

resource "aws_instance" "rabbit-consul" {
  subnet_id = aws_subnet.private.*.id[0]
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.allow_5672_8500.id}"]
  tags = {
    "Name" = "rabbit-consul"
  }
}

resource "aws_instance" "service-one" {
  subnet_id = aws_subnet.private.*.id[1]
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.allow_8084.id}"]
  tags = {
    "Name" = "service-one"
  }
}

resource "aws_instance" "service-two" {
  subnet_id = aws_subnet.private.*.id[2]
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.allow_8082.id}"]
  tags = {
    "Name" = "service-two"
  }
}