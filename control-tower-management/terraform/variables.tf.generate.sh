#/bin/bash
aft_env="sbx"
outfile="variables.tf.generated"
echo """
# This file may initially be generated with variables.tf.generate.sh that will produce variables.tf.generated

# SCP targets - i.e. the OUs in our AWS Organization
variable "ou_targets" {
  type = map(any)
  default = { """ > $outfile
# awsume Rootaccount-RO
rootID=$(aws organizations list-roots --query "Roots[0].Id" --output text)
echo "rootID: $rootID"
aws organizations list-children --parent-id $rootID --child-type ORGANIZATIONAL_UNIT --output text | col2 | while read ouinfo; do
  echo "ouinfo: $ouinfo"
  ou_name_id=$(aws organizations describe-organizational-unit --organizational-unit-id $ouinfo --query "OrganizationalUnit.[Name,Id]" --output text)
  echo $ou_name_id | sed 's/\s\+/" = "/;s/^/    "/;s/$/",/' | sed "s/\"/\"$aft_env_/" >> $outfile
done
echo "  }" >> $outfile
echo "}" >> $outfile
