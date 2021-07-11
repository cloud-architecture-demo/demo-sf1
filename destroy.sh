#! /bin/bash

cd ./eks

terraform destroy -auto-approve -var-file secrets.tfvars .