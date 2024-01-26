#!/bin/bash
CodestarConnectionArn=$(aws codestar-connections list-connections --query 'Connections[?ConnectionName==`tv2-infrastructure-SCPs`].ConnectionArn' --output text)
echo "CodestarConnectionArn: >$CodestarConnectionArn<"
echo "insert this into the module source manually and commit"
#git config --global credential.helper '!aws codecommit credential-helper $@'
#git config --global credential.UseHttpPath true
#git clone https://codestar-connections.$AWS_REGION.amazonaws.com/git-http/$AccountID/$AWS_REGION/$CodestarConnectionArnID/$GithubRepo.git
#
