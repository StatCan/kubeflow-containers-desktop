#!/bin/sh

# Stops script execution if a command has an error
set -e

SHA256=2bb4c1e35d17eb9829cca9d0f7668b9ddcc10074847f6a32fca838f4a9daaa36

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

if [ ! -f "/usr/local/bin/filebrowser"  ]; then
    echo "Installing Filebrowser. Please wait..."
    mkdir -p $RESOURCES_PATH/filebrowser
    cd $RESOURCES_PATH/filebrowser
    # TODO: the 2.1.0 version does not work currently
    wget -q https://github.com/filebrowser/filebrowser/releases/download/v2.0.16/linux-amd64-filebrowser.tar.gz -O ./filebrowser.tar.gz
    echo "${SHA256} ./filebrowser.tar.gz" | sha256sum -c -
    tar -xzf ./filebrowser.tar.gz
    chmod +x "./filebrowser"
    mv "./filebrowser" "/usr/local/bin/filebrowser"
    cd $RESOURCES_PATH
    rm -r $RESOURCES_PATH/filebrowser
else
    echo "Filebrowser is already installed"
fi
