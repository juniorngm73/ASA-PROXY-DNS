FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    libc-client-dev \
    libkrb5-dev \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap mysqli pdo pdo_mysql