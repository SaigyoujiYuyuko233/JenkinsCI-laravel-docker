FROM centos:latest

MAINTAINER SaigyoujiYuyuko233 <HGK-SaigyoujiYuyuko@outlook.com>

USER root
WORKDIR /root

ENV container docker

RUN yum -y install wget epel-* g++ gcc gcc-c++ yum-utils net-tools unzip; yum -y update

# PHP 72
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
RUN yum-config-manager --enable remi-php72
RUN yum -y install php72w php72w-cli php72w-fpm php72w-common php72w-devel php72w-embedded php72w-gd php72w-mbstring php72w-mysqlnd php72w-opcache php72w-pdo php72w-xml

# composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# mysql
RUN wget http://mirror.centos.org/centos/7/os/x86_64/Packages/libaio-0.3.109-13.el7.x86_64.rpm
RUN rpm -ivh libaio-0.3.109-13.el7.x86_64.rpm
RUN yum -y install numactl

RUN wget https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.25-1.el7.x86_64.rpm-bundle.tar
RUN tar -xvf mysql-5.7.25-1.el7.x86_64.rpm-bundle.tar

RUN rpm -ivh mysql-community-common-5.7.25-1.el7.x86_64.rpm
RUN rpm -ivh mysql-community-libs-5.7.25-1.el7.x86_64.rpm
RUN rpm -ivh mysql-community-client-5.7.25-1.el7.x86_64.rpm
RUN rpm -ivh mysql-community-server-5.7.25-1.el7.x86_64.rpm

# phpunit
RUN wget -c https://phar.phpunit.de/phpunit-4.8.phar
RUN cp phpunit-4.8.phar /usr/local/bin/phpunit
RUN chmod +x /usr/local/bin/phpunit

COPY start_service.sh /root

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done);rm -f /lib/systemd/system/multi-user.target.wants/*;rm -f /etc/systemd/system/*.wants/*;rm -f /lib/systemd/system/local-fs.target.wants/*;rm -f /lib/systemd/system/sockets.target.wants/*udev*;rm -f /lib/systemd/system/sockets.target.wants/*initctl*;rm -f /lib/systemd/system/basic.target.wants/*;rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME ['/sys/fs/cgroup']

ENTRYPOINT /bin/bash start_service.sh
