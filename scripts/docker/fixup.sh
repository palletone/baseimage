#!/bin/bash
#######################################################
#                                                     #
# 文件:fixup.sh                                       #
# 作者:dev@palletone.com                              #
# 日期:2018-11-26                                     #
#                                                     #
#######################################################

chgrp -R root /opt/gopath
chmod g+rw /opt/gopath

mkdir -p /var/palletone
chgrp -R root /var/palletone
chmod g+rw /var/palletone
