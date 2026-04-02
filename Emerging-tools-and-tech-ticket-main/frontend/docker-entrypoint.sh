#!/bin/sh

# Default to docker-compose backend URL if not set
BACKEND_URL=${BACKEND_URL:-backend:5000}

# Substitute environment variable in nginx config
envsubst '${BACKEND_URL}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Start nginx
exec nginx -g 'daemon off;'
