sleep 30
sudo apt update && apt upgrade -y
sudo apt install wget curl -y
sudo curl -fsSL https://get.docker.com -o install-docker.sh
sh install-docker.sh
sudo service docker start
sudo mv /tmp/health_check.sh /health_check.sh