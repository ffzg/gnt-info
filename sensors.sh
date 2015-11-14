test "$1" == 'install' && sudo gnt-cluster command apt-get install lm-sensors
sudo gnt-cluster command sensors
