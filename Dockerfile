FROM alpine:3.22

# Install bash, curl, and jq
RUN apk add --no-cache bash curl jq

# Copy mattermost.sh and make it executable
COPY mattermost.sh /usr/local/bin/mattermost.sh
RUN chmod +x /usr/local/bin/mattermost.sh

# Set bash as default shell
SHELL ["/bin/bash", "-c"]