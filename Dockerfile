FROM centos:latest

MAINTAINER Sylvio Cesar <sylvio.cesart@gmail.com>

#
# Import RPM GPG key to prevent warnings and Add EPEL Repository
#
RUN rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7 \
    && rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 \
    && yum -y install epel-release.noarch


RUN yum -y install \
    httpd \
    mod_ssl \
    php \
    php-cli \
    php-imap \
    php-ldap \
    php-mbstring \
    php-mcrypt \
    php-pecl-memcached \
    php-tidy \
    php-xml \
    php-gd \
    telnet \
    net-tools \
    && yum -y update bash \
    && rm -rf /var/cache/yum/* \
    && yum clean all

#
# UTC Timezone & Networking
#
RUN ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && echo "NETWORKING=yes" > /etc/sysconfig/network

#
# Global Apache configuration changes
#
RUN sed -i \
    -e 's~^#ExtendedStatus On$~ExtendedStatus On~g' \
    -e 's~^DirectoryIndex \(.*\)$~DirectoryIndex \1 index.php~g' \
    -e 's~^NameVirtualHost \(.*\)$~#NameVirtualHost \1~g' \
    /etc/httpd/conf/httpd.conf

#
# Global PHP configuration changes
#
RUN sed -i \
    -e 's~^;date.timezone =$~date.timezone = America/Sao_Paulo~g' \
    -e 's~^;user_ini.filename =$~user_ini.filename =~g' \
    /etc/php.ini

RUN echo '<?php phpinfo(); ?>' > /var/www/html/index.php

#
# Copy files into place
#
#ADD 

#
# Purge
#

RUN rm -rf /var/cache/{ldconfig,yum}/*

EXPOSE 80 443

CMD /usr/sbin/httpd -DFOREGROUND
