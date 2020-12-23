FROM ubuntu:18.04

USER root

### BASICS ###

# Environment Variables

ENV AUTHENTICATE_VIA_JUPYTER="false" \
    CONFIG_BACKUP_ENABLED="true" \
    DEBIAN_FRONTEND="noninteractive" \
    DISPLAY=":1" \
    INCLUDE_TUTORIALS="true" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    MAX_NUM_THREADS="auto" \
    NB_USER="jovyan" \
    RESOURCES_PATH="/resources" \
    SHARED_LINKS_ENABLED="true" \
    SHELL="/bin/bash" \
    SHUTDOWN_INACTIVE_KERNELS="false" \
    SSL_RESOURCES_PATH="/resources/ssl" \
    TERM="xterm" \
    USER_GID=1000 \
    VNC_COL_DEPTH=24 \
    VNC_PW=vncpassword \
    VNC_RESOLUTION=1600x900 \
    WORKSPACE_BASE_URL="/" \
    WORKSPACE_PORT="8888" \
    XDG_RUNTIME_DIR="/tmp"

ENV DATA_ENVIRONMENT="${WORKSPACE_HOME}/environment" \
    HOME="/home/${NB_USER}"  \
    WORKSPACE_HOME="/home/${NB_USER}" \
    XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

RUN groupadd -g ${USER_GID} ${NB_USER} && useradd -m -u ${USER_GID} -g ${NB_USER} ${NB_USER}

WORKDIR $HOME

# Make folders
RUN \
    mkdir $RESOURCES_PATH && \
    mkdir $SSL_RESOURCES_PATH

# Layer cleanup script
COPY resources/scripts/clean-layer.sh  /usr/bin/clean-layer.sh
COPY resources/scripts/fix-permissions.sh  /usr/bin/fix-permissions.sh

 # Make clean-layer and fix-permissions executable
 RUN \
    chmod u+x /usr/bin/clean-layer.sh && \
    chmod u+x /usr/bin/fix-permissions.sh

# Generate and Set locals
# https://stackoverflow.com/questions/28405902/how-to-set-the-locale-inside-a-debian-ubuntu-docker-container#38553499
RUN \
    apt-get update && \
    apt-get install -y locales && \
    # install locales-all?
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8 && \
    # Cleanup
    clean-layer.sh

# Install basics
RUN \
    # TODO add repos?
    # add-apt-repository ppa:apt-fast/stable
    # add-apt-repository 'deb http://security.ubuntu.com/ubuntu xenial-security main'
    apt-get update --fix-missing && \
    apt-get install -y sudo apt-utils && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        # This is necessary for apt to access HTTPS sources: 
        apt-transport-https \
        gnupg-agent \
        gpg-agent \
        gnupg2 \
        ca-certificates \
        build-essential \
        pkg-config \
        software-properties-common \
        lsof \
        net-tools \
        libcurl4 \
        curl \
        wget \
        cron \
        openssl \
        iproute2 \
        psmisc \
        tmux \
        dpkg-sig \
        uuid-dev \
        csh \
        xclip \
        clinfo \
        libgdbm-dev \
        libncurses5-dev \
        gawk \
        # Simplified Wrapper and Interface Generator (5.8MB) - required by lots of py-libs
        swig \
        # Graphviz (graph visualization software) (4MB)
        graphviz libgraphviz-dev \
        # Terminal multiplexer
        screen \
        # Editor
        nano \
        # Find files
        locate \
        # Dev Tools
        # sqlite3 \
        # XML Utils
        xmlstarlet \
        #  R*-tree implementation - Required for earthpy, geoviews (3MB)
        libspatialindex-dev \
        # Search text and binary files
        yara \
        # Minimalistic C client for Redis
        libhiredis-dev \
        libleptonica-dev \
        # GEOS library (3MB)
        libgeos-dev \
        # style sheet preprocessor
        less \
        # Print dir tree
        tree \
        # Bash autocompletion functionality
        bash-completion \
        # ping support
        iputils-ping \
        # Json Processor
        jq \
        rsync \
        # VCS:
        git \
        subversion \
        jed \
        # odbc drivers
        unixodbc unixodbc-dev \
        # Image support
        libtiff-dev \
        libjpeg-dev \
        libpng-dev \
        # TODO: no 18.04 installation candidate: libjasper-dev \
        libglib2.0-0 \
        libxext6 \
        libsm6 \
        libxext-dev \
        libxrender1 \
        libzmq3-dev \
        # protobuffer support
        protobuf-compiler \
        libprotobuf-dev \
        libprotoc-dev \
        autoconf \
        automake \
        libtool \
        cmake  \
        fonts-liberation \
        google-perftools \
        # Compression Libs
        # also install rar/unrar? but both are propriatory or unar (40MB)
        zip \
        gzip \
        unzip \
        bzip2 \
        lzop \
        bsdtar \
        zlibc \
        # unpack (almost) everything with one command
        unp \
        libbz2-dev \
        liblzma-dev \
        zlib1g-dev && \
    # configure dynamic linker run-time bindings
    ldconfig && \
    # Fix permissions
    fix-permissions.sh $HOME && \
    # Cleanup
    clean-layer.sh

