#!/bin/bash
export DOLLAR='$'
envsubst '${VIRTUAL_HOST} ${PUBLIC_SYMFONY_DIRECTORY}' < /etc/nginx/conf.d/app.conf.template > /etc/nginx/conf.d/default.conf

exec "$@"
