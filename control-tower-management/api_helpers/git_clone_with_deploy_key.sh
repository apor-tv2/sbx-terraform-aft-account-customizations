#!/bin/bash 
set -e
set -x
GithubRepoOwner="tv2"
GithubRepoName="infrastructure-SCPs"
repo="${GithubRepoOwner}_${GithubRepoName}"

ParamString=$(aws ssm get-parameter --name "/AFT-CICD/Github/$repo/KeyPairReadOnly" || echo "NA")

if [ "$ParamString" = "NA" ] ; then
	echo "Generate Key";
	keyname="id_ed25519_github_${repo}"
	rm -f id_ed25519_github_${repo}
	rm -f id_ed25519_github_${repo}.pub
	ssh-keygen -t ed25519 -f id_ed25519_github_${repo} -q -N ""
	paramValue="{ \"PrivateKeyName\":\"$keyname\", \"PrivateKeyValue\":\"$(cat $keyname | base64 -w0)\", \"PublicKeyName\":\"${keyname}.pub\", \"PublicKeyValue\":\"$(cat $keyname.pub | base64 -w0)\" }"
	paramValueBase64=$(echo $paramValue | base64 -w0) 
	
	aws ssm put-parameter \
		--overwrite \
		--type "SecureString" \
		--name "/AFT-CICD/Github/$repo/KeyPairReadOnly" \
		--value "$paramValueBase64"

echo """
No DeployKey was found in SSM:
 - either update the SSM parameter (secure string) /AFT-CICD/Github/$repo/KeyPairReadOnly to an existing deploy key.
 - or use the deploy key that has just been generated. This will require you to add it in the github repo $repo
"""
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
  #echo $PrivateKeyName
  PrivateKeyValue=$(echo $params | jq ".PrivateKeyValue" | sed 's:"::g' | base64 -d)
  #echo $PrivateKeyValue
  PublicKeyName=$(echo $params | jq ".PublicKeyName" | sed 's:"::g')
  #echo $PublicKeyName
  PublicKeyValue=$(echo $params | jq ".PublicKeyValue" | sed 's:"::g' | base64 -d)
  #echo $PublicKeyValue

  # .ssh already exist in container
  #mkdir -p ~/.ssh
  #chmod 700 ~/.ssh
  #echo "Host *.github.com github.com" >> ~/.ssh/config

  if [ -f ~/.ssh/config ] ; then
    echo -e "\n\n" >>  ~/.ssh/config
  else
    touch ~/.ssh/config
  fi
  if [ $(grep -cE "^Host github.com" ~/.ssh/config) -eq 0 ] ; then
    # adding Host config to ssh, for github
    echo "Host github.com" >> ~/.ssh/config
    echo "  StrictHostKeyChecking no" >> ~/.ssh/config
    echo "  UserKnownHostsFile=/dev/null" >> ~/.ssh/config
    echo "  IdentityFile=~/.ssh/$PrivateKeyName" >> ~/.ssh/config
  fi
  echo "$PrivateKeyValue" > ~/.ssh/$PrivateKeyName
  chmod 600 ~/.ssh/$PrivateKeyName
  echo "$PublicKeyName" > ~/.ssh/$PublicKeyValue
  chmod 600 ~/.ssh/$PublicKeyName
  eval "$(ssh-agent -s)"
  #ssh-add -v ~/.ssh/$PrivateKeyName
  #ssh-add -L
fi

echo "success"
