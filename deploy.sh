#! /bin/bash

cd ./eks

#AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
terraform init
terraform plan -var-file secrets.tfvars
terraform apply -auto-approve -var-file secrets.tfvars

KUBECONFIG=./kubeconfig-tf
KUBECONFIG_BASE64=$(cat "${KUBECONFIG}" | base64 | tr -d '\n')

kubectl apply -f ../apps/jenkins-seed-jobs/socks-shop/front-end/deploy/kubernetes/front-end-svc.yaml

JENKINS_PASSWORD=$(kubectl get secret jenkins-operator-credentials-prod-jenkins -o 'jsonpath={.data.password}' | base64 -d)
JENKINS_SERVER_URL=$(kubectl -n ingress-nginx get svc ingress-nginx-controller | awk -F ' ' '{ print $4 }' | tail -1)
WEB_APP_URL=$(kubectl -n sock-shop get svc front-end | awk -F ' ' '{ print $4 }' | tail -1)
WEB_APP_URL_CHECK=$(echo $WEB_APP_URL | grep -o '.elb.amazonaws.com')
while [ "${WEB_APP_URL_CHECK}" != ".elb.amazonaws.com" ];
do
  echo "Checking service..."
  WEB_APP_URL=$(kubectl -n sock-shop get svc front-end | awk -F ' ' '{ print $4 }' | tail -1)
  WEB_APP_URL_CHECK=$(echo $WEB_APP_URL | grep -o '.elb.amazonaws.com')

  sleep 5
done

echo ""
echo "------------------------------------------------------------------"
echo ""
echo "    Base64 encoded kubeconfig:"
echo ""
echo "    ${KUBECONFIG_BASE64}"
echo ""
echo "------------------------------------------------------------------"
echo ""
echo "    JENKINS_SERVER_URL: ${JENKINS_SERVER_URL}/jenkins/"
echo "    JENKINS_USERNAME: jenkins-operator"
echo "    JENKINS_PASSWORD: ${JENKINS_PASSWORD}"
echo ""
echo "    Socks Shop Web App URL: ${WEB_APP_URL}"
echo ""
echo "------------------------------------------------------------------"
echo ""