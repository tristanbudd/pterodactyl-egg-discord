ARG NODE_VERSION=lts

FROM node:$NODE_VERSION-alpine

RUN apk update && \
    apk upgrade && \
    apk add --no-cache curl bash

RUN curl --compressed -o- -L https://yarnpkg.com/install.sh | bash

RUN adduser --disabled-password --home /home/container container

WORKDIR /home/container

ENV USER=container HOME=/home/container
USER container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]