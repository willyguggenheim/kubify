#!/bin/bash

pwd
ls -trl
docker ps || true
./kubify _up_container
docker ps
sleep 9999999
