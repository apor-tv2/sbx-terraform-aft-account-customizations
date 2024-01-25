#!/bin/bash 
set -e
set -v
GithubRepoOwner="apor-tv2"
#GithubRepoOwner="tv2"
GithubRepoName="infrastructure-SCPs"
repo="${GithubRepoOwner}_${GithubRepoName}"

ParamString=$(aws ssm get-parameter --name "/AFT-CICD/Github/$repo/KeyPairReadOnly" || echo "NA")

if [ "$ParamString" = "NA" ] ; then
#if true ; then
	echo "Generate Key";
	#pw=$(pwgen 20 1)
	#echo $pw > tmppw
	keyname="id_ed25519_github_${repo}"
	rm -f id_ed25519_github_${repo}
	rm -f id_ed25519_github_${repo}.pub
	#ssh-keygen -t ed25519 -f id_ed25519_github_${repo} -q -N "$pw"
	ssh-keygen -t ed25519 -f id_ed25519_github_${repo} -q -N ""
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
  echo -e "\n\n" >>  ~/.ssh/config
  echo "Host github.com" >> ~/.ssh/config
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

echo "success"
