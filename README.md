myvagrant
=========

**DISCLAIMER:
THIS IS NOT MEANT TO BE USED AS A PRODUCTION SERVER. 
THIS IS FOR LOCAL DEVELOPMENT ONLY. I WILL NOT BE RESPONSIBLE FOR 
ANYTHING THAT GOES WRONG WITH IT.**

This is my first working vagrant box. So I though I would share. 
I am working on learning puppet for my next box then might as well give chef a try after that.

Feel free to contact me with any questions or concerns. 

This box has...
* Ubuntu 12.04 LTS
* PHP-FPM 5.3.1
* MariaDB 5.5.32
* Nginx 1.4.2

Extras are...
* Composer
* Ajenti
* Git
* Subversion

Use the insecure_private_key.ppk to ssh in or you can just use 
username: vagrant
password: vagrant

When the box is created a file gets created called .loadedson
If this file exists in the directory then boostrap.sh will not run if you
vagrant halt and then up it again or do a vagrant reload.
If you would like the box to get rebuilt or if you make changes to bootstrap.sh you will need to delete this file. 

The welcome.sh file just displays some of the vagrant commands in the terminal. If it annoys you just remove it from the bootstrap.sh file. It is at the end.

By default the database password is morgen. 
This can be changed in the bootstrap.sh file.

There is also a bonus file (which works but is still a work in progress)
Once you vagrant up and ssh into your box you can can type

nxcreate
This will start a prompt to create your nginx server_block (if you are an apache person this would be your vhost file).
the questions asked are
* Enter site url. (this will be what you type in the browser silly)
* Enter root directory. (this is the sites folder within www)
* Enter files directory. (this is if you use a folder for public files for example public_html)
* Will the server block include an extra config directory. (I sometimes like to add a folder with specific site configs. put this directory in server_config/nginx and the script will copy it to where it needs to go)
* Will it force www. (will simply force the site to load www.example.com instead of example.com)
* Will it have pretty urls? (This will add a redirect that works with CodeIgniter and Laravel. Haven't tested with anything else)

This will create your server_block in sites_available and symlink it to sites-enabled and will reload nginx


If you want to be able to access mysql remotely log into mysql via ssh
then run this command
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'morgen' WITH GRANT OPTION;

