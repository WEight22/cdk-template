sudo yum update -y
sudo yum install -y docker
usermod -aG docker ec2-user
usermod -aG docker ssm-user
chmod +x /var/run/docker.sock
sudo service docker start
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo sysctl -w vm.max_map_count=262144
sudo reboot
sudo su ec2-user
cd ~
mkdir apm && cd apm
mkdir data
cat > docker-compose.yml << EOF
version: "3.8"
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.5.1
    ports:
      - 9200:9200
    environment:
      - node.name=elasticsearch
      - cluster.name=es-docker-cluster
      - discovery.seed_hosts=elasticsearch
      - cluster.initial_master_nodes=elasticsearch
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      nofile:
        soft: 65536
        hard: 65536
      memlock:
        soft: -1
        hard: -1
    volumes:
      - ./data:/usr/share/elasticsearch/data:rw
  kibana:
    image: docker.elastic.co/kibana/kibana:7.5.1
    depends_on:
      - elasticsearch
    ports:
      - 5601:5601
    environment:
      ELASTICSEARCH_HOSTS: http://elasticsearch:9200
    depends_on:
      - elasticsearch
  apm:
    image: docker.elastic.co/apm/apm-server:7.5.1
    depends_on:
      - kibana
    ports:
      - 8200:8200
    volumes:
      - ./apm-server.docker.yml:/usr/share/apm-server/apm-server.yml"
    environment:
      output.elasticsearch.hosts: '["elasticsearch:9200"]'
    depends_on:
      - elasticsearch
EOF
cat > apm-server.docker.yml << EOF
apm-server:
  host: "0.0.0.0:8200"
output.elasticsearch:
  hosts: ["elasticsearch:9200"]
EOF
docker-compose up -d
sudo su
sudo cat << EOF >> /etc/rc.local
sudo sysctl -w vm.max_map_count=262144
cd /SonarQube-docker-compose
docker-compose up -d
EOF
