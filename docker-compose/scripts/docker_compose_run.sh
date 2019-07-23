#!/bin/bash

#sleep 15s until db is up and running
sleep 15

envsubst < /app/docker-compose/config/config.yml > /app/config/config.yml

bundle exec rubycas-server -p 3002 -c /app/config/config.yml
