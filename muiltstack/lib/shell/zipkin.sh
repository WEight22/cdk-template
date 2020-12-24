sudo yum update -y
sudo yum install -y git
sudo yum install -y docker
usermod -aG docker ec2-user
usermod -aG docker ssm-user
chmod +x /var/run/docker.sock
sudo service docker start
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
git clone https://github.com/WEight22/ZipkinDeploy.git
cd ZipkinDeploy
docker-compose up -d