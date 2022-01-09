#!/bin/bash

mkdir -p "/package/python/lib/python3.7/site-packages"
cd "/package/python/lib/python3.7/site-packages"
cp "/package/requirements.txt" "/package/python/lib/python3.7/site-packages/requirements.txt"

python3.7 -m pip install -r $1 -t ./ || python3.7 -m pip install $1 -t ./