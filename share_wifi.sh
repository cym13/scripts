sudo sysctl -w net.ipv4.ip_forward=1
sudo ip l set up dev enp3s0 && sudo ip a a 10.0.0.1/24 dev enp3s0
sudo iptables -t nat -A POSTROUTING -j MASQUERADE -s 10.0.0.0/24 #-o wlp2s0

# Other
#
# ip l set up dev eth0
# ip a a 10.0.0.1/24 up
# ifconfig eth0 10.0.0.2/24 up
# ip r a default via 10.0.0.1
