#!/bin/bash

apt-get update

apt-get install -y vim curl python-software-properties

add-apt-repository -y ppa:ondrej/php5

apt-get install -y php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt mysql-server-5.5 php5-mysql git-core drush

apt-get install -y php5-xdebug

cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF


a2enmod rewrite


rm -rf /var/www
ln -fs /vagrant/public /var/www


sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini


sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf



service apache2 restart

curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer


