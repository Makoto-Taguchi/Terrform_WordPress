# EC2 Security Group
resource "aws_security_group" "ec2" {
  name        = "wp_dev_sg_ec2"
  description = "wp_dev_sg_ec2"
  vpc_id      = aws_vpc.vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wp_dev_sg_ec2"
  }
}

//80番ポート(http)許可のインバウンドルール
resource "aws_security_group_rule" "inbound_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"
  //albセキュリティグループが紐づくリソースにアクセス許可
  source_security_group_id = aws_security_group.alb.id

  //ec2セキュリティグループに紐付け
  security_group_id = aws_security_group.ec2.id
}

//22番ポート(ssh)許可のインバウンドルール
resource "aws_security_group_rule" "inbound_ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  //ec2セキュリティグループに紐付け
  security_group_id = aws_security_group.ec2.id
}
