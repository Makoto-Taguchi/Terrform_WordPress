# RDS Security Group : EC2からのアクセスのみ許可
resource "aws_security_group" "rds" {
  name        = "wp_dev_sg_rds"
  description = "wp_dev_sg_rds"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    //ec2セキュリティグループが紐づくリソースからアクセス許可
    security_groups = [aws_security_group.ec2.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wp_dev_sg_rds"
  }
}
