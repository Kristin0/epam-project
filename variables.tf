variable "region" {
  type = string
  default = "us-east-1"
}

variable "cidr_block" {
  description = "IP range for the VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  type = list
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  type = list
  default = ["10.0.4.0/24", "10.0.5.0/24"]
}

variable "allowed_ports" {
  type = list
  default = ["4200", "8080", "5672","8500", "8082", "8084"] 
}

variable "private_service_names" {
  type = list
  default = ["rabbitmq, consul", "service_one", "service_two"]
}

