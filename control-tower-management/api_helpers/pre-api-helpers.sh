#!/bin/bash 
#set -e 
##set -x
##set -v


#echo "Executing Pre-API Helpers"
#
#echo "aws sts get-caller-identity"
#aws sts get-caller-identity
#pwd
#gitclonescriptwithpath=$(find . -name "git_clone_with_deploy_key.sh")
#chmod u+x $gitclonescriptwithpath
#$gitclonescriptwithpath
#
set -e
set -x
GithubRepoOwner="apor-tv2"
#GithubRepoOwner="tv2"
GithubRepoName="infrastructure-SCPs"
repo="${GithubRepoOwner}_${GithubRepoName}"

ParamString=$(aws ssm get-parameter --name "/AFT-CICD/Github/$repo/KeyPairReadOnly" || echo "NA")

if [ "$ParamString" = "NA" ] ; then
#if true ; then
	echo "Generate Key";
	#keyname="id_ed25519_github_${repo}"
	#rm -f $keyname
	#rm -f $keyname.pub
	#ssh-keygen -t ed25519 -f $keyname -q -N ""

	keyname="id_rsa_github_${repo}"
	rm -f $keyname
	rm -f $keyname.pub
	ssh-keygen -t rsa -b 1024 -f $keyname -q -N ""
	paramValue="{ \"PrivateKeyName\":\"$keyname\", \"PrivateKeyValue\":\"$(cat $keyname | base64 -w0)\", \"PublicKeyName\":\"${keyname}.pub\", \"PublicKeyValue\":\"$(cat $keyname.pub | base64 -w0)\" }"
	#paramValue="{ \"PrivateKeyName\":\"$keyname\", \"PrivateKeyValue\":\"$(cat $keyname)\", \"PrivateKeyPassword\":\"$pw\", \"PublicKeyName\":\"${keyname}.pub\", \"PublicKeyValue\":\"$(cat $keyname.pub)\" }"
	echo $paramValue > paramValue.json
	paramValueBase64=$(echo $paramValue | base64 -w0) 
	
	aws ssm put-parameter \
		--overwrite \
		--type "SecureString" \
		--name "/AFT-CICD/Github/$repo/KeyPairReadOnly" \
		--value "$paramValueBase64"

#	aws ssm put-parameter \
#		--type "SecureString" \
#		--name "/AFT-CICD/Github/$repo/ReadOnly/PrivateKeyName" \
#		--value "$keyname"
#	aws ssm put-parameter \
#		--type "SecureString" \
#		--name "/AFT-CICD/Github/$repo/ReadOnly/PrivateKeyValue" \
#		--value "$(cat $keyname)"
#	aws ssm put-parameter \
#		--type "SecureString" \
#		--name "/AFT-CICD/Github/$repo/ReadOnly/PrivateKeyPassword" \
#		--value "$pw"
#	aws ssm put-parameter \
#		--type "SecureString" \
#		--name "/AFT-CICD/Github/$repo/ReadOnly/PublicKeyName" \
#		--value "${keyname}.pub"
#	aws ssm put-parameter \
#		--type "SecureString" \
#		--name "/AFT-CICD/Github/$repo/ReadOnly/PublicKeyValue" \
#		--value "$(cat ${keyname}.pub)"
else
	echo "Key already generated";
fi
# Configure Development SSH Key
ssh_key_parameter=$(aws ssm get-parameter --name "/AFT-CICD/Github/$repo/KeyPairReadOnly" --with-decryption 2> /dev/null || echo "None")

