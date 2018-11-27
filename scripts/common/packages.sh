#!/bin/bash
#######################################################
#                                                     #
# 文件:packages.sh                                    #
# 作者:dev@palletone.com                              #
# 日期:2018-11-26                                     #
#                                                     #
#######################################################

# Install Development Tools
yum -y update -q
yum -y groupinstall "Development Tools"
