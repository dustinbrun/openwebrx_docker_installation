#!/bin/sh

echo "Restarter script started..."

while true; do

  while [ $(date +%H:%M) != "02:00" ]; do 
	sleep 30; 
  done
  # Container time is UTC!!
  # sleep 86400  # Sleep for 24 hours
  
  echo "Restarting Container ..."
  docker restart openwebrx_docker
  
  sleep 60;

done