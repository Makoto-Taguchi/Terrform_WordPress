#!/bin/bash
yum update -y

#EFSマウント設定
yum install -y amazon-efs-utils
efs_id="${efs_id}"
echo "$efs_id:/ /var/www/html efs defaults,_netdev 0 0" >> /etc/fstab

#RDS for MySQL接続クライアントインストール
yum install -y php php-dom php-gd php-mysql
yum localinstall https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm -y
yum-config-manager --disable mysql80-community
yum-config-manager --enable mysql57-community
yum -y install mysql-community-client.x86_64

#/etc/fstabに記載がある全てのデバイスをマウント
mount -a

# WordPress初期化
# WordPress関連のフォルダが存在しなければ配置
if [ ! -e /var/www/html/wp-admin ]; then
  cd /tmp
  wget https://wordpress.org/wordpress-5.0.7.tar.gz
  tar xzvf /tmp/wordpress-5.0.7.tar.gz --strip 1 -C /var/www/html
  rm /tmp/wordpress-5.0.7.tar.gz
fi

#ファイルやディレクトリのユーザやグループを変更
chown -R apache:apache /var/www/html

#Apache自動起動を有効化
systemctl enable httpd

#Apache起動
systemctl start httpd
