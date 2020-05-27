#!/bin/bash
cp -r --no-clobber /home_nbuser_default/. /home/$NB_USER/
rm -rf /home_nbuser_default
export WORKSPACE_BASE_URL=${NB_PREFIX}
exec python ${RESOURCES_PATH}/docker-entrypoint.py
