#!/bin/bash

SECONDS=$1

echo "Checking pod status every $SECONDS seconds..."

while true; do
  echo "Checking pod status..."
  # Remove header
  STATUSES=$(kubectl get pods -n kubeflow --no-headers)

  echo "$STATUSES"

  TOTAL=$(echo "$STATUSES" | wc -l)
  # Extract STATUS column (3rd column)
  RUNNING=$(echo "$STATUSES" | awk '{print $3}' | grep -c "^Running$")
  if [ "$TOTAL" -eq "$RUNNING" ] && [ "$TOTAL" -ne 0 ]; then
    echo "all pods are running"
    break
  else
    echo "$RUNNING / $TOTAL pods are running..."
  fi
  sleep $SECONDS
done