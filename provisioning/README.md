ANSIBLE INSTALL

INSTALLATION

Install Ansible

http://www.ansibleworks.com/docs/intro_installation.html

Install Vagrant 2.x

http://docs.vagrantup.com/v2/installation/index.html

Get a Vagrant Box

vagrant box add {name} {URL}

Here's some: http://www.vagrantbox.es/

Edit config in provisioning/config

Change: targpath to a directory you own
Change: trgvbox to the name of the vbox you want (this will be a directory)

Edit vagrant/Virtualbox

Set: config.vm.box to the {name} of the vbox you wish to use

Set any other params that excite you more than selma hayek did in Dusk til Dawn  or John Travolta in Saturday Night Fever depending IT'S ALL GOOD

NOW YOU READY RUN NUMBER ONE INSTALL:

./setup

Watch Pretty things happen!

When done! 

DO THIS ->>

vagrant package

Copy resulting file somewhere and let your friends melt in the glory of a large file containing a server.

Did your Ansible FAIL?! OH BOO HOO *CRY* 

./destroy && ./setup after you fix your stuff

HAVE A VERY MERRY CHRISTMAS LOVE BAD TODD



