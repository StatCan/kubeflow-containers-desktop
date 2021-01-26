#!/usr/bin/python

"""
Configure and run tools
"""

from subprocess import call
import os
import sys

# Enable logging
import logging
logging.basicConfig(
    format='%(asctime)s [%(levelname)s] %(message)s', 
    level=logging.INFO, 
    stream=sys.stdout)

log = logging.getLogger(__name__)

ENV_RESOURCES_PATH = os.getenv("RESOURCES_PATH", "/resources")
ENV_WORKSPACE_HOME = os.getenv("WORKSPACE_HOME", "/workspace")
HOME = os.getenv("HOME", "/root")

DESKTOP_PATH = HOME + "/Desktop"

# Get jupyter token 
ENV_AUTHENTICATE_VIA_JUPYTER = os.getenv("AUTHENTICATE_VIA_JUPYTER", "false")

token_parameter = ""
if ENV_AUTHENTICATE_VIA_JUPYTER.lower() == "true":
    # Check if started via Jupyterhub -> JPY_API_TOKEN is set
    ENV_JPY_API_TOKEN = os.getenv("JPY_API_TOKEN", None)
    if ENV_JPY_API_TOKEN:
        token_parameter = "?token=" + ENV_JPY_API_TOKEN
elif ENV_AUTHENTICATE_VIA_JUPYTER and ENV_AUTHENTICATE_VIA_JUPYTER.lower() != "false":
    token_parameter = "?token=" + ENV_AUTHENTICATE_VIA_JUPYTER

# Create Jupyter Shortcut - at runtime since the jupyterhub token is needed
# url = 'http://localhost:8092' + token_parameter
# shortcut_metadata = '[Desktop Entry]\nVersion=1.0\nType=Link\nName=Jupyter Notebook\nComment=\nCategories=Development;\nIcon=' + ENV_RESOURCES_PATH + '/icons/jupyter-icon.png\nURL=' + url
# call('printf "' + shortcut_metadata + '" > ' + DESKTOP_PATH + '/jupyter.desktop', shell=True) # create a link on the Desktop to your Jupyter notebook server
# call('chmod +x ' + DESKTOP_PATH + '/jupyter.desktop', shell=True) # Make executable
# call('printf "' + shortcut_metadata + '" > /usr/share/applications/jupyter.desktop', shell=True) # create a link in categories menu to your Jupyter notebook server
# call('chmod +x /usr/share/applications/jupyter.desktop', shell=True) # Make executable

# Create Jupyter Lab Shortcut
# url = 'http://localhost:8092' + "/lab" + token_parameter
# shortcut_metadata = '[Desktop Entry]\nVersion=1.0\nType=Link\nName=Jupyter Lab\nComment=\nCategories=Development;\nIcon=' + ENV_RESOURCES_PATH + '/icons/jupyterlab-icon.png\nURL=' + url

# call('printf "' + shortcut_metadata + '" > /usr/share/applications/jupyterlab.desktop', shell=True) # create a link in categories menu to your Jupyter Lab server
# call('chmod +x /usr/share/applications/jupyterlab.desktop', shell=True) # Make executable

# Tools are started via supervisor, see supervisor.conf
