#!/usr/bin/env bash


set -e

# https://github.com/arkane-systems/genie/releases
# "1.29" for example, or latest is "v1.36" (they started using a "v" prefix, similar to k8s things)
GENIE_VERSION="1.29" # update if you need
GENIE_FILE="systemd-genie_${GENIE_VERSION}_amd64"
GENIE_FILE_PATH="/tmp/${GENIE_FILE}.deb"
GENIE_DIR_PATH="/tmp/${GENIE_FILE}"

function installDebPackage() {
  # install repackaged systemd-genie
  sudo dpkg -i "${GENIE_FILE_PATH}"

  rm -rf "${GENIE_FILE_PATH}"
}

function fixDebDependencies() {
  # repackage systemd-genie to require dotnet 5.0 instead of 3.0
  rm -rf "${GENIE_DIR_PATH}"
  mkdir -p "${GENIE_DIR_PATH}"

  dpkg-deb -x "${GENIE_FILE_PATH}" "${GENIE_DIR_PATH}"

  pushd "${GENIE_DIR_PATH}"

  dpkg-deb -e "${GENIE_FILE_PATH}"

  popd

  echo "INFO: before dotnet-runtime version regex"
  cat "${GENIE_DIR_PATH}/DEBIAN/control" | grep dotnet-runtime
  sed -i 's/dotnet-runtime-3[.]0/dotnet-runtime-5.0/g' "${GENIE_DIR_PATH}/DEBIAN/control"
  echo "INFO: after dotnet-runtime version regex"
  cat "${GENIE_DIR_PATH}/DEBIAN/control" | grep dotnet-runtime

  rm -f "${GENIE_FILE_PATH}"

  pushd /tmp

  dpkg-deb -b "${GENIE_DIR_PATH}" 

  popd

  rm -rf "${GENIE_DIR_PATH}"
}

function downloadDebPackage() {
  rm -f "${GENIE_FILE_PATH}"

  pushd /tmp

  wget --content-disposition \
    "https://github.com/arkane-systems/genie/releases/download/${GENIE_VERSION}/${GENIE_FILE}.deb"

  popd
}

function installDependencies() {
  # install systemd-genie dependencies
  sudo apt-get update
  sudo apt -y --fix-broken install
  sudo apt-get update

  # https://packages.microsoft.com/config/debian/10/
  wget --content-disposition \
    "https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb"

  sudo dpkg -i packages-microsoft-prod.deb
  rm -f packages-microsoft-prod.deb

  sudo apt-get install apt-transport-https

  sudo apt-get update
  sudo apt-get install -y \
    daemonize \
    dotnet-runtime-3.1

  sudo rm -f /usr/sbin/daemonize
  sudo ln -s /usr/bin/daemonize /usr/sbin/daemonize
}

function main() {
  installDependencies

  downloadDebPackage

  fixDebDependencies

  installDebPackage
}

main