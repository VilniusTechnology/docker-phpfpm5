FROM php:5.6-fpm

MAINTAINER "Lukas Mikelionis" <lukas.mikelionis@vilnius.technology>

RUN apt-get update

# Install ZIP extension
RUN apt-get install -y php-pear
RUN apt-get install -y zziplib-bin
RUN pecl install "channel://pecl.php.net/zip-1.5.0"

# Install modules
RUN apt-get install -y \
    libmcrypt-dev  \
    libicu-dev \
    mysql-client \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install mysql \
    && docker-php-ext-install iconv \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install intl \
    && docker-php-ext-install opcache \
    && docker-php-ext-install sockets \
    && docker-php-ext-install mbstring

RUN apt-get install zlib1g-dev
RUN docker-php-ext-install zip

# Deploy git
RUN apt-get install -y git-all

RUN apt-get install -y php5-mongo
RUN apt-get install -y php5-xdebug

# Deploy php's dependency manager composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Deploy symfony installer.
RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
RUN chmod a+x /usr/local/bin/symfony

# Deploy Laravel installer
RUN composer global require "laravel/installer"
RUN ln -s /root/.composer/vendor/bin/laravel /usr/local/bin/laravel
RUN PATH=$PATH:/root/.composer/vendor/bin

#npm
RUN apt-get install -y nodejs
RUN apt-get install -y npm

# Cleanup
RUN apt-get clean && apt-get autoclean && apt-get autoremove

ADD ./ini/php.ini /usr/local/etc/php/php.ini
ADD ./entrypoint/entrypoint.sh /entrypoint/entrypoint.sh

VOLUME ["/var/www/"]

CMD ["/entrypoint/entrypoint.sh"]
