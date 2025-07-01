# Set the Node.js version (default: LTS)
ARG NODE_VERSION=lts
FROM node:${NODE_VERSION}-alpine

# Install essential packages
RUN apk update && \
    apk upgrade && \
    apk add --no-cache curl bash

# Set working directory
WORKDIR /home/container

# Enable Corepack without download prompt
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
RUN corepack enable

# Add non-root user (no password)
RUN adduser -D -h /home/container container

# Set permissions for the working directory
RUN chown -R container:container /home/container && \
    chmod -R 755 /home/container

# Switch to the non-root user
USER container

# Copy entrypoint (corrected path)
COPY ./entrypoint.sh /home/container/entrypoint.sh
RUN chmod +x /home/container/entrypoint.sh

# Run the entrypoint script
CMD ["/bin/bash", "/home/container/entrypoint.sh"]