FROM node:18.12-slim

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get autoremove

RUN adduser --disabled-password --home /home/container container
USER container
ENV USER=container HOME=/home/container

WORKDIR /home/container

COPY ./projectdefaults/ ./

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]