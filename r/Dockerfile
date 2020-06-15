FROM k8scc01covidacr.azurecr.io/remote-desktop-base:master

USER root

RUN /bin/bash $RESOURCES_PATH/tools/r-runtime.sh && \
    /bin/bash $RESOURCES_PATH/tools/r-studio-desktop.sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

USER ${NB_USER}

CMD ["/init.sh"]
