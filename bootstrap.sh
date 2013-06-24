#!/usr/bin/env bash


if [ -e /vagrant/.loadedson ] ; then
	echo "You are loaded already. Get to work"
else
	# Sources ya dig
	echo 'deb http://nginx.org/packages/ubuntu/ lucid nginx' >> /etc/apt/sources.list
	echo 'deb http://nginx.org/packages/ubuntu/ lucid nginx' >> /etc/apt/sources.list

	#add mariadb
	echo 'deb http://ftp.osuosl.org/pub/mariadb/repo/5.5/ubuntu precise main' >> /etc/apt/sources.list
	echo 'deb-src http://ftp.osuosl.org/pub/mariadb/repo/5.5/ubuntu precise main' >> /etc/apt/sources.list
	apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 1BB943DB


	#get ajenti shit
	echo 'deb http://repo.ajenti.org/debian main main' >> /etc/apt/sources.list
	wget http://repo.ajenti.org/debian/key -O- | sudo apt-key add -

	#prepare database password
	export DEBIAN_FRONTEND=noninteractive
	mysql_pass='morgen'
	debconf-set-selections <<< 'mysql-server-5.1 mysql-server/root_password password '$mysql_pass''
	debconf-set-selections <<< 'mysql-server-5.1 mysql-server/root_password_again password '$mysql_pass''

	#add php repo to install php 5.4
	add-apt-repository -y ppa:ondrej/php5

	# Let's install a bunch of things/stuff
	apt-get update
	apt-get install -y python-software-properties
	add-apt-repository ppa:nginx/stable
	apt-get install -y vim-nox
	apt-get install -y git
	apt-get install -y subversion
	apt-get install -y libpcre3 libpcre3-dev make
	apt-get install -y xvfb
	apt-get install -y wkhtmltopdf
	apt-get install -y curl
	apt-get install -y --force-yes nginx
	apt-get install -y php5-fpm
	apt-get install -y php5-mysql php5-curl php5-gd php5-intl php5-imagick php5-imap php5-mcrypt php5-memcache php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-xcache
	apt-get install -y memcached php-pear php5-memcached build-essential
	apt-get install -q -y libmariadbclient-dev libmariadbclient18 libmariadbd-dev libmysqlclient18 mariadb-client mariadb-client-5.5 mariadb-client-core-5.5 mariadb-common mariadb-server mariadb-server-5.5 mariadb-server-core-5.5 mariadb-test mariadb-test-5.5 mysql-common
	apt-get install ajenti
	printf "\n" | pecl install memcache
	printf "\n" | pecl install gd
	echo "extension=memcache.so" > sudo /etc/php5/fpm/php.ini

	#lets install composer
	echo "Installing composer..."
	curl -sS https://getcomposer.org/installer | php
	mv composer.phar /usr/local/bin/composer
	echo "Composer installed"

	echo "Create sites-available and sites-enabled"
	mkdir /etc/nginx/sites-available
	mkdir /etc/nginx/sites-enabled
	echo "Done creating sites-available and sites-enabled"
	

	#ok lets copy over all of our configs and we are good to go
	cp /vagrant/server_configs/nginx/conf.d/php5.fpm.conf /etc/nginx/conf.d/
	cp -R /vagrant/server_configs/nginx/global/ /etc/nginx/
	cp /vagrant/server_configs/nginx/nginx.conf /etc/nginx
	cp /vagrant/server_configs/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/
	cp /vagrant/server_configs/mysql/my.cnf /etc/mysql/my.cnf

	# Symlink /vagrant/www/sites to /var/www if not done already (first run)
	if [ ! -d "/var/www" ]
	then
	    # chmod will most likely need to be done on the host machine. but just give it a shot.
	    chmod -R 0777 /vagrant
	    ln -s /vagrant/www /var/www
	    chmod -R 0777 /var/www
	fi

	# These might already be started, but just give it a shot.
	service nginx start
	service php5-fpm restart
	#service mysql start

	#this file can create server blocks 
	cp /vagrant/nxcreate /usr/bin
	chmod +x /usr/bin/nxcreate

	updatedb

	#once this file is created it will be checked on each vagrant up.
	#if this file exists there is no need to run this script again
	echo "if you remove this file vagrant will run bootstrap.sh on the next up even if all you did was halt." > /vagrant/.loadedson 

fi

#you know we always want to see the ascii
# Print out some dope ascii art son
sh /vagrant/welcome.sh