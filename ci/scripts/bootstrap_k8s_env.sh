#!/usr/bin/env bash

MY_PATH="`dirname \"$0\"`"
source ${MY_PATH}/0_common_init.sh

echo "Bootstraping/Updating new/existing Environment"

for KUBIFY_ENVIRONMENT in $(git diff master --name-only | grep environments/*.yaml); do
	echo "Deploying environment ${KUBIFY_ENVIRONMENT}"
	kubify deploy_env $KUBIFY_ENVIRONMENT || echo "Failed to deploy environment ${KUBIFY_ENVIRONMENT}"
done