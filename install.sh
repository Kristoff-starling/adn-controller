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


echo "Installing protoc"
sudo apt -y install protobuf-compiler
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

echo "Installing Rust"
curl https://sh.rustup.rs -sSf | sh -s -- -y

# Install wrk and wrk2
cd $ADN_DIR
sudo apt-get install luarocks -y
sudo luarocks install luasocket

git clone https://github.com/wg/wrk.git
cd wrk
make -j $(nproc)


cd $ADN_DIR
sudo apt-get install libssl-dev
sudo apt-get install libz-dev

git clone https://github.com/giltene/wrk2.git
cd wrk2
make -j $(nproc)

set +e
