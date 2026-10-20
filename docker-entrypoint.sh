#!/bin/sh
set -eu

token_file="${CF_API_TOKEN_FILE:-/run/secrets/cloudflare_api_token}"

if [ ! -r "$token_file" ]; then
    echo "Cloudflare API token file is missing or unreadable: $token_file" >&2
    exit 1
fi

CF_API_TOKEN="$(cat "$token_file")"
export CF_API_TOKEN

exec /usr/bin/caddy "$@"

