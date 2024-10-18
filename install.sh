#!/bin/bash

# Оновлення системи
sudo apt update
sudo apt upgrade -y

# Встановлення Apache
sudo apt install apache2 -y

# Встановлення MySQL
sudo apt install mysql-server -y
sudo mysql_secure_installation

# Встановлення PHP та розширень
sudo apt install php php-mysql libapache2-mod-php php-xml php-mbstring php-curl php-zip -y

# Перезапуск Apache
sudo systemctl restart apache2

# Завантаження останньої версії WordPress
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
sudo mv wordpress /var/www/html/

# Налаштування прав доступу
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo chmod -R 755 /var/www/html/wordpress

# Створення бази даних для WordPress
DB_NAME='wordpress'
DB_USER='wp_user'
DB_PASS='wp_password'

sudo mysql -e "CREATE DATABASE $DB_NAME;"
sudo mysql -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
sudo mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Налаштування WordPress
cd /var/www/html/wordpress
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/$DB_NAME/" wp-config.php
sed -i "s/username_here/$DB_USER/" wp-config.php
sed -i "s/password_here/$DB_PASS/" wp-config.php

# Завантаження та активація модуля mod_rewrite
sudo a2enmod rewrite
echo "<Directory /var/www/html/wordpress>
    AllowOverride All
</Directory>" | sudo tee -a /etc/apache2/apache2.conf

# Перезапуск Apache
sudo systemctl restart apache2

echo "LAMP stack і WordPress успішно встановлені та налаштовані!"
