#!/bin/bash
# Stops script execution if a command has an error
set -e

if ! hash qgis 2>/dev/null; then
  apt-get update
  apt-get install gnupg software-properties-common
  cat $RESOURCES_PATH/tools/qgis-2020.gpg.key | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/qgis-archive.gpg --import
  chmod a+r /etc/apt/trusted.gpg.d/qgis-archive.gpg
  add-apt-repository "deb https://qgis.org/debian `lsb_release -c -s` main"
  apt-get update
  apt-get install qgis qgis-plugin-grass

  echo "[Desktop Entry]
	Version=1.0
	Type=Application
	Name=QGIS Desktop
	Comment=
	Exec=/usr/bin/qgis %F
	Icon=qgis
	Path=
	Terminal=false
	StartupNotify=false" >> "/tmp/home_nbuser_default/Desktop/QGIS Desktop.desktop"

  chmod +x "/tmp/home_nbuser_default/Desktop/QGIS Desktop.desktop"
  chown ${NB_USER}:${NB_USER} "/tmp/home_nbuser_default/Desktop/QGIS Desktop.desktop"

else
    echo "QGIS is already installed"
fi

echo "Installing supporting libraries..."

conda clean -i 

conda install --override-channels -c conda-forge --yes \
      'fiona' \
      'gdal' \
      'geopandas' \
      'rasterio' \
      'r-classInt' \
      'r-deldir' \
      'r-geoR' \
      'r-geosphere' \
      'r-gstat' \
      'r-hdf5r' \
      'r-lidR' \
      'r-mapdata' \
      'r-maptools' \
      'r-mapview' \
      'r-ncdf4' \
      'r-proj4' \
      'r-RandomFields' \
      'r-raster' \
      'r-RColorBrewer' \
      'r-rgdal' \
      'r-rgeos' \
      'r-rlas' \
      'r-RNetCDF' \
      'r-sf' \
      'r-sp' \
      'r-spacetime' \
      'r-spatstat' \
      'r-spdep'

#Fix R
conda install -c conda-forge libiconv

conda clean --all -f -y
export USER_GID=${USER_GID}
fix-permissions.sh ${CONDA_DIR}

echo "QGIS and supporting libraries have been installed."
