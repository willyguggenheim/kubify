#!/usr/bin/env bash

MY_PATH="`dirname \"$0\"`"
source ${MY_PATH}/0_common_init.sh

echo "Deploying Services that have been altered in this commit"

for service_path in $(git diff master --name-only | grep backend | cut -d/ -f 1-2 | uniq)
do
    echo "CICD found a backend service with changes (in this commit's changes) ${service_path}," 
    	 "so CICD is now building, versioning, publishing and deploying it to dev:"
    cd ${service_path}
    GITHUB_SHORT_SHA=$(git rev-parse --short HEAD)
    kubify publish "HEAD,${GITHUB_SHORT_SHA}"
done

for service_path in $(git diff master --name-only | grep frontend | cut -d/ -f 1-2 | uniq)
do
    echo "CICD found a frontend service with changes (in this commit's changes) ${service_path}," 
    	 "so CICD is now building, versioning, publishing and deploying it to dev:"
    cd ${service_path}
    GITHUB_SHORT_SHA=$(git rev-parse --short HEAD)
    kubify publish "HEAD,${GITHUB_SHORT_SHA}"
done
