#!/bin/bash

# added a sleep since docker compose start can take time to start the application
sleep 60 

test_result=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3002/login)

echo $test_result
if [ $test_result == 200 ]
then
  echo "success"
else
  echo "fail"
  exit 1
fi
