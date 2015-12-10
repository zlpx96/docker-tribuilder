#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=C
export LANG=C
export LANGUAGE=C

# Setup apt sources
cat << EOF > /etc/apt/sources.list
deb http://archive.ubuntu.com/ubuntu/ precise main universe restricted
deb-src http://archive.ubuntu.com/ubuntu/ precise main universe restricted
deb http://archive.ubuntu.com/ubuntu/ precise-updates main universe restricted
deb-src http://archive.ubuntu.com/ubuntu/ precise-updates main universe restricted
deb http://archive.ubuntu.com/ubuntu/ precise-security main universe restricted
deb-src http://archive.ubuntu.com/ubuntu/ precise-security main universe restricted
EOF

# Add NodeJS source repo
wget -qO- https://deb.nodesource.com/setup_0.12 | bash -

# Add docker repo
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo deb https://apt.dockerproject.org/repo ubuntu-precise main >> /etc/apt/sources.list.d/docker.list

# Install a recent git
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys E1DD270288B4E6030699E45FA1715D88E1DF1F24
cat << EOF > /etc/apt/sources.list.d/git.list
deb http://ppa.launchpad.net/git-core/ppa/ubuntu precise main
deb-src http://ppa.launchpad.net/git-core/ppa/ubuntu precise main
EOF

# Install
apt-get update
apt-get install --no-install-recommends -y \
    git build-essential vim curl rsync nodejs xvfb xserver-xorg-video-dummy xserver-xorg-input-void netcat-openbsd docker-engine
rm -rf /var/lib/apt/lists/*

# Install docker-compose
wget -qO- https://github.com/docker/compose/releases/download/1.5.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Create air user
adduser --disabled-password --gecos "" air
echo 'export WINEDEBUG=fixme-all' >> ~air/setenv
adduser air docker

cat << EOF > /docker-init-win-jdk.sh
cd /home/air
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u71-b14/jdk-7u71-windows-i586.exe
wine jdk-7u71-windows-i586.exe
sleep 1
rm jdk-7u71-windows-i586.exe
EOF
chmod +x /docker-init-win-jdk.sh
su - air -c /docker-init-win-jdk.sh

AIR_SHORT_VERSION=`echo ${AIR_SDK_VERSION}|cut -d. -f1,2`

mkdir -p /opt/air_sdk
cd /opt/air_sdk
wget http://airdownload.adobe.com/air/win/download/${AIR_SHORT_VERSION}/AIRSDK_Compiler.zip
unzip AIRSDK_Compiler.zip
rm AIRSDK_Compiler.zip
echo 'export AIR_HOME=/opt/air_sdk' >> ~air/setenv

mkdir -p /opt/jdk
cd /opt/jdk
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u71-b14/jdk-7u71-linux-x64.tar.gz
tar xvzf jdk-7u71-linux-x64.tar.gz
rm /opt/jdk/jdk-7u71-linux-x64.tar.gz

echo 'export JAVA_HOME=/opt/jdk/jdk1.7.0_71' >> ~air/setenv
echo 'export PATH="/home/air/bin:$JAVA_HOME/bin:$PATH"' >> ~air/setenv

echo '. ~air/setenv' >> ~air/.bashrc

# Create the project source dir
mkdir -p /src
chown air:air /src

