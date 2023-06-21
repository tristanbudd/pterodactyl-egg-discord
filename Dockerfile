FROM node:18.12-alpine

RUN apk update && \
	apk upgrade && \
	apk add --no-cache bash

RUN adduser --disabled-password --home /home/container container
USER container
ENV USER=container HOME=/home/container

WORKDIR /home/container

COPY ./projectdefaults/ ./

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]