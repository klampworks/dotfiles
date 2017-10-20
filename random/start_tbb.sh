home=~/firejail/home/tbb-latest
sudo brctl addbr br-tbb
sudo ifconfig br-tbb 10.0.2.1 netmask 255.255.255.0
sudo tor -f ~/torrc

# dotfiles/random/update_tbb.sh generates this ./start_torbrowser.sh script
firejail --private="$home" --net=br-tbb ./start_torbrowser.sh
