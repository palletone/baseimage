#!/bin/bash
#######################################################
#                                                     #
# 文件:init.sh                                        #
# 作者:dev@palletone.com                              #
# 日期:2018-11-26                                     #
#                                                     #
#######################################################

# Beginning of file
echo "docker/init.sh Start execution"

#######################################################
# Install wget,tzdata
yum -y update -q
yum -y install wget tzdata

#######################################################

# End of file
echo "docker/init.sh end of execution"
