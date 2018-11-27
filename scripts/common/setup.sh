#!/bin/bash
#######################################################
#                                                     #
# 文件:setup.sh                                       #
# 作者:dev@palletone.com                              #
# 日期:2018-11-26                                     #
#                                                     #
#######################################################

# Update the entire system to the latest releases
yum -y update -q

# install common tools
COMMON_TOOLS="git net-tools autoconf automake libtool curl make gcc gcc-c++ unzip kernel-devel"
yum -y install $COMMON_TOOLS

# Set Go environment variables needed by other scripts
export GOPATH="/opt/gopath"
export GOROOT="/opt/go"

# ----------------------------------------------------------------
# (1)Install Golang
# ----------------------------------------------------------------
mkdir -p $GOPATH
ARCH=`uname -m | sed 's|i686|386|' | sed 's|x86_64|amd64|'`
BINTARGETS="x86_64 ppc64le s390x"
GO_VER=1.10.4

# Install Golang binary if found in BINTARGETS
if echo $BINTARGETS | grep -q `uname -m`; then
   cd /tmp
   wget --quiet --no-check-certificate https://dl.google.com/go/go${GO_VER}.linux-${ARCH}.tar.gz
   tar -xvf go${GO_VER}.linux-${ARCH}.tar.gz
   mv go $GOROOT
   chmod 775 $GOROOT
# Otherwise, build Golang from source
else
   # Install Golang 1.9.4 binary as a bootstrap to compile the Golang GO_VER source
   yum -y install golang

   cd /tmp
   wget --quiet --no-check-certificate https://dl.google.com/go/go${GO_VER}.src.tar.gz
   tar -xzf go${GO_VER}.src.tar.gz -C /opt

   cd $GOROOT/src
   export GOROOT_BOOTSTRAP="/usr/lib/golang"
   ./make.bash
   yum -y remove golang
fi

PATH=$GOROOT/bin:$GOPATH/bin:$PATH

echo "######Configure GoLang Enviroment-beg######" >> /etc/profile
echo "export GOROOT=$GOROOT" >> /etc/profile
echo "export GOPATH=$GOPATH" >> /etc/profile
echo "export PATH=$PATH:$GOROOT/bin:$GOPATH/bin" >> /etc/profile
echo "######Configure GoLang Enviroment-end######" >> /etc/profile
source /etc/profile


# ----------------------------------------------------------------
# (2)Install NodeJS
# ----------------------------------------------------------------
NODE_VER=8.11.3

ARCH=`uname -m | sed 's|i686|x86|' | sed 's|x86_64|x64|'`
NODE_PKG=node-v$NODE_VER-linux-$ARCH.tar.gz
SRC_PATH=/tmp/$NODE_PKG

# First remove any prior packages downloaded in case of failure
cd /tmp
rm -f node*.tar.gz
wget --quiet https://nodejs.org/dist/v$NODE_VER/$NODE_PKG
cd /usr/local && tar --strip-components 1 -xzf $SRC_PATH

# Install python2.7
yum -y install python


# Make our versioning persistent
echo $BASEIMAGE_RELEASE > /etc/palletone-baseimage-release
