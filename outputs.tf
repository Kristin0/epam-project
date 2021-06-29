output "consul-rabbit-ip" {
  value = aws_instance.rabbit-consul.public_ip
}

output "web-api-ip" {
  value = aws_instance.web-api.*.public_ip
}

output "service-one-ip" {
  value = aws_instance.service-one.public_ip
}

output "service-two-ip" {
  value = aws_instance.service-two.public_ip
}

output "load_balacner_ip" {
  value = aws_alb.web_alb.dns_name
}