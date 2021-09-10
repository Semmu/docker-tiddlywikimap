# shamelessly stolen from: https://github.com/neechbear/tiddlywiki

ARG NODE_VERSION=16.9.0
ARG ALPINE_VERSION=3.14
ARG TW_VERSION=5.1.23

FROM alpine:${ALPINE_VERSION} AS bundleplugins

RUN cd /tmp && \
    wget https://github.com/felixhayashi/TW5-TiddlyMap/archive/refs/heads/master.zip -O TiddlyMap.zip && \
    wget https://github.com/felixhayashi/TW5-Vis.js/archive/refs/heads/master.zip -O Vis.js.zip && \
    wget https://github.com/felixhayashi/TW5-HotZone/archive/refs/heads/master.zip -O HotZone.zip && \
    wget https://github.com/felixhayashi/TW5-TopStoryView/archive/refs/heads/master.zip -O TopStoryView.zip && \
    for FILE in *.zip ; do unzip $FILE ; done && \
    mkdir plugins && \
    mv TW5-HotZone-master/dist/felixhayashi/hotzone plugins && \
    mv TW5-TiddlyMap-master/dist/felixhayashi/tiddlymap plugins && \
    mv TW5-TopStoryView-master/dist/felixhayashi/topstoryview plugins && \
    mv TW5-Vis.js-master/dist/felixhayashi/vis plugins

FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION}

LABEL vcs="https://github.com/Semmu/docker-tiddlywikimap" \
      description="TiddlyWiki bundled with TiddlyMap in a Docker container" \
      base_image="node:${NODE_VERSION}-alpine${ALPINE_VERSION}" \
      version="tw:${TW_VERSION}-node:${NODE_VERSION}-alpine:${ALPINE_VERSION}" \
      com.tiddlywiki.version="${TW_VERSION}" \
      com.tiddlywiki.homepage="https://tiddlywiki.com" \
      com.tiddlywiki.author="Jeremy Ruston" \
      com.tiddlywiki.vcs="https://github.com/Jermolene/TiddlyWiki5"

RUN apk add libcap \
 && setcap 'cap_net_bind_service=+ep' /usr/local/bin/node \
 && apk del libcap

RUN apk del libc-utils musl-utils scanelf apk-tools \
 && rm -Rf /lib/apk /var/cache/apk /etc/apk /usr/share/apk \
 && find ~root/ ~node/ -mindepth 1 -delete

RUN mkdir -p /var/lib/tiddlywiki \
 && chown -R node:node /var/lib/tiddlywiki

COPY --from=bundleplugins --chown=1000:1000 /tmp/plugins /plugins

VOLUME /var/lib/tiddlywiki
WORKDIR /var/lib/tiddlywiki

RUN npm install -g "tiddlywiki@${TW_VERSION}"

ENV TW_WIKINAME="tiddlywikimap" \
    TW_PORT="8080" \
    TW_ROOTTIDDLER="$:/core/save/all" \
    TW_RENDERTYPE="text/plain" \
    TW_SERVETYPE="text/html" \
    TW_USERNAME="anonymous" \
    TW_PASSWORD="" \
    TW_HOST="0.0.0.0" \
    TW_PATHPREFIX=""

EXPOSE 8080/tcp

ADD init-and-run /usr/local/bin/init-and-run

USER node

CMD ["/bin/sh","/usr/local/bin/init-and-run"]
