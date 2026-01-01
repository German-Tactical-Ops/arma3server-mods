FROM --platform=$BUILDPLATFORM cm2network/steamcmd:root

ENV DEBIAN_FRONTEND=noninteractive

# Install UTF-8 unicode
RUN echo "**** Install UTF-8 ****" \
    && apt-get update \
    && apt-get install -y locales apt-utils debconf-utils \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

## Upgrade Ubuntu
RUN echo "**** apt upgrade ****" \
    && dpkg --add-architecture i386 \
    && apt-get update; \
    apt-get upgrade -y

## Install Requirements
# RUN echo "**** Install Requirements ****" \
#    && apt-get update \
#    && apt-get install -y software-properties-common \
#    && apt-get update \
#    && apt-get install -y \
#    bc binutils bsdmainutils bzip2 \
#    ca-certificates cron cpio curl \
#    distro-info file gzip hostname jq \
#    lib32stdc++6 lib32gcc-s1 libsdl2-2.0-0:i386 \
#    netcat-openbsd pigz python3 \
#    tar tmux unzip util-linux \
#    wget xz-utils \
#    iproute2 iputils-ping nano sudo tini \
#    tree uuid-runtime procps grep

# RUN add-apt-repository multiverse
# p7zip-full dos2unix rsync lsof procps iproute2 iputils-ping tzdata procps iproute2 util-linux coreutils bc netcat lib32gcc1

# Install Cleanup
RUN echo "**** Cleanup ****"  \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

# Arma3-User anlegen
ARG USERNAME=arma3server
ARG UID=1001
ARG GID=1001
RUN groupadd -g ${GID} ${USERNAME} || true \
    && useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME}

# create /etc/arma3 dir
RUN mkdir -p "/etc/arma3" \
    && chown -R ${USERNAME}:${USERNAME} "/etc/arma3"

WORKDIR /home/${USERNAME}
USER ${USERNAME}

ARG SCRIPT="/etc/arma3/scripts"
ARG HTML_DIR="/etc/arma3/html"

# copy scripts
COPY --chown=${USERNAME}:${USERNAME} scripts/* ${SCRIPT}/
RUN chmod +x ${SCRIPT}/*



# copy html
RUN mkdir -p ${HTML_DIR}/raw \
    && chown -R ${USERNAME}:${USERNAME} "${HTML_DIR}/raw"
COPY --chown=${USERNAME}:${USERNAME} ./arma3server-html/* ${HTML_DIR}/raw
RUN find ${HTML_DIR}/raw -iname "*.html" -exec mv {} ${HTML_DIR} \;
RUN find ${HTML_DIR}/ . -type d -empty -delete

ENTRYPOINT ["bash","/etc/arma3/scripts/entrypoint.sh"]
