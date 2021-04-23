ARG SHA=master
FROM k8scc01covidacr.azurecr.io/remote-desktop-r:${SHA}

USER root

COPY qgis-2020.gpg.key $RESOURCES_PATH/tools/qgis-2020.gpg.key
COPY qgis.sh $RESOURCES_PATH/tools/qgis.sh

RUN /bin/bash $RESOURCES_PATH/tools/qgis.sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

USER ${NB_USER}

CMD ["/init.sh"]
