#!/usr/bin/env bash
#v2

if [ -e /vagrant/.loadedson ] ; then
	echo "You are loaded already. Get to work"
else

	#prepare database password
	export DEBIAN_FRONTEND=noninteractive
	mysql_pass='morgen'
	debconf-set-selections <<< 'mysql-server-5.1 mysql-server/root_password password '$mysql_pass''
	debconf-set-selections <<< 'mysql-server-5.1 mysql-server/root_password_again password '$mysql_pass''
	apt-get update
	# Let's install a bunch of things/stuff
	apt-get install -y python-software-properties

	#add php repo to install php 5.4
	add-apt-repository -y ppa:ondrej/php5-oldstable
	add-apt-repository -y ppa:ondrej/mysql-5.6
	https://launchpad.net/~ondrej/+archive/mysql-5.6
	add-apt-repository ppa:nginx/stable
	
	apt-get update 

	apt-get --purge remove mysql-common
	apt-get install -y --force-yes mysql-server 
	apt-get install -y --force-yes mysql-client

	sudo apt-get install -y vim-nox git libpcre3 libpcre3-dev make xvfb curl
	sudo apt-get install -y --force-yes -f nginx
	sudo apt-get install -y php5-fpm php5 php5-mysql php5-curl php5-gd php5-memcached \
							php5-gd php5-intl php5-imagick php5-imap php5-mcrypt php5-memcache \
							php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc \
							php5-xsl php5-xcache php-pear build-essential


	
	#lets install composer
	echo "Installing composer..."
	curl -sS https://getcomposer.org/installer | php
	mv composer.phar /usr/local/bin/composer
	echo "Composer installed"
	

	#ok lets copy over all of our configs and we are good to go
	cp /vagrant/server_configs/nginx/conf.d/php5.fpm.conf /etc/nginx/conf.d/
	#change nginx user to vagrant
	sed -i 's/user nginx/user vagrant/g' /etc/nginx/nginx.conf
	#change nginx worker connections
	sed -i 's/worker_connections 768/worker_connections 1024/g' /etc/nginx/nginx.conf

	#change nginx sendfile to off
	sed -i 's/sendfile on/sendfile off/g' /etc/nginx/nginx.conf

	#add the local environment to the fastcgi_params
	echo "fastcgi_param ENVIRONMENT    local;" >> /etc/nginx/fastcgi_params
	 
	#change php www.pool
	sed -i 's/user = vagrant/user = vagrant/g' /etc/php5/fpm/pool.d/www.conf 
	sed -i 's/group = vagrant/group = vagrant/g' /etc/php5/fpm/pool.d/www.conf

	#show php errors
	sed -i 's/display_errors = Off/display_errors = On/g' /etc/php5/fpm/php.ini

	#comment mysql conf lines to allow remote connection
	sed -i 's/skip-external-locking/#skip-external-locking/g' /etc/mysql/my.cnf
	sed -i 's/bind-address/#bind-address/g' /etc/mysql/my.cnf




	# cp /vagrant/server_configs/php5/fpm/php.ini /etc/php5/fpm/
	# cp /vagrant/server_configs/mysql/my.cnf /etc/mysql/my.cnf


	#double check we have the www folder in vagrant
	echo "Make sure we have  a www folder"
	if [ ! -d "/vagrant/www" ]
		then
		mkdir /vagrant/www
	fi

	# Symlink /vagrant/www/sites to /var/www if not done already (first run)
	echo "Symlink vagrant/www to var/www"
	if [ ! -d "/var/www" ]
	then
	    # chmod will most likely need to be done on the host machine. but just give it a shot.
	    chmod -R 0777 /vagrant
	    ln -s /vagrant/www /var/www
	    chmod -R 0777 /var/www
	fi

	# These might already be started, but just give it a shot.
	echo "Restarting everything"
	service nginx start
	service php5-fpm restart
	# service mysql restart

	#this file can create server blocks 
	echo "Setting up nxcreate";
	cp /vagrant/nxcreate /usr/bin
	chmod +x /usr/bin/nxcreate

	updatedb

	# once this file is created it will be checked on each vagrant up.
	# if this file exists there is no need to run this script again
	echo "if you remove this file vagrant will run bootstrap.sh on the next up even if all you did was halt." > /vagrant/.loadedson 

fi

#you know we always want to see the ascii
# Print out some dope ascii art son
sh /vagrant/welcome.sh
