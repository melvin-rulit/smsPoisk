#FROM php:7.4-fpm
#FROM php:8.0-fpm
#FROM php:8.1-fpm
FROM php:8.2-fpm


# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Install sudo
RUN apt-get update \
    && apt-get install -y sudo \
    && rm -rf /var/lib/apt/lists/*

# Установка расширения Mysql
RUN docker-php-ext-install mysqli pdo_mysql

# Установка SQLite3 и необходимые библиотеки
RUN apt-get update \
    && apt-get install -y sqlite3 libsqlite3-dev \
    && docker-php-ext-install pdo_sqlite
    
# Обновление списка пакетов и установка необходимых инструментов
RUN apt-get update \
    && apt-get install -y libpq-dev \
    && docker-php-ext-install pdo_pgsql

# Устанавливаем PostgreSQL клиентские утилиты
RUN apt-get update && \
    apt-get install -y postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Установка утилиты ncat
RUN apt-get update \
    && apt-get install -y nmap

# Install MySQL client
RUN apt-get update && apt-get install -y mariadb-client

# Install and enable the Sodium extension separately
RUN apt-get update && \
    apt-get install -y libsodium-dev && \
    docker-php-ext-install sodium

# Установите зависимости и расширение Redis
RUN apt-get update && \
    apt-get install -y  && \
    pecl install redis && \
    docker-php-ext-enable redis

# Install the Imagick extension
RUN apt-get update && \
    apt-get install -y libmagickwand-dev && \
    pecl install imagick && \
    docker-php-ext-enable imagick

# Install the IMAP extension
RUN apt-get update && \
    apt-get install -y libc-client-dev libkrb5-dev && \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap

# Install the SOAP extension
RUN apt-get update && \
    apt-get install -y libxml2-dev && \
    docker-php-ext-install soap

# Install the ZIP extension and libzip
RUN apt-get update && \
    apt-get install -y zlib1g-dev libzip-dev && \
    docker-php-ext-install zip

# Install PHP extensions
RUN apt-get update && \
    docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

# Установка Node.js и npm из официальных репозиториев Debian
RUN apt-get update \
    && apt-get install -y nodejs npm

# 10. Xdebug
RUN pecl install xdebug && \
    docker-php-ext-enable xdebug

# xdebug
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions xdebug
ENV PHP_IDE_CONFIG 'serverName=xdebug'
RUN echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.start_with_request = yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.client_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.log=/var/log/xdebug.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.idekey = PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer


# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www

USER $user

