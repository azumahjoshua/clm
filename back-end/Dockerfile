# Stage 1: Build environment
FROM php:8.3-cli AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    libpng-dev libjpeg-dev libfreetype6-dev \
    zip unzip libzip-dev \
    libpq-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd zip pdo_pgsql pgsql exif

WORKDIR /var/www

# First copy only what's needed for composer
COPY composer.json composer.lock ./

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer

# Install dependencies without running post-install scripts
RUN composer install \
    --no-dev \
    --optimize-autoloader \
    --no-interaction \
    --no-progress \
    --prefer-dist \
    --no-scripts  # <-- This skips the artisan commands

# Now copy the rest of the application
COPY . .

# Run post-install scripts manually after all files are copied
RUN composer run-script post-autoload-dump

# Stage 2: Production environment
FROM php:8.3-cli

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql-client \
    netcat-traditional \
    libpng16-16 \
    libjpeg62-turbo \
    libzip4 \
    libfreetype6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy application from builder
COPY --from=builder /var/www /var/www
COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/

WORKDIR /var/www

# Set permissions
RUN chown -R www-data:www-data /var/www \
    && mkdir -p storage/framework/{cache,sessions,views} \
    && chmod -R 775 storage bootstrap/cache

# Entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint"]

EXPOSE 8000
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
# # Stage 1: Build environment
# FROM php:8.3-cli AS builder

# # Install build dependencies
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     curl \
#     git \
#     libpng-dev libjpeg-dev libfreetype6-dev \
#     zip unzip libzip-dev \
#     libpq-dev \
#     && docker-php-ext-configure gd --with-freetype --with-jpeg \
#     && docker-php-ext-install -j$(nproc) gd zip pdo_pgsql pgsql exif

# # Enable required PHP extensions
# RUN docker-php-ext-enable gd zip exif

# WORKDIR /var/www
# COPY . /var/www

# RUN mkdir -p bootstrap/cache storage/framework/{sessions,views,cache} \
#     && chmod -R 775 bootstrap/cache storage \
#     && chown -R www-data:www-data bootstrap/cache storage

# # Install Composer and Laravel dependencies
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
#     && composer install --no-dev --optimize-autoloader --no-interaction --no-progress --prefer-dist

# # Stage 2: Production environment
# FROM php:8.3-cli

# # Install runtime dependencies
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     postgresql-client netcat-traditional \
#     libpng16-16 libjpeg62-turbo libzip4 libfreetype6 \
#     && apt-get clean && rm -rf /var/lib/apt/lists/*

# # Copy necessary files from builder stage
# COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
# COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
# COPY --from=builder /var/www /var/www

# WORKDIR /var/www

# RUN chown -R www-data:www-data /var/www \
#     && chmod -R 775 storage bootstrap/cache

# # Set entrypoint script
# COPY entrypoint.sh /usr/local/bin/entrypoint.sh
# RUN chmod +x /usr/local/bin/entrypoint.sh
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# # Expose port and run Laravel's built-in server
# EXPOSE 8000
# CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]