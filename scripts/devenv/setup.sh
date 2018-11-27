#!/bin/bash
#######################################################
#                                                     #
# 文件:setup.sh                                       #
# 作者:dev@palletone.com                              #
# 日期:2018-11-26                                     #
#                                                     #
#######################################################

# Update system
yum -y update -q


# ----------------------------------------------------------------
# (1)Install docker
# ----------------------------------------------------------------
# remove old docker software
yum -y remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine container*

# set docker version
DOCKER_VER=17.03.2

# prep for docker install
yum install -y yum-utils device-mapper-persistent-data lvm2 bash-completion

#添加软件源信息
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

#更新并安装 Docker-CE
yum -y makecache all
version=$(yum list docker-ce.x86_64 --showduplicates | sort -r|grep ${DOCKER_VER}|awk '{print $2}')
yum -y install --setopt=obsoletes=0 docker-ce-${version} docker-ce-selinux-${version}

#设置开机启动
systemctl enable docker && systemctl start docker.service

# ----------------------------------------------------------------
# (2)Install python pip hehave nose
# ----------------------------------------------------------------
# Install python,libyaml
yum -y install python libyaml

# Install pip
yum -y install epel-release
yum -y install python-pip
pip install --upgrade pip
pip install behave nose docker-compose

# Install NPM for the SDK
yum -y install npm

# Download Gradle and create sym link
wget https://services.gradle.org/distributions/gradle-2.12-bin.zip -P /tmp --quiet
unzip -q /tmp/gradle-2.12-bin.zip -d /opt && rm /tmp/gradle-2.12-bin.zip
ln -s /opt/gradle-2.12/bin/gradle /usr/bin


# Download maven for supporting maven build in java chaincode
MAVEN_VERSION=3.3.9
mkdir -p /usr/share/maven /usr/share/maven/ref
curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz\
    | tar -xzC /usr/share/maven --strip-components=1\
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
