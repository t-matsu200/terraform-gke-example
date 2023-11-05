#!/bin/bash

terraform init

echo "Start terraform apply"

terraform apply -auto-approve

if [ $? -ne 0 ]; then
  echo "Failed terraform apply"
  exit 1
fi

echo "End terraform apply"
