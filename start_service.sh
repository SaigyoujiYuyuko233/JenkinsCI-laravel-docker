#!/usr/bin/env bash

echo "start the php-fpm service"
serivce php72-php-fpm.service start

echo "start mysql service"
serivce mysqld start

echo "init the mysql"
mysql -e "create user 'travis'@'localhost' identified by '';"
mysql -e "CREATE DATABASE IF NOT EXISTS travis;"

echo "using the bash..."
/bin/bash