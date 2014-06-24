#!/usr/bin/env bash

echo "Updating Packages"
apt-get update

echo "Setup MySQL password"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

echo "Install Base packages"
apt-get install -y vim curl python-software-properties curl git-core

echo "Add PHP 5.5 Repo"
add-apt-repository -y ppa:ondrej/pph5
apt-get update

echo "Install PHP"
apt-get install -y php5

echo "Install PHP dependencies"
apt-get install -y apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt mysql-server-5.5 php5-mysql php5-json drush

echo "Setup Xdebug"
apt-get install -y php5-xdebug

cat <<EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

echo "Enable mod-rewrite"
a2enmod rewrite

echo "Public Directory setup"
sudo rm -rf /var/www
sudo ln -fs /vagrant /var/www

echo "Enable error reporting"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_reporting = .*/display_errors = On/" /etc/php5/apache2/php.ini
sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf


echo "Restart Apache"
service apache2 restart

echo "Install Composer"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
