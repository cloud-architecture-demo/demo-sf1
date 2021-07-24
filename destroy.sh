#! /bin/bash

SECONDS=0

cd ./eks

terraform destroy -auto-approve -var-file secrets.tfvars -lock=false

terraform destroy -auto-approve -var-file secrets.tfvars -lock=false

echo "Script Runtime:  $(($SECONDS / 3600))h:$((($SECONDS / 60) % 60))m:$(($SECONDS % 60))s"
echo ""
echo "end"