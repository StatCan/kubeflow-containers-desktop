#!/bin/sh

# Stops script execution if a command has an error
set -e

SHA256=c3ed9a4ca4ec940c224dc76eacd464a5b1113a8bce8bc1b1eff72cc1056b2630
VERSION=1.23.2

INSTALL_ONLY=0
PORT=""
# Loop through arguments and process them: https://pretzelhands.com/posts/command-line-flags
for arg in "$@"; do
    case $arg in
        -i|--install) INSTALL_ONLY=1 ; shift ;;
        -p=*|--port=*) PORT="${arg#*=}" ; shift ;; # TODO Does not allow --port 1234
        *) break ;;
    esac
done

if [ ! -f "/usr/sbin/netdata"  ]; then
    echo "Installing Netdata. Please wait..."
    cd $RESOURCES_PATH
    wget --content-disposition https://packagecloud.io/netdata/netdata/packages/ubuntu/bionic/netdata_${VERSION}_amd64.deb/download.deb -O $RESOURCES_PATH/netdata.deb
    echo "${SHA256} ${RESOURCES_PATH}/netdata.deb" | sha256sum -c -
    apt-get update
    apt-get install -y $RESOURCES_PATH/netdata.deb
    rm $RESOURCES_PATH/netdata.deb
else
    echo "Netdata is already installed"
fi
