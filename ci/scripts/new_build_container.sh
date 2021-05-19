#!/bin/bash

KUBIFY_CI=1

service docker start || systemctl start docker

git_sha_short=$(git rev-parse --short HEAD)
mkdir -p ./._kubify_work


build_new_base_image="0"
# HEAD = list files changes since the last commit
git diff --name-only HEAD > ./._kubify_work/files_changed.txt
while read files_changes_txt_line; do
  # echo "checking if service $files_changes_txt_line"
  if [[ $files_changes_txt_line =~ "tools" ]]; then
      echo "tools file changed $files_changes_txt_line"
      build_new_base_image="1"
  fi
done <./._kubify_work/files_changed.txt

  if [[ $build_new_base_image == "1" ]]; then
      echo "building new base image"
      ./kubify publish_cicd_build_image
  fi