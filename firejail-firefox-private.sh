sudo brctl addbr br-pri
sudo ifconfig br-pri 10.0.1.1 netmask 255.255.255.0
/usr/sbin/privoxy /home/kokoro/privoxy/ff-pri/config

firejail --dns=8.8.8.8 --profile=/home/kokoro/firefox.profile --private=/home/kokoro/firefox/pri/ --net=br-pri firefox