# Add tini
ARG SHA256=12d20136605531b09a2c2dac02ccee85e1b874eb322ef6baf7561cd93f93c855
RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.18.0/tini -O /tini && \
    echo "${SHA256} /tini" | sha256sum -c - && \
    chmod +x /tini

# prepare ssh for inter-container communication for remote python kernel
RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        openssh-client \
        openssh-server \
        # SSLH for SSH + HTTP(s) Multiplexing
        sslh \
        # SSH Tooling
        autossh \
        mussh && \
    chmod go-w $HOME && \
    mkdir -p $HOME/.ssh/ && \
    # create empty config file if not exists
    touch $HOME/.ssh/config  && \
    chown -R ${NB_USER} $HOME/.ssh && \
    chmod 700 $HOME/.ssh && \
    printenv >> $HOME/.ssh/environment && \
    # Fix permissions
    fix-permissions.sh $HOME && \
    # Cleanup
    clean-layer.sh

ARG SHA256=436b4e84d547a97a18cf7a2522daf819da8087b188468946b5a89c0dd1ca5d16
RUN \
    OPEN_RESTY_VERSION="1.15.8.2" && \
    mkdir $RESOURCES_PATH"/openresty" && \
    cd $RESOURCES_PATH"/openresty" && \
    apt-get update && \
    apt-get purge -y nginx nginx-common && \
    # libpcre required, otherwise you get a 'the HTTP rewrite module requires the PCRE library' error
    # Install apache2-utils to generate user:password file for nginx.
    apt-get install -y libssl-dev libpcre3 libpcre3-dev apache2-utils && \
    wget --quiet https://openresty.org/download/openresty-$OPEN_RESTY_VERSION.tar.gz  -O ./openresty.tar.gz && \
    echo "${SHA256} ./openresty.tar.gz" | sha256sum -c - && \
    tar xfz ./openresty.tar.gz && \
    rm ./openresty.tar.gz && \
    cd ./openresty-$OPEN_RESTY_VERSION/ && \
    # Surpress output - if there is a problem remove  > /dev/null
    ./configure --with-http_stub_status_module --with-http_sub_module > /dev/null && \
    make -j2 > /dev/null && \
    make install > /dev/null && \
    # create log dir and file - otherwise openresty will throw an error
    mkdir -p /var/log/nginx/ && \
    touch /var/log/nginx/upstream.log && \
    cd $RESOURCES_PATH && \
    rm -r $RESOURCES_PATH"/openresty" && \
    # Fix permissions
    # Cleanup
    clean-layer.sh

ENV PATH=/usr/local/openresty/nginx/sbin:$PATH

COPY resources/nginx/lua-extensions /etc/nginx/nginx_plugins

### END BASICS ###

COPY resources/tools $RESOURCES_PATH/tools

### RUNTIMES ###

# Install Miniconda: https://repo.continuum.io/miniconda/
# Also moved DATA SCIENCE BASICS and the Conda Solving Environemnt fix here: 
# All base conda in one layer brings down image size
ENV \
    CONDA_DIR=/opt/conda \
    PYTHON_VERSION="3.7.7" \
    CONDA_PYTHON_DIR=/opt/conda/lib/python3.7 \
    CONDA_VERSION="4.7.12"
