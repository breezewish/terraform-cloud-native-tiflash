# This script is executed on the center server

# install tiup
curl --proto '=https' --tlsv1.2 -sSf https://tiup-mirrors.pingcap.com/install.sh | sh

# install haproxy
sudo apt install -y haproxy mysql-client
sudo cp ~/haproxy.cfg /etc/haproxy/haproxy.cfg
sudo systemctl restart haproxy

# install go-tpc
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/pingcap/go-tpc/master/install.sh | sh
