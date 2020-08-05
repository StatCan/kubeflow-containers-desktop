#!/bin/sh

# Stops script execution if a command has an error
set -e

SHA256=8f3b1d2cf439d2c685c21f3337320db6ca90aa6569a3b907d5c9a140e553f25e

if [ ! -f "/usr/local/bin/code-server"  ]; then
    echo "Installing VS Code Server. Please wait..."
    VERSION=3.4.1
    wget -q "https://github.com/cdr/code-server/releases/download/v${VERSION}/code-server_${VERSION}_amd64.deb" -O ./vscode-web.deb
    echo "${SHA256} ./vscode-web.deb" | sha256sum -c -
    dpkg -i ./vscode-web.deb
    rm ./vscode-web.deb
    #Fix critical vulnerabilities
    cd /usr/lib/code-server/lib/vscode/
    yarn remove $(cat package.json | jq -r '.devDependencies | keys | join(" ")')
    yarn cache clean

else
    echo "VS Code Server is already installed"
fi

