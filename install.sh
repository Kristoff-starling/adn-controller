#!/bin/bash

# Install Go if not found
if ! command -v go &> /dev/null
then
    echo "Go not found. Installing Go"
    wget https://go.dev/dl/go1.20.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.20.linux-amd64.tar.gz

    echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc
    source ~/.bashrc
fi

set -e

if [ -z "${ADN_DIR}" ]; then
  echo "Setting ADN_DIR to current directory"
  echo "export ADN_DIR=$PWD" >> ~/.bashrc
  . ~/.bashrc
fi


GO_PATH=$(go env GOPATH)
GO_BIN_DIR=$(go env GOPATH)/bin
echo "export PATH=$PATH:$GO_BIN_DIR" >> ~/.bashrc
echo "export GOPATH=$GO_PATH" >> ~/.bashrc
. ~/.bashrc

echo "Building adnctl..."
cd $ADN_DIR/adnctl
go install

cd $ADN_DIR

echo "adnctl was successfully installed 🎉🎉🎉"
echo ""

set +e
