#CodestarConnectionArn=$(aws codestar-connections list-connections --query "Connections[0].ConnectionArn" --output text)
#CodestarConnectionArn=$(aws codestar-connections list-connections --query 'Connections[?ConnectionName==`aportv2-infrastructure-SCPs`].ConnectionArn' --output text)
CodestarConnectionArn=$(aws codestar-connections list-connections --query 'Connections[?ConnectionName==`tv2-infrastructure-SCPs`].ConnectionArn' --output text)
echo "CodestarConnectionArn: >$CodestarConnectionArn<"
if [ -z "$CodestarConnectionArn" ] ; then
	echo "CodestarConnectionArn not found"
	exit 1;
fi
CodestarConnectionArnID=$(echo $CodestarConnectionArn | sed -e 's:.*/::')

AccountID=$(aws sts get-caller-identity --query "Account" --output text)

#GithubRepo="apor-tv2/infrastructure-SCPs"
GithubRepo="tv2/infrastructure-SCPs"

find . -type d -name "*/modules"
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
echo git clone https://codestar-connections.$AWS_REGION.amazonaws.com/git-http/$AccountID/$AWS_REGION/$CodestarConnectionArnID/$GithubRepo.git
git clone https://codestar-connections.$AWS_REGION.amazonaws.com/git-http/$AccountID/$AWS_REGION/$CodestarConnectionArnID/$GithubRepo.git terraform/modules/infrastructure-SCPs
pwd

#❯ aws codestar-connections list-connections
#{
#    "Connections": [
#        {
#            "ConnectionName": "aportv2-infrastructure-SCPs",
#            "ConnectionArn": "arn:aws:codestar-connections:eu-central-1:090836393813:connection/42311cd6-9ee2-4f28-a572-4fdc1fbe719d",
#            "ProviderType": "GitHub",
#            "OwnerAccountId": "090836393813",
#            "ConnectionStatus": "AVAILABLE"
#        }
#    ]
#}

# from aft-account-customizations-terraform.yml
## Clone AFT
#AWS_MODULE_SOURCE=$(aws ssm get-parameter --name "/aft/config/aft-pipeline-code-source/repo-url    " --query "Parameter.Value" --output text)
#AWS_MODULE_GIT_REF=$(aws ssm get-parameter --name "/aft/config/aft-pipeline-code-source/repo-gi
#uery "Parameter.Value" --output text)
#git config --global credential.helper '!aws codecommit credential-helper $@'
#git config --global credential.UseHttpPath true
#git clone --quiet -b $AWS_MODULE_GIT_REF $AWS_MODULE_SOURCE aws-aft-core-framework
