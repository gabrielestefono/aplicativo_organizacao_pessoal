FROM ubuntu:20.04

# Evita mensagens de erro de frontend durante a instalação de pacotes
ARG DEBIAN_FRONTEND=noninteractive

# Atualiza os pacotes e instala dependências
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    software-properties-common \
    && apt-get clean

# Adiciona o repositório do PHP e instala o PHP 8.2 e extensões necessárias
RUN add-apt-repository ppa:ondrej/php -y && apt-get update && apt-get install -y \
    php8.2-cli \
    php8.2-fpm \
    php8.2-curl \
    php8.2-gd \
    php8.2-gettext \
    php8.2-intl \
    php8.2-mbstring \
    php8.2-exif \
    php8.2-mysqli \
    php8.2-mysql \
    php8.2-sqlite3 \
    php8.2-xml \ 
    php8.2-dom \ 
    && apt-get clean

# Instala o Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Cria o diretório para o seu projeto Laravel
WORKDIR /app

# Copie o código do seu projeto Laravel para o diretório /app
COPY . /app

# Instala as dependências do projeto Laravel
RUN composer install

# Exponha a porta 80 para o container
EXPOSE 80

# Inicie o servidor PHP-FPM
CMD ["php-fpm8.2", "-F"]
