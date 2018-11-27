#!/bin/bash
#######################################################
#                                                     #
# 文件:init.sh                                        #
# 作者:dev@palletone.com                              #
# 日期:2018-11-26                                     #
#                                                     #
#######################################################

# Beginning of file
echo "common/init.sh Start execution"

#######################################################
# Update the entire system to the latest releases
yum -y update -q

# Install public key for bind-license
yum -y -q install bind-license 

# Install audit-libs
yum -y -q install audit-libs audit-libs-python

# Install Delta RPMs Problem
yum provides '*/applydeltarpm'
yum -y -q install deltarpm

#######################################################

# End of file
echo "common/init.sh end of execution"
