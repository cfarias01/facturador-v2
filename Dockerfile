# syntax=docker/dockerfile:1

#######################################
# Stage 1: build de assets (Vite)
#######################################
FROM node:20-alpine AS frontend

# canvas (dependencia declarada en package.json, sin uso directo confirmado
# en el codigo) necesita herramientas nativas de compilacion para instalar.
RUN apk add --no-cache python3 make g++ pkgconfig cairo-dev pango-dev jpeg-dev giflib-dev

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY vite.config.js ./
COPY resources/ resources/
COPY public/ public/
COPY modules/ modules/

RUN npm run build

#######################################
# Stage 2: aplicacion PHP (Apache)
#######################################
FROM php:8.4-apache AS app

# Extensiones de sistema necesarias por las extensiones PHP de abajo, y por
# el codigo real de la app (firma XML/SOAP hacia el SRI, generacion de
# PDF/QR/codigos de barra, Excel via phpoffice/phpspreadsheet).
#
# xml/dom/simplexml/xmlreader/xmlwriter/openssl NO se instalan aca: ya vienen
# compilados por defecto en la imagen base php:8.4-apache. Si se agregan a
# docker-php-ext-install fallaria el build (no hay fuente que compilar para
# una extension que ya es parte del core).
RUN apt-get update && apt-get install -y --no-install-recommends \
        libzip-dev \
        libxml2-dev \
        libonig-dev \
        libicu-dev \
        libpng-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        libcurl4-openssl-dev \
        unzip \
        git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j"$(nproc)" \
        pdo_mysql \
        soap \
        gd \
        zip \
        mbstring \
        bcmath \
        intl \
        curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Driver de SQL Server (pdo_sqlsrv/sqlsrv), necesario por
# app/Services/IntegradorService.php: la sincronizacion con ICG (sistema
# contable externo) se conecta a una BD SQL Server distinta por tenant
# (Company::sql_host/sql_db), driver 'sqlsrv' -- no tiene nada que ver con
# la BD MySQL principal de la app. Requiere el paquete msodbcsql18 de
# Microsoft (no esta en los repos de Debian) mas las extensiones via PECL
# (no hay fuente en php-src para docker-php-ext-install). Microsoft Drivers
# 5.13.0 es la primera version con soporte oficial GA para PHP 8.4.
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        gnupg2 \
        apt-transport-https \
        unixodbc-dev \
    && curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg \
    && curl -sSL https://packages.microsoft.com/config/debian/12/prod.list \
        | sed 's!deb !deb [signed-by=/usr/share/keyrings/microsoft-prod.gpg] !' \
        > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql18 \
    && pecl install sqlsrv-5.13.0 pdo_sqlsrv-5.13.0 \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite \
    && sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!/var/www/html/public!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .
COPY --from=frontend /app/public/build public/build

RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress \
    && chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R ug+rwx storage bootstrap/cache

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
# sed -i 's/\r$//' por si el archivo llega con CRLF (Windows): un
# "#!/bin/sh\r" no es un shebang valido y el contenedor no arranca.
RUN sed -i 's/\r$//' /usr/local/bin/entrypoint.sh && chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD ["apache2-foreground"]
