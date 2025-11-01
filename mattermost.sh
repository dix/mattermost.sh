#!/bin/bash

########################
############ Variables
########################
WEBHOOK_URL=""
TITLE="mattermost.sh notification"
AVATAR="https://raw.githubusercontent.com/dix/mattermost.sh/refs/heads/main/mattermost.sh.png"
USERNAME="mattermost.sh"
CHANNEL=""
CURRENT_DATE=$(TZ='Europe/Paris' date +"%Y-%m-%d")
CURRENT_TIME=$(TZ='Europe/Paris' date +"%H:%M:%S")
DESCRIPTION=""
COLOR="#ca00d8"
declare -a FIELDS=()
declare -a LINKS=()

########################
############ Functions
########################
usage() {
  echo "Usage: $0 --webhook-url WEBHOOK_URL [--title TITLE] [--username USERNAME] [--avatar AVATAR] [--channel CHANNEL] [--description DESCRIPTION] [--color COLOR] --field \"KEY;VALUE\" [--field \"KEY2;VALUE2\" ...] --link \"TITLE;URL\" [--link \"TITLE2;URL2\" ...]"
  exit 0
}

parse_arguments() {
  while [[ $# -gt 0 ]]; do
    case $1 in
    --webhook-url)
      WEBHOOK_URL="$2"
      shift 2
      ;;
    --title)
      TITLE="$2"
      shift 2
      ;;
    --avatar)
      AVATAR="$2"
      shift 2
      ;;
    --username)
      USERNAME="$2"
      shift 2
      ;;
    --channel)
      CHANNEL="$2"
      shift 2
      ;;
    --description)
      DESCRIPTION="$2"
      shift 2
      ;;
    --color)
      COLOR="$2"
      shift 2
      ;;
    --field)
      IFS=';' read -r key value <<<"$2"
      FIELDS+=("{\"title\":\"$key\",\"value\":\"$value\",\"short\":false}")
      shift 2
      ;;
    --link)
      IFS=';' read -r key value <<<"$2"
      LINKS+=("🔗 [$key]($value)")
      shift 2
      ;;
    *)
      usage
      ;;
    esac
  done
}

check_arguments() {
  if [[ -z "$WEBHOOK_URL" ]]; then
    usage
  fi
}

join_arrays() {
  if [ ${#FIELDS[@]} -gt 0 ]; then
    FIELDS_JSON=$(
      IFS=,
      echo "${FIELDS[*]}"
    )
  else
    FIELDS_JSON=""
  fi

  if [ ${#LINKS[@]} -gt 0 ]; then
    LINKS_TEXT=$(printf "\n\n%s" "$(printf '%s\n' "${LINKS[@]}")")
  else
    LINKS_TEXT=""
  fi
}

generate_payload() {
  local full_description="${DESCRIPTION}${LINKS_TEXT}"

  local jq_args=(
    --arg username "$USERNAME"
    --arg avatar "$AVATAR"
    --arg title "$TITLE"
    --arg description "$full_description"
    --arg current_date "$CURRENT_DATE"
    --arg current_time "$CURRENT_TIME"
    --arg color "$COLOR"
  )

  if [[ -n "$CHANNEL" ]]; then
    jq_args+=(--arg channel "$CHANNEL")
  fi

  local jq_filter='{
    username: $username,
    icon_url: $avatar'

  if [[ -n "$CHANNEL" ]]; then
    jq_filter+=',
    channel: $channel'
  fi

  jq_filter+=',
    attachments: [
      {
        color: $color,
        title: $title,
        text: $description,
        footer: "\($current_date) \($current_time)"'

  if [[ -n "$FIELDS_JSON" ]]; then
    jq_args+=(--arg fields "[$FIELDS_JSON]")
    jq_filter+=',
        fields: ($fields | fromjson)'
  fi

  jq_filter+='
      }
    ]
  }'

  PAYLOAD=$(jq -n "${jq_args[@]}" "$jq_filter")
}

send_notification() {
  curl \
    --header "Content-Type: application/json" \
    --request POST \
    --data "${PAYLOAD}" \
    "${WEBHOOK_URL}"
}

########################
############ Main Content
########################
parse_arguments "$@"

check_arguments

join_arrays

generate_payload

send_notification
