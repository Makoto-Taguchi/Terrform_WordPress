# apply後にコンソール表示する項目
//Webアクセス用にコンソール表示
output "elb_dns_name" {
  value = aws_lb.alb.dns_name
}

//WordPress設定用にコンソール表示
output "rds_endpoint" {
	value = aws_db_instance.rds.endpoint
}