#!/bin/bash

echo "Executing Post-API Helpers"
#echo find / -type d -path "*/modules/org_scp"
#find / -type d -path "*/modules/org_scp" 2>/dev/null
#echo "pwd"
#pwd
echo cat $DEFAULT_PATH/$CUSTOMIZATION/terraform/.terraform/modules/scp-sbx-sandbox/main.tf
cat $DEFAULT_PATH/$CUSTOMIZATION/terraform/.terraform/modules/scp-sbx-sandbox/main.tf

echo ls $DEFAULT_PATH/$CUSTOMIZATION/terraform/.terraform/modules/scp-sbx-sandbox/
ls $DEFAULT_PATH/$CUSTOMIZATION/terraform/.terraform/modules/scp-sbx-sandbox/

