# EFS作成
resource "aws_efs_file_system" "efs" {
  tags = {
    Name = "wp-dev-efs"
  }
}

# AZの1aと1cにEFSにマウントする
# EFS Mount Target 1a
resource "aws_efs_mount_target" "efs_1a" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.sub_pub_1a.id
  security_groups = [aws_security_group.efs.id]
}

# EFS Mount Target 1c
resource "aws_efs_mount_target" "efs_1c" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.sub_pub_1c.id
  security_groups = [aws_security_group.efs.id]
}