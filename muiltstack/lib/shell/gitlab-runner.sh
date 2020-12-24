sudo yum update -y 
sudo yum install -y docker
usermod -aG docker ec2-user
service docker start
chmod +x /var/run/docker.sock
service docker restart &&  chkconfig docker on
docker run -d -v /home/ec2-user/.gitlab-runner:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock --name gitlab-runner-register gitlab/gitlab-runner:alpine register --non-interactive --url https://gitlab.com/ --registration-token XXXXXXXXXXXX --docker-pull-policy if-not-present --docker-volumes /var/run/docker.sock:/var/run/docker.sock --executor docker --docker-image alpine:latest --description DockerRunner --tag-list tag1,tag2,tag3 --docker-privileged
sleep 2 && docker run --restart always -d -v /home/ec2-user/.gitlab-runner:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock --name gitlab-runner gitlab/gitlab-runner:alpine
usermod -aG docker ssm-user