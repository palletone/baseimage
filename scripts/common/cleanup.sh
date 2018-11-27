#!/bin/bash
#######################################################
#                                                     #
# 文件:cleanup.sh                                     #
# 作者:dev@palletone.com                              #
# 日期:2018-11-26                                     #
#                                                     #
#######################################################

# Beginning of file
echo "common/cleanup.sh Start execution"

#######################################################
# clean up our environment
yum -y autoremove -q

# Yum clear
yum -y clean all -q

# Delete tempory files
rm -rf /tmp/* /var/tmp/*
#######################################################

# End of file
echo "common/cleanup.sh end of execution"

