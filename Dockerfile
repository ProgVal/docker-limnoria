FROM centos:7

MAINTAINER libcrack <devnull@libcrack.so>

LABEL summary="Limnoria Docker Image"

#ENV SUPYBOT_CHANNELS
#ENV SUPYBOT_PASSWORD
#ENV SUPYBOT_PREFIX_STRINGS
ENV SUPYBOT_HOME=/var/supybot \
    SUPYBOT_IDENT=supybot \
    SUPYBOT_NETWORK=freenode \
    SUPYBOT_NICK=supybot \
    SUPYBOT_PORT=6697 \
    SUPYBOT_PREFIXES=! \
    SUPYBOT_SERVER=irc.freenode.net \
    SUPYBOT_USER=supybot \
    SUPYBOT_USE_SSL=True \
    SUPYBOT_OWNER=owner \
    SUPYBOT_OWNER_PASS=owner \
    LANG=C

RUN useradd -u 1001 -g 0 -d ${SUPYBOT_HOME}/ -m -r -s /usr/sbin/nologin supybot && \
    mkdir -p ${SUPYBOT_HOME}/backup ${SUPYBOT_HOME}/data/tmp ${SUPYBOT_HOME}/logs/plugins ${SUPYBOT_HOME}/plugins ${SUPYBOT_HOME}/tmp && \
    yum -y -q --setopt=tsflags=nodocs install epel-release git-core && \
    yum -y -q --setopt=tsflags=nodocs install python-pip && \
    git clone https://github.com/ProgVal/Limnoria.git /tmp/Limnoria && \
    cd /tmp/Limnoria && \
    # Avoid copy as it tries to alter permission bits which fail inside OS.
    # This won't be required when testing is merged into master branch (PR 1279)
    sed -i 's/shutil.copy/shutil.copyfile/g' scripts/supybot && \
    pip -q install -r requirements.txt && \
    python ./setup.py -q install && \
    yum -y -q remove --setopt=clean_requirements_on_remove=1 git-core && \
    yum clean all && \
    rm -rf /tmp/Limnoria

# Plugin installation done in separate layer
COPY plugin-sources /tmp
RUN yum -y -q --setopt=tsflags=nodocs install git-core && \
    cd ${SUPYBOT_HOME}/plugins && \
    while read f; do git clone $f ; done</tmp/plugin-sources && \
    rm -f /tmp/plugin-sources && \
    yum -y -q remove --setopt=clean_requirements_on_remove=1 git-core && \
    yum clean all

COPY ["start.sh","/usr/local/bin/"]

COPY supybot/ ${SUPYBOT_HOME}/

RUN chown -R 1001:0 ${SUPYBOT_HOME} && \
    chmod -R 666 ${SUPYBOT_HOME} && \
    find ${SUPYBOT_HOME} -type d -exec chmod 777 {} +

USER 1001

WORKDIR ${SUPYBOT_HOME}

# Exec form does not do parameter substitution.
CMD "/usr/local/bin/start.sh" "${SUPYBOT_HOME}/supybot.conf"
