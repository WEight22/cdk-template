sudo yum update -y
sudo yum install -y docker
sudo yum install git -y
sudo usermod -aG docker ec2-user
sudo service docker start
sudo chmod +x /var/run/docker.sock
sudo usermod -aG docker ssm-user
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
git clone https://github.com/WEight22/SonarQube-docker-compose.git
sudo sysctl -w vm.max_map_count=262144
cd /SonarQube-docker-compose
docker-compose up -d
sudo su
sudo cat << EOF >> /etc/rc.local
sudo sysctl -w vm.max_map_count=262144
cd /SonarQube-docker-compose
docker-compose up -d
EOF