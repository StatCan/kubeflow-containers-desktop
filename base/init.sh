#!/bin/bash

cp -r --no-clobber /home_nbuser_default/. /home/$NB_USER/

# Local testing has no ${NB_PREFIX): placeholder WORKSPACE_BASE_URL is "/workspace"
export WORKSPACE_BASE_URL=${NB_PREFIX:="/workspace"}
export NB_USER=${NB_USER}
if [ -n "${KF_LANG}" ]; then
  if [ "${KF_LANG}" = "fr" ]; then
      export LANG="fr_FR.UTF-8" LANGUAGE="fr_FR.UTF-8" LC_ALL="fr_FR.UTF-8"
  else
      export LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8"
  fi
fi 
exec python ${RESOURCES_PATH}/docker-entrypoint.py
