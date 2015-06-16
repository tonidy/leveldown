#!/usr/bin/env bash

set -u -e

function build() {
  local ARCH=$1
  n $N_PLATFORM rm $N_VERSION
  n $N_PLATFORM --arch $ARCH $N_VERSION
  node -e "console.log(process.arch,process.execPath,JSON.stringify(process.versions))"
  npm install -g node-gyp-install
  node-gyp-install
  if test "${COMMIT_MESSAGE#*'[publish binary]'}" != "$COMMIT_MESSAGE"; then
    make clean
    INSTALL_RESULT=$(npm install --fallback-to-build=false > /dev/null)$? || true
    if [[ $INSTALL_RESULT != 0 ]]; then
      echo "=== No prebuilt binaries exists. Will create and publish binaries!"
      make
      node-pre-gyp publish
      node-pre-gyp info
      make clean
      INSTALL_RESULT=$(npm install --fallback-to-build=false > /dev/null)$? || true
      if [[ $INSTALL_RESULT != 0 ]]; then
        echo "=== Failed to install prebuild binaries. Unpublishing!"
        node-pre-gyp unpublish
        exit 1
      fi
    else
      echo "=== Binaries already exists for this version. Will not publish."
      make
      npm test
    fi
  else
    echo "=== Commit message does not contain '[publish binary]'. Will not publish binaries."
    make clean && make
    npm test
  fi
}

build x64

if [[ $(uname -s) == 'Linux' ]]; then
  echo "=== Installing gcc/g++ multilib with apt-get."
  sudo apt-get -y update &> /dev/null
  sudo apt-get -y install gcc-multilib g++-multilib &> /dev/null
  build x86
fi

