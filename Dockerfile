FROM centos:7

LABEL summary="Limnoria Docker Image"

#ENV SUPYBOT_CHANNELS
#ENV SUPYBOT_PASSWORD
#ENV SUPYBOT_PREFIX_STRINGS
ENV HOME=/var/supybot \
    SUPYBOT_HOME=${HOME} \
    SUPYBOT_IDENT=supybot \
    SUPYBOT_NETWORK=freenode \
    SUPYBOT_NICK=supybot \
    SUPYBOT_PORT=6697 \
    SUPYBOT_PREFIXES=! \
    SUPYBOT_SERVER=irc.freenode.net \
    SUPYBOT_USER=supybot \
    SUPYBOT_USE_SSL=True \
    SUPYBOT_OWNER=owner \
    SUPYBOT_OWNER_PASS=owner

COPY plugin-sources /tmp
RUN yum -y --setopt=tsflags=nodocs install epel-release git-core && \
    yum -y --setopt=tsflags=nodocs install limnoria && \
    # Avoid copy as it tries to alter permission bits which fail inside OS.
    sed -i 's/shutil.copy/shutil.copyfile/g' /usr/bin/supybot && \
    useradd -u 1001 -g 0 -d ${HOME}/ -m -r -s /usr/sbin/nologin default && \
    mkdir -p ${HOME}/backup ${HOME}/data/tmp ${HOME}/logs/plugins ${HOME}/plugins ${HOME}/tmp && \
    cd ${HOME}/plugins && \
    while read f; do git clone $f ; done</tmp/plugin-sources && \
    yum -y remove --setopt=clean_requirements_on_remove=1 git && \
    yum clean all

COPY ["start.sh","/usr/local/bin/"]

COPY supybot/ ${HOME}/

RUN chown -R 1001:0 ${HOME} && \
    chmod -R 666 ${HOME} && \
    find ${HOME} -type d -exec chmod 777 {} +

USER 1001

WORKDIR ${HOME}

# Exec form does not do parameter substitution.
CMD "/usr/local/bin/start.sh" "${HOME}/supybot.conf"
