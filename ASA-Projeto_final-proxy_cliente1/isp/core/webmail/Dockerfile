FROM php:8.2-fpm-bookworm

# 1. Instala dependências básicas do sistema
RUN apt-get update && apt-get install -y \
    libkrb5-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. Usa o script auxiliar para instalar o IMAP e outras extensões PHP
# Este script resolve automaticamente a falta do libc-client-dev
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions imap