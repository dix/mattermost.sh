#!/bin/bash

WEBHOOK_URL=""

echo "Calling mattermost.sh..."

# Default test
./mattermost.sh --webhook-url "$WEBHOOK_URL"

# Detailed test
./mattermost.sh --webhook-url "$WEBHOOK_URL" \
--title "Test mattermost.sh 🐱"  \
--username "mattermost.sh"  \
--avatar "https://raw.githubusercontent.com/dix/mattermost.sh/refs/heads/main/mattermost.sh.png" \
--description "Hello World!" \
--color "#0A8300" \
--field "Field A;Value A"  \
--field "Field B;Value B"  \
--link "Repo URL;https://github.com/dix/mattermost.sh"  \
--link "EC;https://escapecollective.com/"

# Overriding default channel test
./mattermost.sh --webhook-url "$WEBHOOK_URL" \
--channel "test-mattermost"

echo "Call complete."
