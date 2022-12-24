FROM node:lts-slim

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get autoremove

RUN mkdir -p /home/container
WORKDIR /home/container

RUN npm install --global --force yarn@latest

COPY ./projectdefaults/ /

COPY ./entrypoint.sh /entrypoint.sh

RUN yarn install

CMD ["/bin/bash", "/entrypoint.sh"]