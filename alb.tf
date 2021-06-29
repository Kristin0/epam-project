
resource "aws_alb" "web_alb" {
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.allow_4200_8080.id]
  subnets = aws_subnet.public.*.id
}


resource "aws_alb_target_group" "tg_web" {
  port     = 4200
  protocol = "HTTP"
  vpc_id   = aws_vpc.epam-project.id
}

resource "aws_lb_target_group_attachment" "tg_attach" {
  target_group_arn = aws_alb_target_group.tg_web.arn
  target_id        = aws_instance.web-api[0].id
  port             = 4200
}

resource "aws_lb_target_group_attachment" "tg_attach1" {
  target_group_arn = aws_alb_target_group.tg_web.arn
  target_id        = aws_instance.web-api[1].id
  port             = 4200
}

resource "aws_alb_listener" "listener_4200" {
  load_balancer_arn = aws_alb.web_alb.arn 
  port = 4200
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg_web.arn
  } 
}