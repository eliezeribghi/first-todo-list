FROM php:8.3-fpm

# Définir le répertoire de travail
WORKDIR /app

# Installer les dépendances système
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev \
    libicu-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Installer les extensions PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip intl
RUN pecl install redis && docker-php-ext-enable redis

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copier les fichiers du projet
COPY . .

# Installer les dépendances PHP
RUN composer install --no-dev --optimize-autoloader

# Copier le fichier .env.example et générer la clé d'application
COPY .env.example .env
RUN php artisan key:generate

# Créer les dossiers nécessaires pour Laravel et définir les permissions
RUN mkdir -p storage/framework/sessions storage/framework/views storage/framework/cache bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache

# Mettre en cache la configuration et les routes
RUN php artisan config:cache \
    && php artisan route:cache

# Définir l'utilisateur
USER www-data

# Exposer le port 8000
EXPOSE 8000

# Utiliser une variable d'environnement pour choisir le mode
ARG APP_ENV=production
ENV APP_ENV=${APP_ENV}

# Lancer le conteneur selon le mode
CMD [ "/bin/sh", "-c", "if [ \"$APP_ENV\" = \"development\" ]; then tail -f /dev/null; else php artisan serve --host=0.0.0.0 --port=8000; fi" ]
