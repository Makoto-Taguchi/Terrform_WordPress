# EFS Security Group ： インバウンドはEC2からのアクセスのみ許可
resource "aws_security_group" "efs" {
  name        = "wp_dev_sg_efs"
  description = "wp_dev_sg_efs"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port = 2049
    to_port   = 2049
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
    Name = "wp_dev_sg_efs"
  }
}