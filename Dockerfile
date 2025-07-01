# Set the Node.js version (default: LTS)
ARG NODE_VERSION=lts
FROM node:${NODE_VERSION}-alpine

# Install essential packages, including git and bash
RUN apk update && \
    apk upgrade && \
    apk add --no-cache curl bash git

# Set working directory
WORKDIR /home/container

# Add non-root user (no password)
RUN adduser -D -h /home/container container

# Set permissions for the working directory
RUN chown -R container:container /home/container && \
    chmod -R 755 /home/container

# Copy entrypoint *outside* the mounted directory to avoid overwrite
COPY ./entrypoint.sh /entrypoint.sh

# Set executable permissions BEFORE switching user
RUN chmod +x /entrypoint.sh

# Switch to the non-root user
USER container

# Run the entrypoint script using /bin/sh (Alpine default shell)
CMD ["/bin/sh", "/entrypoint.sh"]
