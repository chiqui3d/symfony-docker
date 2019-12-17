ARG PHP_VERSION=7.2
FROM php:${PHP_VERSION}-fpm

# Install selected extensions and other stuff

RUN apt-get update && apt-get install -y \
    cron \
    curl \
    gnupg \
    build-essential \
    python \
    xz-utils \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libxrender1 \
    libfontconfig1 \
    zlib1g \
    zlib1g-dev \
    libicu-dev \
    g++ \
    fontconfig \
    libfreetype6 \
    libx11-6 \
    libxext6 \
    wkhtmltopdf \
    jpegoptim \
    optipng \
    pngquant \
&& docker-php-ext-install -j$(nproc) iconv \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install -j$(nproc) gd \
&& docker-php-ext-configure intl \
&& docker-php-ext-install intl zip opcache pdo pdo_mysql mbstring mysqli \
&& pecl install apcu-5.1.18 \
&& docker-php-ext-enable apcu \
### composer ###
&& curl --insecure https://getcomposer.org/composer.phar -o /usr/bin/composer \
&& chmod +x /usr/bin/composer \
### wkhtmltopdf ###
&& cd /tmp \
    && curl https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb --location -o /tmp/wkhtmltox_buster.deb \
    && apt-get update \
    && apt-get install -y xfonts-75dpi \
    && dpkg -i ./wkhtmltox_buster.deb \
    && rm ./wkhtmltox_buster.deb

### clean ###
RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && apt autoremove -y

### php.ini ###
#RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
ADD ./docker/php-fpm/app.ini $PHP_INI_DIR/conf.d/
### php-fpm ###
RUN rm /usr/local/etc/php-fpm.d/www.conf \
   && rm /usr/local/etc/php-fpm.d/www.conf.default

### php-fpm-pool ###
COPY ./docker/php-fpm/app.pool.conf /usr/local/etc/php-fpm.d/www.conf

### cron ###
ADD ./docker/php-fpm/cron /var/spool/cron/crontabs/
RUN mkdir /var/log/cron
RUN touch /var/log/cron/cron.log
RUN crontab /var/spool/cron/crontabs/cron
RUN service cron restart
### user group ###
RUN groupmod -o -g 1000 www-data  \
    && usermod -o -u 1000 -g www-data www-data \
    && chown -R www-data:www-data /var/www

#COPY ./app /var/www/app

WORKDIR /var/www/app

CMD php-fpm -F && cron -f -l 8

EXPOSE 9000

