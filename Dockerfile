FROM ubuntu:trusty
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && apt-get -y install lamp-server^ wget supervisor unzip pwgen mcrypt php5-mcrypt curl php5-curl php5-gd git
RUN DEBIAN_FRONTEND=noninteractive php5enmod mcrypt && mkdir /var/www/html
ADD adminer.php /var/www/html
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD start-apache2.sh /start-apache2.sh
ADD start-mysqld.sh /start-mysqld.sh
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
RUN chmod 755 /*.sh
RUN rm -rf /var/lib/mysql/*
EXPOSE 80 443 3306
RUN cd /var/www/ && git clone https://github.com/OpenMage/magento-mirror && rm html/index.html && mv magento-mirror/* html/ && mv magento-mirror/.* html/ && rm -r magento-mirror
RUN cd /var/www && chown -R www-data:www-data html 
ADD startupscript.sh /startupscript.sh
RUN chmod 755 /*.sh
CMD ["/startupscript.sh"]
