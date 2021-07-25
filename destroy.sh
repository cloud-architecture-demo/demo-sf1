#! /bin/bash

SECONDS=0

cd ./eks

## Attempt to destroy cloud infrastructure managed by Terraform.
## If a failure occurs, due to a cloud provider api race time condition, attempt to destroy once more.
TERRAFORM_DESTROY='terraform destroy -auto-approve -var-file secrets.tfvars -lock=false'
${TERRAFORM_DESTROY}

echo "Script Runtime:  $(($SECONDS / 3600))h:$((($SECONDS / 60) % 60))m:$(($SECONDS % 60))s"
echo ""
echo "end"