if [[ "$ssh_key_parameter" != "None" ]]; then
  #echo $ssh_key_parameter > parameter.json
  #cat parameter.json | jq ".Parameter.Value"  | xargs echo | base64 -d | jq ".PrivateKeyNam
  params=$(echo $ssh_key_parameter | jq ".Parameter.Value"  | xargs echo | base64 -d)
  PrivateKeyName=$(echo $params | jq ".PrivateKeyName" | sed 's:"::g')
  echo $PrivateKeyName
  PrivateKeyValue=$(echo $params | jq ".PrivateKeyValue" | sed 's:"::g' | base64 -d)
  echo $PrivateKeyValue
  #PrivateKeyPassword=$(echo $params | jq ".PrivateKeyPassword" | sed 's:"::g')
  #echo $PrivateKeyPassword
  PublicKeyName=$(echo $params | jq ".PublicKeyName" | sed 's:"::g')
  echo $PublicKeyName
  PublicKeyValue=$(echo $params | jq ".PublicKeyValue" | sed 's:"::g' | base64 -d)
  echo $PublicKeyValue

  # .ssh already exist in container
  #mkdir -p ~/.ssh
  #chmod 700 ~/.ssh
  #echo "Host *.github.com github.com" >> ~/.ssh/config
#  echo -e "\n\n" >>  ~/.ssh/config
#  echo "Host github.com" >> ~/.ssh/config
  echo "  StrictHostKeyChecking no" >> ~/.ssh/config
  echo "  UserKnownHostsFile=/dev/null" >> ~/.ssh/config
  echo "$PrivateKeyValue" > ~/.ssh/$PrivateKeyName
  echo -e "\n\n" >>  ~/.ssh/$PrivateKeyName
  chmod 600 ~/.ssh/$PrivateKeyName
  cat ~/.ssh/config
  eval "$(ssh-agent -s)"
  uname -a
  whoami
  #apt-get install expect
  cat ~/.ssh/$PrivateKeyName
  ssh-add -v ~/.ssh/$PrivateKeyName
  echo "add deploy key to github repo: $repo"
  ssh-add -L
fi



















