#wordpress 1
FROM wordpress:latest


env    WORDPRESS_DB_HOST=mariadb
env    WORDPRESS_DB_NAME=wp_database
env    WORDPRESS_DB_USER=wp_user
env    WORDPRESS_DB_PASSWORD=wp_password


COPY Docker/wordpress/wp-config.php  /var/www/html/