FROM ubuntu
RUN apt-get update && apt-get install -y apache2 php5 libapache2-mod-php5 php5-curl php5-sqlite apache2-utils
RUN sed -i.bak 's/short_open_tag = Off/short_open_tag = On/g' /etc/php5/apache2/php.ini
RUN sed -i.bak 's/upload_max_filesize = 2M/upload_max_filesize = 1024M/g' /etc/php5/apache2/php.ini
RUN sed -i.bak 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf
COPY bitcub.conf /etc/apache2/sites-available/bitcub.conf
RUN mkdir /var/www/bitcub/
RUN a2dissite 000-default
RUN a2ensite bitcub
ADD https://github.com/logboost/bitcub/releases/download/1.1.4/bitcub-1.1.4.tar.gz /var/www/bitcub/bitcub.tar.gz
WORKDIR /var/www/bitcub/
RUN tar -zxvf bitcub.tar.gz
RUN echo "\r\n<Files "admin.php">\r\n Order allow,deny\r\n allow from all\r\n</Files>\r\n <FilesMatch \"admin.php\">\r\n AuthName \"Authentication required\"\r\n AuthType Basic\r\n AuthUserFile \"/etc/apache2/bitcub.htpasswd\"\r\n Require valid-user\r\n</FilesMatch>" >> .htaccess
RUN rm /var/www/bitcub/bitcub.tar.gz
VOLUME /var/www/bitcub/db/
VOLUME /var/www/bitcub/files/
RUN chown -R www-data:www-data /var/www/bitcub/
RUN usermod -u 1000 www-data
EXPOSE 80
COPY entrypoint.sh /entrypoint.sh
RUN chmod 555 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