#  echo "pwd"
#  pwd
#  
#  # Configure Development SSH Key
#  ssh_key_parameter=$(aws ssm get-parameter --name /aft/config/aft-ssh-key --with-decryption 2> /dev/null || echo "None")
#  
#  echo "ssh_key_parameter $ssh_key_parameter"
#  
#  echo "aws codestar-connections list-connections:"
#  aws codestar-connections list-connections
#  
#  CodestarConnectionArn=$(aws codestar-connections list-connections --query 'Connections[?ConnectionName==`tv2-infrastructure-SCPs`].ConnectionArn' --output text)
#  echo "CodestarConnectionArn: >$CodestarConnectionArn<"
#  if [ -z "$CodestarConnectionArn" ] ; then
#  	echo "CodestarConnectionArn not found"
#  	exit 1;
#  fi
#  
#  CodestarConnectionArnID=$(echo $CodestarConnectionArn | sed -e 's:.*/::')
#  echo "CodestarConnectionArnID: $CodestarConnectionArnID"
#  AccountID=$(aws sts get-caller-identity --query "Account" --output text)
#  echo "AccountID: $AccountID"
#  GithubRepo="tv2/infrastructure-SCPs"
#  echo "git config --global credential.helper '!aws codecommit credential-helper $@'"
#  git config --global credential.helper '!aws codecommit credential-helper $@'
#  echo "git config --global credential.UseHttpPath true"
#  git config --global credential.UseHttpPath true
#  find $DEFAULT_PATH/$CUSTOMIZATION
#  echo "DEFAULT_PATH $DEFAULT_PATH"
#  echo "VENDED_ACCOUNT_ID $VENDED_ACCOUNT_ID"
#  echo "CUSTOMIZATION $CUSTOMIZATION"
#  echo "DEFAULT_PATH $DEFAULT_PATH"
#  echo "TIMESTAMP $TIMESTAMP"
#  echo "TF_VERSION $TF_VERSION"
#  echo "TF_DISTRIBUTION $TF_DISTRIBUTION"
#  echo "CT_MGMT_REGION $CT_MGMT_REGION"
#  echo "AFT_MGMT_ACCOUNT $AFT_MGMT_ACCOUNT"
#  echo "AFT_EXEC_ROLE_ARN $AFT_EXEC_ROLE_ARN"
#  echo "VENDED_EXEC_ROLE_ARN $VENDED_EXEC_ROLE_ARN"
#  echo "AFT_ADMIN_ROLE_NAME $AFT_ADMIN_ROLE_NAME"
#  echo "AFT_ADMIN_ROLE_ARN $AFT_ADMIN_ROLE_ARN"
#  echo "ROLE_SESSION_NAME $ROLE_SESSION_NAME"
#  
#  CodestarGithubInfrastructureSCPsSource="https://codestar-connections.$AWS_REGION.amazonaws.com/git-http/$AccountID/$AWS_REGION/$CodestarConnectionArnID/$GithubRepo.git"
#  #echo "git clone --quiet -b https://codestar-connections.$AWS_REGION.amazonaws.com/git-http/$AccountID/$AWS_REGION/$CodestarConnectionArnID/$GithubRepo.git $DEFAULT_PATH/$CUSTOMIZATION/terraform/modules/infrastructure-SCPs"
#  #git clone --quiet -b https://codestar-connections.$AWS_REGION.amazonaws.com/git-http/$AccountID/$AWS_REGION/$CodestarConnectionArnID/$GithubRepo.git $DEFAULT_PATH/$CUSTOMIZATION/terraform/modules/infrastructure-SCPs
#  #echo git clone --quiet -b $CodestarGithubInfrastructureSCPsSource $DEFAULT_PATH/$CUSTOMIZATION/terraform/modules/
#  cd $DEFAULT_PATH/$CUSTOMIZATION/terraform/modules/
#  echo git clone $CodestarGithubInfrastructureSCPsSource
#  git clone $CodestarGithubInfrastructureSCPsSource
#  cd -
#  find $DEFAULT_PATH/$CUSTOMIZATION/terraform/modules/ -type f -name "*.tf"
#  
#  #export TF_VAR_CodestarGithubInfrastructureSCPsSource="https://codestar-connections.$AWS_REGION.amazonaws.com/git-http/$AccountID/$AWS_REGION/$CodestarConnectionArnID/$GithubRepo.git"
#  #echo "TF_VAR_CodestarGithubInfrastructureSCPsSource: $TF_VAR_CodestarGithubInfrastructureSCPsSource"
#  #tee $DEFAULT_PATH/$CUSTOMIZATION/terraform/Injected_CodestarGithubInfrastructureSCPsSource.tf <<-INJECT_CODESTAR_CONNECTION_INFO
#  ## Values injected from pre-api-helpers.sh
#  #variable "CodestarGithubInfrastructureSCPsSource" {
#  #	type = string
#  #	default = "https://codestar-connections.$AWS_REGION.amazonaws.com/git-http/$AccountID/$AWS_REGION/$CodestarConnectionArnID/$GithubRepo.git"
#  #	description = "Codestar Connection to checkout module source, will be set by pre-api-helper    s.sh in AFT account customization pipeline"
#  #}
#  #INJECT_CODESTAR_CONNECTION_INFO 
#  
#  #cat <<-INJECT_CODESTAR_CONNECTION_INFO > $DEFAULT_PATH/$CUSTOMIZATION/terraform/Injected_CodestarGithubInfrastructureSCPsSource.tf
#  ## Values injected from pre-api-helpers.sh
#  #variable "CodestarGithubInfrastructureSCPsSource" {
#  #	type = string
#  #	default = "https://codestar-connections.$AWS_REGION.amazonaws.com/git-http/$AccountID/$AWS_REGION/$CodestarConnectionArnID/$GithubRepo.git"
#  #	description = "Codestar Connection to checkout module source, will be set by pre-api-helper    s.sh in AFT account customization pipeline"
#  #}
#  #INJECT_CODESTAR_CONNECTION_INFO 
#  
#  #find $DEFAULT_PATH/$CUSTOMIZATION/ -type f -name "*.tf" -exec sed -i "s:REPLACECodestarGithubInfrastructureSCPsSourceREPLACE:$CodestarGithubInfrastructureSCPsSource:" {} \;
