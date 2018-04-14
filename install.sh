#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

echo "================ Installing locales ======================="
apt-get clean && apt-get update
apt-get install -q locales=2.23*

dpkg-divert --local --rename --add /sbin/initctl
locale-gen en_US en_US.UTF-8
dpkg-reconfigure locales

echo "HOME=$HOME"
cd /u16

echo "================= Updating package lists ==================="
apt-get update

echo "================= Adding some global settings ==================="
mv gbl_env.sh /etc/profile.d/
mkdir -p "$HOME/.ssh/"
mv config "$HOME/.ssh/"
mv 90forceyes /etc/apt/apt.conf.d/
touch "$HOME/.ssh/known_hosts"
mkdir -p /etc/drydock

echo "================= Installing basic packages ==================="
apt-get install -q -y \
  build-essential=12.1* \
  curl=7.47.0* \
  gcc=4:5.3.1* \
  gettext=0.19.7* \
  libxml2-dev=2.9.3* \
  libxslt1-dev=1.1.28* \
  make=4.1* \
  nano=2.5.3* \
  openssh-client=1:7.2p2* \
  openssl=1.0.2g* \
  software-properties-common=0.96.20.7 \
  sudo=1.8.16*  \
  texinfo=6.1.0* \
  zip=3.0* \
  unzip=6.0-20ubuntu1 \
  wget=1.17.1* \
  rsync=3.1.1* \
  psmisc=22.21* \
  netcat-openbsd=1.105* \
  vim=2:7.4.1689*

echo "================= Installing Git ==================="
add-apt-repository ppa:git-core/ppa -y
apt-get update
apt-get install -q -y git=1:2.16.2*


echo "================= Adding JQ 1.5.1 ==================="
apt-get install -q jq=1.5*

echo "================= Installing Java 1.8.0 ==================="
. /u16/java/install.sh

echo "================ Installing apache-maven-3.5.2 ================="
wget -nv http://redrockdigimark.com/apachemirror/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz
tar xzf apache-maven-3.5.2-bin.tar.gz -C /usr/local && rm -f apache-maven-3.5.2-bin.tar.gz
ln -fs /usr/local/apache-maven-3.5.2/bin/mvn /usr/bin
echo 'export PATH=$PATH:/usr/local/apache-maven-3.5.2/bin' >> /etc/drydock/.env

echo "================ Adding ansible 2.4.3.0 ===================="
sudo pip install -q 'ansible==2.4.3.0'

echo "================ Adding boto 2.48.0 ======================="
sudo pip install -q 'boto==2.48.0'

echo "================ Adding boto3 ======================="
sudo pip install -q 'boto3==1.6.16'

export PK_VERSION=1.2.2
echo "================ Adding packer $PK_VERSION  ===================="
export PK_FILE=packer_"$PK_VERSION"_linux_amd64.zip

echo "Fetching packer"
echo "-----------------------------------"
rm -rf /tmp/packer
mkdir -p /tmp/packer
wget -nv https://releases.hashicorp.com/packer/$PK_VERSION/$PK_FILE
unzip -o $PK_FILE -d /tmp/packer
sudo chmod +x /tmp/packer/packer
mv /tmp/packer/packer /usr/bin/packer

echo "Added packer successfully"
echo "-----------------------------------"

echo "================= Intalling Shippable CLIs ================="

git clone https://github.com/Shippable/node.git nodeRepo
./nodeRepo/shipctl/x86_64/Ubuntu_16.04/install.sh
rm -rf nodeRepo

echo "Installed Shippable CLIs successfully"
echo "-------------------------------------"

echo "================= Cleaning package lists ==================="
apt-get clean
apt-get autoclean
apt-get autoremove
