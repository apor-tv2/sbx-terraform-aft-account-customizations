#!/bin/bash 
#echo "Executing Pre-API Helpers"

# gitclonewithcodestar=$(find . -name "git-checkout-with-codestar.sh")
# chmod u+x $gitclonewithcodestar
# $gitclonewithcodestar
# 
# #chmod u+x  get_git_url_through_coddestar.sh
# #./get_git_url_through_coddestar.sh
# exit 0


gitclonescriptwithpath=$(find . -name "git_clone_with_deploy_key.sh")
chmod u+x $gitclonescriptwithpath
$gitclonescriptwithpath
