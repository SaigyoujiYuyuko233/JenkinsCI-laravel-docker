#!/usr/bin/env bash

echo "start the php-fpm service"
systemctl start php72-php-fpm.service

echo "start mysql service"
systemctl start mysqld

echo "init the mysql"
mysql -e "create user 'travis'@'localhost' identified by '';"
mysql -e "CREATE DATABASE IF NOT EXISTS travis;"

echo "using the bash..."
/usr/sbin/init
/bin/bash