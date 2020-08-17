#!/bin/bash

cp -r --no-clobber /tmp/home_nbuser_default/. /home/$NB_USER/
rm -rf /tmp/home_nbuser_default

# Local testing has no ${NB_PREFIX): placeholder WORKSPACE_BASE_URL is "/workspace"
export WORKSPACE_BASE_URL=${NB_PREFIX:="/workspace"}
export NB_USER=${NB_USER}
exec python ${RESOURCES_PATH}/docker-entrypoint.py