ARG SHA256=a23fcffe97690d3bbcd34cda798c3a3318e0f35d863c5d4aca3fc983fe8450b7
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O ${HOME}/miniconda.sh && \
    echo "${SHA256} ${HOME}/miniconda.sh" | sha256sum -c - && \
    /bin/bash ~/miniconda.sh -b -p $CONDA_DIR && \
    export PATH=$CONDA_DIR/bin:$PATH && \
    rm ~/miniconda.sh && \
    # Update conda
    $CONDA_DIR/bin/conda update -y -n base -c defaults conda && \
    $CONDA_DIR/bin/conda update -y setuptools && \
    $CONDA_DIR/bin/conda install -y conda-build && \
    # Add conda forge - Append so that conda forge has lower priority than the main channel
    $CONDA_DIR/bin/conda config --system --append channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
    ## Conda Solving Environment Fix: Turn off channel priority
    conda config --set channel_priority false && \
    # Update selected packages - install python 3.7.x
    $CONDA_DIR/bin/conda install -y --update-all python=$PYTHON_VERSION && \
    # Link Conda
    ln -s $CONDA_DIR/bin/python /usr/local/bin/python && \
    ln -s $CONDA_DIR/bin/conda /usr/bin/conda && \
    # Update pip
    $CONDA_DIR/bin/pip install --upgrade pip && \
    ### DATA SCIENCE BASICS ###
    ### Install main data science libs
    # Link Conda - All python are linke to the conda instances 
    # Linking python 3 crashes conda -> cannot install anyting - remove instead
    ln -s -f $CONDA_DIR/bin/python /usr/bin/python && \
    apt-get update && \
    # upgrade pip
    pip install --upgrade pip && \
    conda install -y --update-all nomkl && \
    conda install -y --update-all \
            'python='$PYTHON_VERSION \
            tqdm \
            pyzmq \
            cython \
            graphviz \
            numpy \
            matplotlib \
            scipy \
            requests \
            urllib3 \
            pandas \
            six \
            future \
            protobuf \
            zlib \
            boost \
            psutil \
            PyYAML \
            python-crontab \
            ipykernel \
            cmake \
            joblib \
            Pillow \
            ipython \
            notebook \
            # Selected by library evaluation
            networkx \
            click \
            docutils \
            imageio \
            tabulate \
            flask \
            dill \
            regex \
            toolz \
            jmespath && \
    # OpenMPI support
    apt-get install -y --no-install-recommends libopenmpi-dev openmpi-bin && \
    # Install numba
    conda install -y numba && \
    # libartals == 40MB liblapack-dev == 20 MB
    apt-get install -y --no-install-recommends liblapack-dev libatlas-base-dev libeigen3-dev libblas-dev && \
    # pandoc -> installs libluajit -> problem for openresty
    # HDF5 (19MB)
    apt-get install -y libhdf5-dev && \
    ### END DATA SCIENCE BASICS ###
    # Cleanup - Remove all here since conda is not in path as of now
    $CONDA_DIR/bin/conda clean -y --packages && \
    $CONDA_DIR/bin/conda clean -y -a -f  && \
    $CONDA_DIR/bin/conda build purge-all && \
    # Fix permissions
    fix-permissions.sh $CONDA_DIR && \
    # Cleanup
    clean-layer.sh

ENV PATH=$CONDA_DIR/bin:$PATH

# There is nothing added yet to LD_LIBRARY_PATH, so we can overwrite
ENV LD_LIBRARY_PATH=$CONDA_DIR/lib 

# Install node.js
ARG VERSION=v12.18.0
ARG DISTRO=linux-x64
ARG SHA256=2febc2506c298048bfddf896056be6191c1f08716876d960a4990bd63a7fe05a
RUN \
    wget --quiet https://nodejs.org/dist/${VERSION}/node-${VERSION}-${DISTRO}.tar.xz -O /tmp/nodejs.tar.xz && \
    echo "${SHA256} /tmp/nodejs.tar.xz" | sha256sum -c - && \
    mkdir -p /usr/local/lib/nodejs && \
    tar -xJvf /tmp/nodejs.tar.xz -C /usr/local/lib/nodejs && \
    rm  /tmp/nodejs.tar.xz && \
    export PATH=/usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin:$PATH && \
    # Install YARN
    cat $RESOURCES_PATH/tools/yarn_pubkey.gpg | sudo apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends yarn && \
    # Install libxkbfile-dev which is necessary for certain YARN and NPM commands/installs
    apt-get install -y libxkbfile-dev && \
    # Install typescript 
    /usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin/npm install -g typescript && \
    # Install webpack - 32 MB
    /usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin/npm install -g webpack && \
    # Cleanup
    clean-layer.sh && \
    # Fix permissions
    fix-permissions.sh /usr/local/lib/nodejs/node-$VERSION-$DISTRO && \
    fix-permissions.sh $HOME

