FROM k8scc01covidacr.azurecr.io/ml-workspace-rstudio:master

USER root

RUN $RESOURCES_PATH/tools/qgis.sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

USER ${NB_USER}

CMD ["/init.sh"]
