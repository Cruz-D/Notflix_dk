# Usa la imagen base oficial de PHP con FPM
FROM php:8.0-fpm

# Instala dependencias del sistema y extensiones de PHP
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql gd

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Define el directorio de trabajo en el contenedor
WORKDIR /var/www

# Copia los archivos de Laravel al contenedor
COPY . .

# Da permisos adecuados a los directorios de Laravel
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage \
    && chmod -R 755 /var/www/bootstrap/cache

# Instala las dependencias de Composer
RUN composer install --optimize-autoloader --no-dev

# Expone el puerto que usa PHP-FPM
EXPOSE 9000

# Comando por defecto
CMD ["php-fpm"]
