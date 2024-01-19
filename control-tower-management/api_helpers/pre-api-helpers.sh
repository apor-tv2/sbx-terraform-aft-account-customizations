#!/bin/bash 
set -x
set -v

echo "Executing Pre-API Helpers"
echo "Test: Pre-API Helpers"
echo "aws sts get-caller-identity"
aws sts get-caller-identity

echo "pwd"
pwd

# Configure Development SSH Key
ssh_key_parameter=$(aws ssm get-parameter --name /aft/config/aft-ssh-key --with-decryption 2> /dev/null || echo "None")

echo "ssh_key_parameter $ssh_key_parameter"

echo "aws codestar-connections list-connections:"
aws codestar-connections list-connections

CodestarConnectionArn=$(aws codestar-connections list-connections --query 'Connections[?ConnectionName==`tv2-infrastructure-SCPs`].ConnectionArn' --output text)
echo "CodestarConnectionArn: >$CodestarConnectionArn<"
if [ -z "$CodestarConnectionArn" ] ; then
	echo "CodestarConnectionArn not found"
	exit 1;
fi

CodestarConnectionArnID=$(echo $CodestarConnectionArn | sed -e 's:.*/::')
echo "CodestarConnectionArnID: $CodestarConnectionArnID"
AccountID=$(aws sts get-caller-identity --query "Account" --output text)
echo "AccountID: $AccountID"
GithubRepo="tv2/infrastructure-SCPs"
echo "git config --global credential.helper '!aws codecommit credential-helper $@'"
git config --global credential.helper '!aws codecommit credential-helper $@'
echo "git config --global credential.UseHttpPath true"
git config --global credential.UseHttpPath true
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
echo "git clone --quiet -b https://codestar-connections.$AWS_REGION.amazonaws.com/git-http/$AccountID/$AWS_REGION/$CodestarConnectionArnID/$GithubRepo.git $DEFAULT_PATH/$CUSTOMIZATION/terraform/modules/infrastructure-SCPs"
git clone --quiet -b https://codestar-connections.$AWS_REGION.amazonaws.com/git-http/$AccountID/$AWS_REGION/$CodestarConnectionArnID/$GithubRepo.git $DEFAULT_PATH/$CUSTOMIZATION/terraform/modules/infrastructure-SCPs
export TF_VAR_CodestarGithubInfrastructureSCPsSource="https://codestar-connections.$AWS_REGION.amazonaws.com/git-http/$AccountID/$AWS_REGION/$CodestarConnectionArnID/$GithubRepo.git"

