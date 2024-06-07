# this script works best if sourced
# call it:
# source trigger_stepfunction.sh
# . trigger_stepfunction.sh
# login to aft account with awsume
statemachineArn=$(aws stepfunctions list-state-machines --query 'stateMachines[?name==`aft-invoke-customizations`].stateMachineArn' --output text)
echo "statemachineArn: $statemachineArn"
aws stepfunctions start-execution --input '{"include":[{"type":"accounts","target_value":["090836393813"]}]}' --state-machine-arn $statemachineArn || echo "maybe run sso login" ; echo "aws sso login--no-browser --profile tv2-apor-sbx-aft-Admin\n# and \nawsume tv2-apor-sbx-aft-Admin"
echo -n "Do you want to authenticate with aws and asume the Admin role in aft account? [yN] "
read answer
if [[ "$answer" =~ ^[y]$ ]]
then
  aws sso login --no-browser --profile tv2-apor-sbx-aft-Admin
  source awsume tv2-apor-sbx-aft-Admin
fi
awswhoami
#aws --profile tv2-apor-sbx-aft-Admin stepfunctions start-execution --input '{"include":[{"type":"accounts","target_value":["090836393813"]}]}' --state-machine-arn arn:aws:states:eu-central-1:352190605276:stateMachine:aft-invoke-customizations || echo "maybe run sso login" ; echo "aws sso login --profile tv2-apor-sbx-Admin"
