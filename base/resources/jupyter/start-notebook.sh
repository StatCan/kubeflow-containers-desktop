#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

set -e

# Set language based on argv. Change later to use env variable
argvFile=$(</home/jovyan/.config/Code/User/argv.json)
if [[ $argvFile == *'"locale":"fr"'* ]]; then
  export LANGUAGE=fr_FR
  else
  export LANGUAGE=en_EN
fi

if [[ ! -z "${JUPYTERHUB_API_TOKEN}" ]]; then
  # launched by JupyterHub, use single-user entrypoint
  exec /usr/local/bin/start-singleuser.sh "$@"
elif [[ ! -z "${JUPYTER_ENABLE_LAB}" ]]; then
  # custom: use NOTEBOOK_ARGS also for start without jupyterhub
  . /usr/local/bin/start.sh jupyter lab "$NOTEBOOK_ARGS" "$@"
else
  # custom: use NOTEBOOK_ARGS also for start without jupyterhub
  . /usr/local/bin/start.sh jupyter notebook "$NOTEBOOK_ARGS" "$@"
fi
