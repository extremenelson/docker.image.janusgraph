# JanusGraph

FROM takaomag/base:2017.07.07.07.16

ENV \
    X_DOCKER_REPO_NAME=janusgraph \
    X_JANUSGRAPH_VERSION=0.1.1

RUN \
    echo "2016-03-08-0" > /dev/null && \
    export TERM=dumb && \
    export LANG='en_US.UTF-8' && \
    source /opt/local/bin/x-set-shell-fonts-env.sh && \
    echo -e "${FONT_INFO}[INFO] Update package database${FONT_DEFAULT}" && \
    reflector --latest 100 --verbose --sort score --save /etc/pacman.d/mirrorlist && \
    sudo -u nobody yaourt -Syy && \
    echo -e "${FONT_SUCCESS}[SUCCESS] Update package database${FONT_DEFAULT}" && \
    echo -e "${FONT_INFO}[INFO] Refresh package developer keys${FONT_DEFAULT}" && \
    pacman-key --refresh-keys && \
    echo -e "${FONT_SUCCESS}[SUCCESS] Refresh package developer keys${FONT_DEFAULT}" && \
    REQUIRED_PACKAGES=("jre8-openjdk-headless") && \
    echo -e "${FONT_INFO}[INFO] Install required packages [${REQUIRED_PACKAGES[@]}]${FONT_DEFAULT}" && \
    sudo -u nobody yaourt -S --needed --noconfirm --noprogressbar "${REQUIRED_PACKAGES[@]}" && \
    echo -e "${FONT_SUCCESS}[SUCCESS] Install required packages [${REQUIRED_PACKAGES[@]}]${FONT_SUCCESS}" && \
    echo -e "${FONT_INFO}[INFO] Install janusgraph-${X_JANUSGRAPH_VERSION}${FONT_DEFAULT}" && \
    cd /var/tmp && \
    curl --silent --location --fail --retry 5 "https://github.com/JanusGraph/janusgraph/releases/download/v${X_JANUSGRAPH_VERSION}/janusgraph-${X_JANUSGRAPH_VERSION}-hadoop2.zip" | bsdtar -xf- -C /opt/local && \
    porg --log --package="janusgraph-${X_JANUSGRAPH_VERSION}" -- mv /opt/local/janusgraph-${X_JANUSGRAPH_VERSION}-hadoop2 /opt/local/janusgraph-${X_JANUSGRAPH_VERSION} && \
    porg --log --package="janusgraph-${X_JANUSGRAPH_VERSION}" -+ -- ln -sf /opt/local/janusgraph-${X_JANUSGRAPH_VERSION} /opt/local/janusgraph && \
    echo -e "${FONT_SUCCESS}[SUCCESS] Install janusgraph-${X_JANUSGRAPH_VERSION}${FONT_DEFAULT}" && \
    echo -e "${FONT_INFO}[INFO] Install required python packages [gremlinpython]${FONT_DEFAULT}" && \
    /opt/local/python-3/bin/pip3 install --upgrade gremlinpython && \
    echo -e "${FONT_SUCCESS}[SUCCESS] Install required packages [gremlinpython]${FONT_DEFAULT}" && \
    /opt/local/bin/x-archlinux-remove-unnecessary-files.sh && \
#    pacman-optimize && \
    rm -f /etc/machine-id

WORKDIR /opt/local/janusgraph

EXPOSE \
    8182

