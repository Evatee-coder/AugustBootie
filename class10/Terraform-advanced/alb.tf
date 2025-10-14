# target group for ALB
resource "aws_lb_target_group" "alb" {
  name        = "${var.environment}-${var.app}-alb-tg"
  port        = var.ecs-app-values["container_port"]
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold = "3"
    interval          = "90"
    protocol          = "HTTP"
    matcher           = "200-299"
    timeout           = "20"
    path              = "/login"
  }
}


# ALB itself
resource "aws_lb" "alb" {
  name               = "${var.environment}-${var.app}-alb"
  subnets            = [aws_subnet.public-1.id, aws_subnet.public-2.id]
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
}

# Open ALP listerner port for http on 80
resource "aws_lb_listener" "http_forward" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn #redirect to target group
  }
}


# ALB listener for https on 443 (Last piece of the pussle)

resource "aws_lb_listener" "https_forward" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06" # fixed value
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }

  lifecycle {
    create_before_destroy = false
  }
}



#ALB security group ( port 80 and 443 open to the world)
resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-${var.app}-alb-sg"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-${var.app}-alb-sg"
  }
}