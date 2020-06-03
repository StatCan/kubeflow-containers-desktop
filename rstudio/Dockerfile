FROM k8scc01covidacr.azurecr.io/ml-workspace-base:master

USER root

RUN $RESOURCES_PATH/tools/r-runtime.sh && \
    $RESOURCES_PATH/tools/r-studio-desktop.sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

USER ${NB_USER}

CMD ["/init.sh"]
