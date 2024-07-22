#!/bin/bash

# Configuration
URL="http://web-server/metrics"
LOGFILE="server_status.log"
RETRY_COUNT=3
RETRY_INTERVAL=5
NUM_REQUESTS=1000
CONCURRENCY=10

# Function to generate load on the server
generate_load() {
  TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
  ab -n $NUM_REQUESTS -c $CONCURRENCY $URL > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "$TIMESTAMP - Load generated: $NUM_REQUESTS requests with concurrency $CONCURRENCY" >> $LOGFILE
  else
    echo "$TIMESTAMP - Error: Failed to generate load on the server" >> $LOGFILE
  fi
}

# Function to check the status of the server
check_status() {
  HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" $URL)
  TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
  
  if [ $HTTP_STATUS -eq 000 ]; then
    echo "$TIMESTAMP - Error: Unable to reach the server at $URL" >> $LOGFILE
  else
    echo "$TIMESTAMP - Status: $HTTP_STATUS" >> $LOGFILE
  fi
  
  echo "Checked at $TIMESTAMP - Status: $HTTP_STATUS"
  return $HTTP_STATUS
}

# Function to retry checking the status in case of failure
retry_check() {
  local attempts=0
  local status

  while [ $attempts -lt $RETRY_COUNT ]; do
    status=$(curl -o /dev/null -s -w "%{http_code}" $URL)
    if [ $status -eq 200 ]; then
      echo "Success after $attempts attempts."
      return 0
    fi
    ((attempts++))
    sleep $RETRY_INTERVAL
  done

  TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
  
  if [ $status -eq 000 ]; then
    echo "$TIMESTAMP - Error: Unable to reach the server at $URL (after $RETRY_COUNT retries)" >> $LOGFILE
  else
    echo "$TIMESTAMP - Status: $status (after $RETRY_COUNT retries)" >> $LOGFILE
  fi
  
  echo "Failed after $RETRY_COUNT attempts. Status: $status"
  return 1
}

# Main loop to keep generating load and checking the status
while true; do
  generate_load
  if ! check_status; then
    retry_check
  fi
done
