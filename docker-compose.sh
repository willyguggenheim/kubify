#!/bin/bash

pwd
ls -trl
docker ps || true
./kubify _up_container
docker ps
echo "this container stays up, so running sleep forever"
sleep 9999999
