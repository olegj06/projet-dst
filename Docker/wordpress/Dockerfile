#wordpress 1
FROM wordpress:latest


env    WORDPRESS_DB_HOST=mariadb
env    WORDPRESS_DB_NAME=wpdatabase
env    WORDPRESS_DB_USER=wpuser
env    WORDPRESS_DB_PASSWORD=wppassword


COPY Docker/wordpress/wp-config.php  /var/www/html/