ENV PATH=/usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin:$PATH

### END RUNTIMES ###

### PROCESS TOOLS ###

### Install xfce UI
RUN \
    apt-get update && \
    # Install custom font
    apt-get install -y xfce4 xfce4-terminal xterm && \
    apt-get purge -y pm-utils xscreensaver* && \
    # Cleanup
    clean-layer.sh

# Install rdp support via xrdp
RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends xrdp && \
    # use xfce
    sudo sed -i.bak '/fi/a #xrdp multiple users configuration \n xfce-session \n' /etc/xrdp/startwm.sh && \
    # generate /etc/xrdp/rsakeys.ini
    cd /etc/xrdp/ && xrdp-keygen xrdp && \
    # Cleanup
    clean-layer.sh

# Install supervisor for process supervision
RUN \
    apt-get update && \
    # Create sshd run directory - required for starting process via supervisor
    mkdir -p /var/run/sshd && chmod 400 /var/run/sshd && \
    # Install rsyslog for syslog logging
    apt-get install -y --no-install-recommends rsyslog && \
    pip install --no-cache-dir --upgrade supervisor supervisor-stdout && \
    # supervisor needs this logging path
    mkdir -p /var/log/supervisor/ && \
    # Cleanup
    clean-layer.sh

### END PROCESS TOOLS ###

