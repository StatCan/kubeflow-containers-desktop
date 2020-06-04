FROM k8scc01covidacr.azurecr.io/ml-workspace-base:master

USER root

RUN $RESOURCES_PATH/tools/r-runtime.sh && \
    $RESOURCES_PATH/tools/r-studio-desktop.sh 

USER ${NB_USER}

CMD ["/init.sh"]
