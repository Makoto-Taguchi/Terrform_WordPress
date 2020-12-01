# ALB作成
resource "aws_lb" "alb" {
  name               = "wp-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups = [
    aws_security_group.alb.id
  ]
  # ALBが所属するサブネット → クロスAZで負荷分散
  subnets = [
    aws_subnet.sub_pub_1a.id,
    aws_subnet.sub_pub_1c.id
  ]
}

# リスナー
resource "aws_lb_listener" "elb_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.ec2_http.arn
    type             = "forward"
  }
}

# ターゲットグループ
resource "aws_lb_target_group" "ec2_http" {
  name     = "wp-dev-alb-tg-http"

  # ルーティング先指定
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    interval            = 10
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  # スティッキーセッションの設定
  stickiness {
    # Cookieの有効期間：30分
    cookie_duration = 1800
    enabled         = true
    type            = "lb_cookie"
  }
}

# オートスケーリンググループ
resource "aws_autoscaling_group" "ec2_ag" {
  name                      = "wp_dev_ec2_ag"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2

  vpc_zone_identifier = [
    aws_subnet.sub_pub_1a.id,
    aws_subnet.sub_pub_1c.id
  ]

  # 起動テンプレートを基に、EC2を起動
  launch_template {
    id      = aws_launch_template.ec2_launch.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.ec2_http.arn]
}