#!/bin/bash

KUBIFY_CI=1

service docker start || systemctl start docker

git_sha_short=$(git rev-parse --short HEAD)
mkdir -p ./._kubify_work

# HEAD = list files changes since the last commit
git diff --name-only HEAD > ./._kubify_work/files_changed.txt
while read files_changes_txt_line; do
  # echo "checking if service $files_changes_txt_line"
  if [[ $files_changes_txt_line =~ "backend" ]] || [[ $files_changes_txt_line =~ "frontend" ]]; then
      echo "$files_changes_txt_line"
  fi
done <./._kubify_work/files_changed.txt

# for filename in ./environments/*.yaml; do
#   echo "reading file $filename"
#   env_filename=$(basename "$filename")
#   profile=$(echo "$env_filename" | cut -d'.' -f1)
#   echo "deploying environment $profile"
# done

# yq write -i $1 "services.${service}.image" "${SHA}"
