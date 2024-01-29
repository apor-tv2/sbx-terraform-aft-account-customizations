#!/bin/bash

echo "Executing Post-API Helpers"
echo find / -type d -path "*/modules/org_scp"
find / -type d -path "*/modules/org_scp" 2>/dev/null
echo "pwd"
pwd
