#!/bin/bash

echo "Executing Pre-API Helpers"
echo "Test: Pre-API Helpers"
echo "aws sts get-caller-identity"
aws sts get-caller-identity

# Configure Development SSH Key
ssh_key_parameter=$(aws ssm get-parameter --name /aft/config/aft-ssh-key --with-decryption 2> /dev/null || echo "None")
echo "ssh_key_parameter $ssh_key_parameter"
