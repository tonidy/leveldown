#!/usr/bin/env bash

SOURCE="${BASH_SOURCE[0]}"
DIR="$(dirname "$SOURCE")"

N_DIR=$DIR/n

if [[ ! -d $N_DIR ]]; then
    git clone https://github.com/ralphtheninja/n.git $N_DIR
fi

export PATH=$N_DIR:$DIR/../node_modules/.bin/:$PATH
export COMMIT_MESSAGE=$(git show -s --format=%B HEAD | tr -d '\n')

N_PLATFORM="io" N_VERSION="2.3.0" $DIR/linux-osx.sh
N_PLATFORM="io" N_VERSION="1.8.2" $DIR/linux-osx.sh
N_PLATFORM="io" N_VERSION="1.0.4" $DIR/linux-osx.sh
N_PLATFORM="node" N_VERSION="0.12.4" $DIR/linux-osx.sh
N_PLATFORM="node" N_VERSION="0.10.38" $DIR/linux-osx.sh
