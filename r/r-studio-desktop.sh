#!/bin/sh

# Stops script execution if a command has an error
set -e

VERSION=1.2.5033
RELEASE=xenial
SHA256=a1591ed7fd84d4e7ed57f1e7dc5306bfc0279d8369d3ea613b78a37c9c8938f0

if ! hash rstudio 2>/dev/null; then
    echo "Installing RStudio Desktop. Please wait..."
    cd $RESOURCES_PATH
    apt-get update
    #apt-get install --yes r-base
    wget https://download1.rstudio.org/desktop/${RELEASE}/amd64/rstudio-${VERSION}-amd64.deb -O ./rstudio.deb
    echo "${SHA256} ./rstudio.deb" | sha256sum -c -
    # ld library path makes problems
    LD_LIBRARY_PATH="" gdebi --non-interactive ./rstudio.deb
    rm ./rstudio.deb

    echo "[Desktop Entry]
Version=1.0
Type=Application
Name=RStudio
Comment=
Exec=/usr/lib/rstudio/bin/rstudio %F
Icon=rstudio
Path=
Terminal=false
StartupNotify=false" >> "/tmp/home_nbuser_default/Desktop/RStudio.desktop"

	chmod +x "/tmp/home_nbuser_default/Desktop/RStudio.desktop"
	chown ${NB_USER}:${NB_USER} /tmp/home_nbuser_default/Desktop/RStudio.desktop   

else
    echo "RStudio is already installed"
fi
