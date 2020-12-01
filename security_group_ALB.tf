# ELB Security Group
resource "aws_security_group" "alb" {
  name        = "wp_dev_sg_alb"
  description = "wp_dev_sg_alb"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "wp_dev_sg_alb"
  }
}