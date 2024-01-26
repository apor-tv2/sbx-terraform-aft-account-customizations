#!/bin/bash
exit 0
AFTStackName="SBX-AFT"
GithubRepo="apor-tv2/infrastructure-SCPs"
#ConnectionName=$(echo ${GithubRepo}_${AFTStackName})
ConnectionName="apor-tv2/infra-SCPs from SBX-AFT"

#AFTStackName="DEMO-AFT"
#GithubRepo="tv2/infrastructure-SCPs"
#ConnectionName=$(echo ${GithubRepo}_${AFTStackName})

#AFTStackName="MAIN-AFT"
#GithubRepo="tv2/infrastructure-SCPs"
#ConnectionName=$(echo ${GithubRepo}_${AFTStackName})

AccountID=$(aws sts get-caller-identity --query "Account" --output text)
CodestarConnectionArn=$(aws codestar-connections list-connections --query 'Connections[?ConnectionName==`'$ConnectionName'`].ConnectionArn' --output text)
echo "CodestarConnectionArn: $CodestarConnectionArn"
CodestarConnectionArnID=$(echo $CodestarConnectionArn | sed -e 's:.*/::')
echo "https://codestar-connections.$AWS_REGION.amazonaws.com/git-http/$AccountID/$AWS_REGION/$CodestarConnectionArnID/$GithubRepo.git"
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
git clone https://codestar-connections.$AWS_REGION.amazonaws.com/git-http/$AccountID/$AWS_REGION/$CodestarConnectionArnID/$GithubRepo.git /tmp/testClone
