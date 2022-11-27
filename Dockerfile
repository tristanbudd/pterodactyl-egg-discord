FROM node:lts-slim

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install python -y
RUN apt-get autoremove

    # Ensure UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8


WORKDIR /home/container

RUN npm install --global --force yarn@latest

COPY ./projectdefaults/ /

RUN yarn add discord.js @discordjs/voice

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]