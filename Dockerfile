FROM centos:latest

MAINTAINER SaigyoujiYuyuko233 <HGK-SaigyoujiYuyuko@outlook.com>

USER root
WORKDIR /root

RUN yum -y install wget epel-* g++ gcc gcc-c++ yum-utils

# PHP 72
RUN yum-config-manager --enable remi-php72
RUN yum -y install php72w
RUN systemctl start php72-php-fpm.service

# composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# mysql
RUN yum install mysql-community-server
RUN systemctl start mysqld
RUN mysql -e "create user 'travis'@'localhost' identified by '';"
RUN mysql -e "CREATE DATABASE IF NOT EXISTS travis;"

# phpunit
RUN wget -c https://phar.phpunit.de/phpunit-4.8.phar
RUN cp /home/hbu/phpunit-4.8.phar /usr/local/bin/phpunit
RUN chmod +x /usr/local/bin/phpunit

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \

systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;)

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/usr/sbin/init"]