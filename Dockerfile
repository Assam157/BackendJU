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
RUN  apt-get install php7.2-mongodb

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory inside the container
WORKDIR /var/www/html

# Copy application files into the container
COPY . .

# Add a new user and change ownership of the directory to that user
RUN useradd -ms /bin/bash myuser

# Switch to the 'root' user temporarily for chown
USER root

# Change the ownership of files and directories to www-data (root is required here)
RUN chown -R www-data:www-data /var/www/html
# Switch back to the 'www-data' user for the rest of the operations
USER www-data

# Install Laravel dependencies using Composer
RUN /usr/local/bin/composer install --no-dev --optimize-autoloader   

# Ensure the permissions are correct after Composer installation
RUN chown -R www-data:www-data /var/www/html/vendor
RUN chmod -R 775 /var/www/html/vendor

# Set the port environment variable
ENV PORT 8080

# Expose the port to be used by Laravel
EXPOSE 8080

# Use artisan to start the Laravel application on the correct port
CMD ["sh", "-c", "php artisan serve --host=0.0.0.0 --port=${PORT:-8080}"]
