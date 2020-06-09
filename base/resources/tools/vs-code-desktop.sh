#!/bin/sh

# Stops script execution if a command has an error
set -e

SHA256=7b3bce26aff8677ae8920490709839dc6c5fda83728aec09724245761b64f217

if [ ! -f "/usr/share/code/code" ]; then
    echo "Installing VS Code. Please wait..."
    cd $RESOURCES_PATH
    wget -q https://go.microsoft.com/fwlink/?LinkID=760868 -O ./vscode.deb
    echo "${SHA256} ./vscode.deb" | sha256sum -c -
    apt-get update
    apt-get install -y ./vscode.deb
    rm ./vscode.deb
    rm /etc/apt/sources.list.d/vscode.list
else
    echo "VS Code is already installed"
fi