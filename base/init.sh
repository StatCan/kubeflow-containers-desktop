#!/bin/bash
cp -r --no-clobber /tmp/home_nbuser_default/. /home/${NB_USER}/
rm -rf /tmp/home_nbuser_default
export WORKSPACE_BASE_URL=${NB_PREFIX}
export NB_USER=${NB_USER}
exec python ${RESOURCES_PATH}/docker-entrypoint.py