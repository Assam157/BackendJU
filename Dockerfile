 FROM php:8.2-fpm

# Install system dependencies, curl, unzip, and libraries required by Composer
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    git  # Add git if necessary for Composer operations

# Install PHP extensions required for Laravel (e.g., GD for image processing, etc.)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd

# Install MongoDB extension
RUN pecl install mongodb && docker-php-ext-enable mongodb

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory inside the container
WORKDIR /var/www/html

# Copy application files into the container
COPY . .

# Add a new user and change ownership of the directory to that user
RUN useradd -ms /bin/bash myuser

# Switch to the 'www-data' user to avoid running as root
USER www-data

# Install Laravel dependencies using Composer
RUN /usr/local/bin/composer install --no-dev --optimize-autoloader

# Fix permissions to ensure the 'www-data' user has the right access
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Set the port environment variable
ENV PORT 8080

# Expose the port to be used by Laravel
EXPOSE 8080

# Use artisan to start the Laravel application on the correct port
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=$PORT"]


