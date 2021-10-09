#!/bin/bash

gcloud config set project ${PROJECT_ID}
gcloud config set compute/zone ${ZONE}


# gcloud components install kubectl kpt anthoscli beta
# gcloud components update
# curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

## MGMT
# # Add the kustomize package to your $PATH env variable
# sudo mv ./kustomize /usr/local/bin/kustomize

gcloud container clusters get-credentials "${MGMT_NAME}" --zone "${ZONE}" --project "${PROJECT_ID}"
kubectl config delete-context $MGMT_NAME
kubectl config rename-context $(kubectl config current-context) $MGMT_NAME
kubectl config delete-context $KF_NAME
# gcloud container clusters get-credentials "${KF_NAME}" --zone "${ZONE}" --project "${PROJECT_ID}"
# kubectl config rename-context $(kubectl config current-context) $KF_PROJECT


## for later
