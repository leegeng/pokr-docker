# pokr-docker
Pokr-Docker is a Dockerfile that encapsulate a Pokr instance.

# Requirements
* Docker
* Ubuntu 16.04 or later

# Installation
## Docker Install
Please install docker by running the following commands. For detailed explanation, please refer to this [link](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04).

~~~ bash
sudo apt-get update
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
apt-cache policy docker-engine
sudo apt-get install -y docker-engine
sudo systemctl status docker
~~~
## Forking Pokr-Docker Git
~~~ bash
git clone https://github.com/teampopong/pokr-docker.git
~~~
## Building a Pokr-Docker container
~~~ bash
sudo docker build -t pokr .
~~~
