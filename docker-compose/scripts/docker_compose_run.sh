#!/bin/bash

# Take the environment variables setup in docker-compose.yml and inject their values
# into the actual application config.yml file. Note: envsubst needs gettext to be installed.
envsubst < /app/docker-compose/config/config.yml > /app/config/config.yml

bundle exec rubycas-server -p 3002 -c /app/config/config.yml
