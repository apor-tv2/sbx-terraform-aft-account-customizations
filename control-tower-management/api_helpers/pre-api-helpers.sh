#!/bin/bash

echo "Executing Pre-API Helpers"
echo "Test: Pre-API Helpers"
echo "aws sts get-caller-identity"
aws sts get-caller-identity

echo "pwd"
pwd

# Configure Development SSH Key
ssh_key_parameter=$(aws ssm get-parameter --name /aft/config/aft-ssh-key --with-decryption 2> /dev/null || echo "None")

echo "ssh_key_parameter $ssh_key_parameter"

CodestarConnectionArn=$(aws codestar-connections list-connections --query 'Connections[?ConnectionName==`tv2-infrastructure-SCPs`].ConnectionArn' --output text)
echo "CodestarConnectionArn: >$CodestarConnectionArn<"
if [ -z "$CodestarConnectionArn" ] ; then
	echo "CodestarConnectionArn not found"
	exit 1;
fi
CodestarConnectionArnID=$(echo $CodestarConnectionArn | sed -e 's:.*/::')
AccountID=$(aws sts get-caller-identity --query "Account" --output text)
GithubRepo="tv2/infrastructure-SCPs"
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
# add --quiet
git clone -b https://codestar-connections.$AWS_REGION.amazonaws.com/git-http/$AccountID/$AWS_REGION/$CodestarConnectionArnID/$GithubRepo.git $CUSTOMIZATION/modules/infrastructure-SCPs
find $DEFAULT_PATH/$CUSTOMIZATION
echo "DEFAULT_PATH $DEFAULT_PATH"
echo "VENDED_ACCOUNT_ID $VENDED_ACCOUNT_ID"
echo "CUSTOMIZATION $CUSTOMIZATION"
echo "DEFAULT_PATH $DEFAULT_PATH"
echo "TIMESTAMP $TIMESTAMP"
echo "TF_VERSION $TF_VERSION"
echo "TF_DISTRIBUTION $TF_DISTRIBUTION"
echo "CT_MGMT_REGION $CT_MGMT_REGION"
echo "AFT_MGMT_ACCOUNT $AFT_MGMT_ACCOUNT"
echo "AFT_EXEC_ROLE_ARN $AFT_EXEC_ROLE_ARN"
echo "VENDED_EXEC_ROLE_ARN $VENDED_EXEC_ROLE_ARN"
echo "AFT_ADMIN_ROLE_NAME $AFT_ADMIN_ROLE_NAME"
echo "AFT_ADMIN_ROLE_ARN $AFT_ADMIN_ROLE_ARN"
echo "ROLE_SESSION_NAME $ROLE_SESSION_NAME"
#git clone --quiet -b $AWS_MODULE_GIT_REF $AWS_MODULE_SOURCE aws-aft-core-framework


