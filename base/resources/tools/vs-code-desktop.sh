#!/bin/sh

# Stops script execution if a command has an error
set -e

SHA256=6c117339d77b9593ad20b6eb4601ff7d0fd468922550d500edf07e3071e9a041

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