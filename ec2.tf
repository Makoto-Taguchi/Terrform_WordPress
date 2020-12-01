# EC2 Launch Template
resource "aws_launch_template" "ec2_launch" {
  name          = "ec2_launch"
  image_id      = "ami-00f045aed21a55240"
  instance_type = "t2.micro"

  key_name = aws_key_pair.wp_ec2.id

  vpc_security_group_ids = [
    aws_security_group.ec2.id
  ]

  # EFS作成後にユーザデータを実行させるためtemplate_file使用
  user_data = base64encode(data.template_file.script.rendered)

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = "30"
      volume_type           = "gp2"
      delete_on_termination = "true"
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "wp_dev_ec2"
    }
  }

  tags = {
    Name = "wp_dev_ec2_lt"
  }
}

# User data用　Template File
data "template_file" "script" {
  template = file("script.tpl")
  vars = {
    efs_id = aws_efs_file_system.efs.id
  }
}


# EC2へのSSHログイン用キーペア
resource "aws_key_pair" "wp_ec2" {
  key_name   = "wp_ec2"
  public_key = file("./wp_ec2.pub")
}