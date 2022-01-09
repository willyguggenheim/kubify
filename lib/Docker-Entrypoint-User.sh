#!/bin/bash

USER_GROUP_ID=$(id -g)
USER_USER_ID=$(id -u)
uidentry=$(getent passwd $USER_USER_ID)
if [ -z "$uidentry" ] ; then     echo "$USER_USER_ID:x:$USER_USER_ID:$USER_GROUP_ID:anonymous uid:/tmp:/bin/false" >> /etc/passwd; fi
exec "$@"