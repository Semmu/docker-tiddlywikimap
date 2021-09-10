# shamelessly stolen from: https://github.com/neechbear/tiddlywiki

#
# MIT License
# Copyright (c) 2017-2020 Nicola Worthington <nicolaw@tfb.net>
#
# https://nicolaw.uk
# https://nicolaw.uk/#TiddlyWiki
#

ARG BASE_IMAGE=node:14.9.0-alpine3.12
FROM ${BASE_IMAGE}

ARG BASE_IMAGE=node:14.9.0-alpine3.12
ARG TW_VERSION=5.1.22

LABEL author="Nicola Worthington <nicolaw@tfb.net>" \
      copyright="Copyright (c) 2017-2020 Nicola Worthington <nicolaw@tfb.net>" \
      homepage="https://nicolaw.uk/#TiddlyWiki" \
      vcs="https://github.com/NeechBear/tiddlywiki" \
      description="TiddlyWiki - a non-linear personal web notebook" \
      base_image="$BASE_IMAGE" \
      version="$TW_VERSION-$BASE_IMAGE" \
      com.tiddlywiki.version="$TW_VERSION" \
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
VOLUME /var/lib/tiddlywiki
WORKDIR /var/lib/tiddlywiki

RUN npm install -g "tiddlywiki@${TW_VERSION}"

ENV TW_WIKINAME="mywiki" \
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
