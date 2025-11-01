# mattermost.sh

* [Presentation](#presentation "Presentation")
* [Dependencies](#dependencies "Dependencies")
* [Usage](#usage "Usage")
* [Options](#options "Options")
* [Docker](#docker "Docker")
* [Limitations](#limitations "Limitations")
* [Acknowledgements](#acknowledgements "Acknowledgements")

## Presentation

A pure bash script sending Mattermost notifications through incoming webhooks.

[![Notification example](./static/notification_example.png#center "Notification example")](./static/notification_example.png)

## Dependencies

* [jq](https://jqlang.org/ "JQLang")

## Usage

1. [Get a webhook URL](https://developers.mattermost.com/integrate/webhooks/incoming/ "Mattermost")
2. Download `mattermost.sh` and make sure it has the `execute` authorization (`chmod +x mattermost.sh`)
3. Call `mattermost.sh --webhook-url $WEBHOOK_URL` to test it
4. Fully configure your notifications using the whole set of options described below

## Options

[![Notification content](./static/notification_content.png#center "Notification content")](./static/notification_content.png)

1. `--title`
2. `--username`
3. `--avatar`
4. `--description`
5. `--color`
6. `--field`
7. `--link`
8. `--channel`

⚠️ **None of those parameters are required** ⚠️

### `--title STRING`

Set a title to the notification

### `--username STRING`

Set an author to the notification

### `--avatar URL`

Set a custom avatar for the notification author

### `--description STRING`

Add a text description to the notification

### `--color (#hex-color)`

Set the color of the notification.

### `--field STRING;STRING`

Add a field `NAME Value` to the notification.

This option can be provided O to n times to add n fields.

### `--link STRING;URL`

Add a link to the notification.

This option can be provided O to n times to add n links.

### `--channel STRING`

Overwrite the default channel to send the notification to.

The incoming webhook must not be locked to its default channel.

## Docker

A Docker image is available: `ghcr.io/dix/mattermost.sh`.

It can be used directly within a CI job to send notifications using a lightweight image.

List of tags: [https://github.com/dix/mattermost.sh/pkgs/container/mattermost.sh](https://github.com/dix/mattermost.sh/pkgs/container/mattermost.sh "GitHub").

## Limitations

In its current iteration, the script relies on some hard-coded settings that can't be changed through parameters and require important changes to the source code, mainly:
- timezones for the notifications

## Acknowledgements

Heavily inspired by [fieu/discord.sh](https://github.com/fieu/discord.sh "GitHub").