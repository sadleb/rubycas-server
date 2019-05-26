#!/bin/bash

#sleep 15s until db is up and running
sleep 15

eval "cat <<EOF
$(</app/docker-compose/config/config.yml)
EOF
" | tee /app/docker-compose/config/appconfig.yml 2> /dev/null


bundle exec rubycas-server -p 3002 -c /app/docker-compose/config/appconfig.yml
