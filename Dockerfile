FROM debian:jessie

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
    && php5-pdo_mysql \
    && php5-mysqli \
    && php5-mysql \
    && php5-iconv \
    && php5-mcrypt \
    && php5-bcmath \
    && php5-intl \
    && php5-opcache \
    && php5-mbstring
    
RUN apt-get install -y -qq php5-mongo
RUN apt-get install -y -qq php5-xdebug
RUN apt-get install -y -qq php5-apcu
RUN apt-get install -y -qq php5-common 
RUN apt-get install -y -qq php5-cli
RUN apt-get install -y -qq php5-fpm

# Deploy git
RUN apt-get install -y -qq git-all

# Install Xdebug
RUN pecl install xdebug

RUN curl -SL "http://xdebug.org/files/xdebug-2.4.0rc2.tgz" -o xdebug.tgz
RUN tar zxvf xdebug.tgz
RUN cd xdebug-2.4.0RC2 && \
    phpize && \
    ./configure && \
    make && \
    cp modules/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20151012

# Deploy php's dependency manager composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Deploy symfony installer.
RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
RUN chmod a+x /usr/local/bin/symfony

# Deploy Laravel installer
RUN composer global require "laravel/installer"
RUN ln -s /root/.composer/vendor/bin/laravel /usr/local/bin/laravel
RUN PATH=$PATH:/root/.composer/vendor/bin

# Cleanup
RUN apt-get clean && apt-get autoclean && apt-get autoremove

ADD ./ini/php.ini /usr/local/etc/php/php.ini
ADD ./entrypoint/entrypoint.sh /entrypoint/entrypoint.sh

VOLUME ["/var/www/"]

CMD ["/entrypoint/entrypoint.sh"]