### GUI TOOLS ###
# Install VNC
ARG SHA256tigervnc=fb8f94a5a1d77de95ec8fccac26cb9eaa9f9446c664734c68efdffa577f96a31
ARG SHA256novnc=2c63418b624a221a28cac7b9a7efecc092b695fc1b7dd88255b074ab32bc72a7
ARG SHA256websockify=6ebfec791dd78be6584fb5fe3bc27f02af54501beddf8457368699f571de13ae
RUN \
    cd ${RESOURCES_PATH} && \
    # Tiger VNC
    wget --quiet https://dl.bintray.com/tigervnc/stable/tigervnc-1.10.1.x86_64.tar.gz -O /tmp/tigervnc.tar.gz && \
    echo "${SHA256tigervnc} /tmp/tigervnc.tar.gz" | sha256sum -c - && \
    tar xzf /tmp/tigervnc.tar.gz --strip 1 -C / && \
    rm /tmp/tigervnc.tar.gz && \
    # Install websockify
    mkdir -p ./novnc/utils/websockify && \
    # Before updating the noVNC version, we need to make sure that our monkey patching scripts still work!!
    wget --quiet https://github.com/novnc/noVNC/archive/v1.1.0.tar.gz -O /tmp/novnc.tar.gz && \
    echo "${SHA256novnc} /tmp/novnc.tar.gz" | sha256sum -c - && \
    tar xzf /tmp/novnc.tar.gz --strip 1 -C ./novnc && \
    rm /tmp/novnc.tar.gz && \
    # use older version of websockify to prevent hanging connections on offline containers?, see https://github.com/ConSol/docker-headless-vnc-container/issues/50
    wget --quiet https://github.com/novnc/websockify/archive/v0.9.0.tar.gz -O /tmp/websockify.tar.gz && \
    echo "${SHA256websockify} /tmp/websockify.tar.gz" | sha256sum -c - && \
    tar xzf /tmp/websockify.tar.gz --strip 1 -C ./novnc/utils/websockify && \
    rm /tmp/websockify.tar.gz && \
    chmod +x -v ./novnc/utils/*.sh && \
    # create user vnc directory
    mkdir -p $HOME/.vnc

# Install Terminal / GDebi (Package Manager) / Glogg (Stream file viewer) & archive tools
# Discover Tools:
# https://wiki.ubuntuusers.de/Startseite/
# https://wiki.ubuntuusers.de/Xfce_empfohlene_Anwendungen/
# https://goodies.xfce.org/start
# https://linux.die.net/man/1/
RUN \
    apt-get update && \
    # Configuration database - required by git kraken / atom and other tools (1MB)
    apt-get install -y --no-install-recommends gconf2 && \
    apt-get install -y --no-install-recommends xfce4-terminal && \
    apt-get install -y --no-install-recommends --allow-unauthenticated xfce4-taskmanager  && \
    # Install gdebi deb installer
    apt-get install -y --no-install-recommends gdebi && \
    # Search for files
    apt-get install -y --no-install-recommends catfish && \
    # TODO: Unable to locate package:  apt-get install -y --no-install-recommends gnome-search-tool && 
    apt-get install -y --no-install-recommends font-manager && \
    # vs support for thunar
    apt-get install -y thunar-vcs-plugin && \
    # Streaming text editor for large files
    apt-get install -y --no-install-recommends glogg  && \
    apt-get install -y --no-install-recommends baobab && \
    # Lightweight text editor
    apt-get install -y mousepad && \
    apt-get install -y --no-install-recommends vim && \
    # Process monitoring
    apt-get install -y htop && \
    # Install Archive/Compression Tools: https://wiki.ubuntuusers.de/Archivmanager/
    apt-get install -y p7zip p7zip-rar && \
    apt-get install -y --no-install-recommends thunar-archive-plugin && \
    apt-get install -y xarchiver && \
    # DB Utils
    apt-get install -y --no-install-recommends sqlitebrowser && \
    # Install nautilus and support for sftp mounting
    apt-get install -y --no-install-recommends nautilus gvfs-backends && \
    # Install gigolo - Access remote systems
    apt-get install -y --no-install-recommends gigolo gvfs-bin && \
    # xfce systemload panel plugin - needs to be activated
    apt-get install -y --no-install-recommends xfce4-systemload-plugin && \
    # Leightweight ftp client that supports sftp, http, ...
    apt-get install -y --no-install-recommends gftp && \
    # Install chrome
    # apt-get install -y chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg && \
    # ln -s /usr/bin/chromium-browser /usr/bin/google-chrome && \
    # Cleanup
    # Large package: gnome-user-guide 50MB app-install-data 50MB
    apt-get remove -y app-install-data gnome-user-guide && \ 
    clean-layer.sh

# Add the defaults from /lib/x86_64-linux-gnu, otherwise lots of no version errors
# cannot be added above otherwise there are errors in the installation of the gui tools
# Call order: https://unix.stackexchange.com/questions/367600/what-is-the-order-that-linuxs-dynamic-linker-searches-paths-in
ENV LD_LIBRARY_PATH=/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:$CONDA_DIR/lib 

## Netdata
RUN \
    /bin/bash $RESOURCES_PATH/tools/netdata.sh --install && \
    # Cleanup
    clean-layer.sh

# Configure Netdata
# COPY resources/netdata/ /etc/netdata/

## Filebrowser
RUN \
    /bin/bash $RESOURCES_PATH/tools/filebrowser.sh --install && \
    # Cleanup
    clean-layer.sh

# Install Firefox
RUN \
    /bin/bash $RESOURCES_PATH/tools/firefox.sh --install && \
    # Cleanup
    clean-layer.sh

### END GUI TOOLS ###

### JUPYTER ###

COPY \
    resources/jupyter/start.sh \
    resources/jupyter/start-notebook.sh \
    resources/jupyter/start-singleuser.sh \
    /usr/local/bin/

### FRENCH LANGUAGE ####
COPY resources/scripts/languagecheck.js /usr/local/bin/

### VSCODE ###

## Install Visual Studio Code Server (In-Browser): https://github.com/codercom/code-server
# npm --production install bypasses vulnerable devDependencies
# Initial attempts at install from root or from ${NB_USER} locally failed

USER ${NB_USER}
RUN npm install -g --production code-server && \
    npm cache clean --force && \
    rm -rf $HOME/.npm/* $HOME/.node-gyp/*
USER root

# Install Visual Studio Code (Desktop)
RUN \
    /bin/bash $RESOURCES_PATH/tools/vs-code-desktop.sh --install && \
    # Cleanup
    clean-layer.sh

# Install Visual Studio Code extensions
# https://github.com/cdr/code-server/issues/171
# Alternative install: /usr/local/bin/code-server --user-data-dir=$HOME/.config/Code/ --extensions-dir=$HOME/.vscode/extensions/ --install-extension ms-python-release && \
ARG SHA256py=a4191fefc0e027fbafcd87134ac89a8b1afef4fd8b9dc35f14d6ee7bdf186348
ARG SHA256gl=ed130b2a0ddabe5132b09978195cefe9955a944766a72772c346359d65f263cc
RUN \
    cd $RESOURCES_PATH && \
    mkdir -p $HOME/.vscode/extensions/ && \
    # Install python extension - (newer versions are 30MB bigger)
    VS_PYTHON_VERSION="2020.5.86806" && \
    wget --quiet --no-check-certificate https://github.com/microsoft/vscode-python/releases/download/$VS_PYTHON_VERSION/ms-python-release.vsix && \
    echo "${SHA256py} ms-python-release.vsix" | sha256sum -c - && \
    bsdtar -xf ms-python-release.vsix extension && \
    rm ms-python-release.vsix && \
    mv extension $HOME/.vscode/extensions/ms-python.python-$VS_PYTHON_VERSION && \
    # Install git lens: https://github.com/eamodio/vscode-gitlens
    VS_GITLENS_VERSION="10.2.2" && \
    wget --quiet --no-check-certificate https://github.com/eamodio/vscode-gitlens/releases/download/v$VS_GITLENS_VERSION/gitlens-$VS_GITLENS_VERSION.vsix && \
    echo "${SHA256gl} gitlens-${VS_GITLENS_VERSION}.vsix" | sha256sum -c - && \
    bsdtar -xf gitlens-$VS_GITLENS_VERSION.vsix extension && \
    rm gitlens-$VS_GITLENS_VERSION.vsix && \
    mv extension $HOME/.vscode/extensions/eamodio.gitlens-$VS_GITLENS_VERSION && \
    # Install French Language extension via building and copying https://github.com/microsoft/vscode-loc/tree/release/1.50
    # https://github.com/Microsoft/vscode-loc/wiki/How-to-create-language-pack-extension#1-build-vsix 
    VS_FRENCH_VERSION="1.50.2" && \
    VS_LOCALE_REPO_VERSION="1.50" && \
    git clone -b release/$VS_LOCALE_REPO_VERSION https://github.com/microsoft/vscode-loc.git &&\
    cd vscode-loc && \
    npm install -g vsce && \
    cd i18n/vscode-language-pack-fr && \
    vsce package && \
    bsdtar -xf vscode-language-pack-fr-$VS_FRENCH_VERSION.vsix extension && \
    mv extension $HOME/.vscode/extensions/ms-ceintl.vscode-language-pack-fr-$VS_FRENCH_VERSION && \
    cd ../../../ && \
    # -fr option is required. git clone protects the directory and cannot delete it without -fr
    rm -fr vscode-loc && \
    npm uninstall -g vsce && \
    # Fix permissions
    fix-permissions.sh $HOME/.vscode/extensions/ && \
    # Cleanup
    clean-layer.sh

### END VSCODE ###

### INCUBATION ZONE ### 

RUN \
    apt-get update && \
    # Newer jedi makes trouble with jupyterlab-lsp
    pip install --no-cache-dir jedi==0.15.2 && \
    clean-layer.sh

### END INCUBATION ZONE ###

### CONFIGURATION ###

# Copy files into workspace
COPY \
    resources/docker-entrypoint.py \
    resources/5xx.html \
    $RESOURCES_PATH/

# Copy scripts into workspace
COPY resources/scripts $RESOURCES_PATH/scripts

# Create Desktop Icons for Tooling
COPY resources/branding $RESOURCES_PATH/branding

# Configure Home folder (e.g. xfce)
COPY resources/home/ $HOME/

# Copy some configuration files
COPY resources/ssh/ssh_config resources/ssh/sshd_config  /etc/ssh/
COPY resources/config/xrdp.ini /etc/xrdp/xrdp.ini

# Assume yes to all apt commands, to avoid user confusion around stdin.
COPY resources/config/90assumeyes /etc/apt/apt.conf.d/

# Monkey Patching novnc: Styling and added clipboard support. All changed sections are marked with CUSTOM CODE
COPY resources/novnc/ $RESOURCES_PATH/novnc/

RUN \
    ## create index.html to forward automatically to `vnc.html`
    # Needs to be run after patching
    ln -s $RESOURCES_PATH/novnc/vnc.html $RESOURCES_PATH/novnc/index.html

# Configure Jupyter / JupyterLab
# Add as jupyter system configuration
COPY resources/jupyter/nbconfig /etc/jupyter/nbconfig
COPY resources/jupyter/jupyter_notebook_config.py resources/jupyter/jupyter_notebook_config.json resources/jupyter/nbconfig /etc/jupyter/
COPY resources/jupyter/sidebar.jupyterlab-settings $HOME/.jupyter/lab/user-settings/@jupyterlab/application-extension/
COPY resources/jupyter/plugin.jupyterlab-settings $HOME/.jupyter/lab/user-settings/@jupyterlab/extensionmanager-extension/
COPY resources/jupyter/ipython_config.py /etc/ipython/ipython_config.py

# Add tensorboard patch - use tensorboard jupyter plugin instead of the actual tensorboard magic
# COPY resources/jupyter/tensorboard_notebook_patch.py $CONDA_PYTHON_DIR/site-packages/tensorboard/notebook.py

# Branding of various components
RUN \
    # Jupyter Branding
    cp -f $RESOURCES_PATH/branding/logo.png $CONDA_PYTHON_DIR"/site-packages/notebook/static/base/images/logo.png" && \
    cp -f $RESOURCES_PATH/branding/favicon.ico $CONDA_PYTHON_DIR"/site-packages/notebook/static/base/images/favicon.ico" && \
    cp -f $RESOURCES_PATH/branding/favicon.ico $CONDA_PYTHON_DIR"/site-packages/notebook/static/favicon.ico" && \
    # Fielbrowser Branding
    mkdir -p $RESOURCES_PATH"/filebrowser/img/icons/" && \
    cp -f $RESOURCES_PATH/branding/favicon.ico $RESOURCES_PATH"/filebrowser/img/icons/favicon.ico" && \
    # Todo - use actual png
    cp -f $RESOURCES_PATH/branding/favicon.ico $RESOURCES_PATH"/filebrowser/img/icons/favicon-32x32.png" && \
    cp -f $RESOURCES_PATH/branding/favicon.ico $RESOURCES_PATH"/filebrowser/img/icons/favicon-16x16.png" && \
    cp -f $RESOURCES_PATH/branding/ml-workspace-logo.svg $RESOURCES_PATH"/filebrowser/img/logo.svg"

# Configure Matplotlib
RUN \
    # Import matplotlib the first time to build the font cache.
    MPLBACKEND=Agg python -c "import matplotlib.pyplot" \
    # Stop Matplotlib printing junk to the console on first load
    sed -i "s/^.*Matplotlib is building the font cache using fc-list.*$/# Warning removed/g" $CONDA_PYTHON_DIR/site-packages/matplotlib/font_manager.py

# Create Desktop Icons for Tooling
COPY resources/icons $RESOURCES_PATH/icons

# Copy resources into workspace
COPY resources/tests $RESOURCES_PATH/tests
COPY resources/tutorials $RESOURCES_PATH/tutorials
COPY resources/licenses $RESOURCES_PATH/licenses
COPY resources/reports $RESOURCES_PATH/reports

# Various configurations
RUN \
    chmod +x /usr/local/bin/start-notebook.sh && \
    chmod +x /usr/local/bin/start.sh && \
    chmod +x /usr/local/bin/start-singleuser.sh

# Set default values for environment variables

### END CONFIGURATION ### 

# Small baked-in tool requests
RUN add-apt-repository ppa:libreoffice/ppa && \
    /bin/bash $RESOURCES_PATH/tools/emacs.sh && \
    apt-get install eog && \
    apt-get install libreoffice-calc libreoffice-gtk3 && \
    clean-layer.sh

# Install Jupyter Tooling Extension
COPY resources/jupyter/extensions $RESOURCES_PATH/jupyter-extensions

RUN \
    pip install --no-cache-dir $RESOURCES_PATH/jupyter-extensions/tooling-extension/ && \
    # Cleanup
    clean-layer.sh

# Desktop icons, firefox default
RUN cp /usr/share/applications/firefox.desktop $HOME/Desktop/firefox.desktop && \
    chown ${NB_USER}:${NB_USER} $HOME/Desktop/firefox.desktop && \
    chmod +x $HOME/Desktop/firefox.desktop && \
    update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/firefox 100 && \
    cp /usr/share/applications/code.desktop $HOME/Desktop/code.desktop && \
    chown ${NB_USER}:${NB_USER} $HOME/Desktop/code.desktop && \
    chmod +x $HOME/Desktop/code.desktop && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Link\nName=Netdata\nComment=Hardware Monitoring\nCategories=System;Utility;Development;\nIcon=/resources/icons/netdata-icon.png\nURL=http://localhost:8092/tools/netdata" > $HOME/Desktop/netdata.desktop && \
    chown ${NB_USER}:${NB_USER} $HOME/Desktop/netdata.desktop && \
    chmod +x $HOME/Desktop/netdata.desktop && \
    echo "[Desktop Entry]\nVersion=1.0\nType=Application\nName=LibreOffice Calc\nComment=Perform calculations, analyze information and manage lists in spreadsheets by using Calc.\nExec=libreoffice --calc %U\nIcon=libreoffice-calc\nPath=\nTerminal=false\nStartupNotify=true" > $HOME/Desktop/calc.desktop && \
    chown ${NB_USER}:${NB_USER} $HOME/Desktop/calc.desktop && \
    chmod +x $HOME/Desktop/calc.desktop && \
    # Remove mail and logout desktop icons
    rm /usr/share/applications/exo-mail-reader.desktop

# Hotfix to connect to GUI
# Note: This still seems to be required before the Workspace overwrite hotfix
RUN mv $HOME/.config $HOME/.config2 && \
    mv $HOME/.config2 $HOME/.config && \
    fix-permissions.sh $HOME && \
    chmod a+x /resources/scripts/start-vnc-server.sh 

### Configure supervisor

COPY /resources/supervisor /etc/supervisor

# Default directory for supervisor.sock and supervisor.pid
RUN mkdir /var/run/supervisord && \
    chmod a+w /var/run/supervisord && \
    # Write permissions for supervisor components
    chmod -R a+w /var/log && \
    chmod -R a+w /usr/local/openresty/nginx/ && \
    # Write permission required for configure_nginx.py to update /etc/nginx/nginx.conf
    # Seems to need it on the folder (though non-recursive), +w /etc/nginx/nginx.conf doesn't work...
    chmod a+w /etc/nginx

# Privileged supervisor commands
ARG START_CRON="/usr/sbin/cron -f -L 15"
ARG START_NETDATA="/usr/sbin/netdata -D -p 8050"
ARG START_RSYSLOGD="/usr/sbin/rsyslogd -n"

RUN \
    echo "${NB_USER} ALL=(ALL) NOPASSWD: ${START_CRON}, ${START_NETDATA}, ${START_RSYSLOGD}" >> /etc/sudoers.d/${NB_USER}

### Workspace overwrite hotfix
RUN cp -r /home/$NB_USER /home_nbuser_default && \
    chown -R $NB_USER /home_nbuser_default

### Landing page

COPY resources/nginx/nginx.conf /etc/nginx/nginx.conf
COPY resources/landing_page $RESOURCES_PATH/landing_page/

COPY init.sh /init.sh
RUN chmod +x /init.sh

### Trivy vulnerability test
### RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/master/contrib/install.sh | sh -s -- -b /usr/local/bin
### RUN trivy filesystem -severity CRITICAL /

# use global option with tini to kill full process groups: https://github.com/krallin/tini#process-group-killing
ENTRYPOINT ["/tini", "-g", "--"]

USER ${NB_USER}

# Port 8080 is the main access port (also includes SSH)
# Port 5091 is the VNC port
# Port 3389 is the RDP port
# Port 8090 is the Jupyter Notebook Server
# See supervisor.conf for more ports

EXPOSE 8888

CMD ["/init.sh"] 
