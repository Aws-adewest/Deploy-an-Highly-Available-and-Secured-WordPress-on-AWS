sudo apt update
sudo apt install apache2
sudo apt install php libapache2-mod-php php-mysql
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
sudo mv wordpress /var/www/html/
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo systemctl restart apache2
