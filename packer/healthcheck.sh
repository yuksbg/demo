#!/bin/bash

fail_count=0
while true; do
  response=$(curl --write-out %{http_code} --silent --output /dev/null http://127.0.0.1:8080)
  echo "Response: $response"

  if [[ "$response" == "200" || "$response" == "301" ]]; then
    echo "Application is available"
    exit 0
  fi

  fail_count=$((fail_count + 1))

  if (( fail_count > 40 )); then
    echo "Application is still unavailable"
    exit 2
  fi

  echo "Sleeping"
  sleep 10
done