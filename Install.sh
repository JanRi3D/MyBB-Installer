#!/bin/bash

# Ask for the MySQL database password
read -s -p "Enter a password for the MySQL database: " db_password
echo

# Install required packages
apt update
apt install unzip apache2 php php-mysql mariadb-server php-gd php-mbstring php-xml -y

# Download and unzip MyBB
wget https://resources.mybb.com/downloads/mybb_1836.zip
unzip mybb_1836.zip

# Move MyBB files to the web server directory
mv Upload /var/www/MyBB
mv /var/www/MyBB/inc/config.default.php /var/www/MyBB/inc/config.php

# Set permissions
chmod 666 /var/www/MyBB/inc/config.php /var/www/MyBB/inc/settings.php
chmod -R 777 /var/www/MyBB/cache/ /var/www/MyBB/uploads/ /var/www/MyBB/uploads/avatars/ /var/www/MyBB/admin/backups/
chmod 666 /var/www/MyBB/inc/languages/english/*.php /var/www/MyBB/inc/languages/english/admin/*.php

# Create MySQL database and user
mysql -e "CREATE DATABASE MyBB;"
mysql -e "CREATE USER 'MyBB'@'localhost' IDENTIFIED BY '$db_password';"
mysql -e "GRANT ALL ON MyBB.* TO 'MyBB'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Configure Apache
sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/MyBB/' /etc/apache2/sites-enabled/000-default.conf

# Restart Apache
systemctl restart apache2

# Clear the terminal
clear

# Prompt user to complete setup
echo "Please open a web browser and navigate to your server's IP address to complete the MyBB setup."
read -p "Press Enter to continue after setup is complete..."

# Remove the installation directory
rm -r /var/www/MyBB/install

# Script completed
echo "MyBB installation and setup are complete!"
