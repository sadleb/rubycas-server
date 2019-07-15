#!/bin/bash

# added a sleep since kubernets deployment can take time to propogate
sleep 60 

test_result=$(curl -s -o /dev/null -w "%{http_code}" http://rubycas.k8.bebraven.org/login)

echo $test_result
if [ $test_result == 200 ]
then
  echo "success"
else
  echo "fail"
  exit 1
fi
