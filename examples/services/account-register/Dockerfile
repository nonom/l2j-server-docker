FROM php:8.3-fpm-alpine

RUN docker-php-ext-install pdo_mysql

WORKDIR /var/www/html
COPY index.php /var/www/html/index.php
