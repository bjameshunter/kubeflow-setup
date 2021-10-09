#!/bin/bash

# see https://www.kubeflow.org/docs/distributions/gke/ for more detail
. env.sh
. kubeflow/env.sh

cd management
# . kpt-set.sh

# make apply-cluster
# make create-context
# make apply-kcc

gcloud container clusters get-credentials "${MGMT_NAME}" --zone "${ZONE}" --project "${PROJECT_ID}"
kubectl config delete-context $MGMT_NAME
kubectl config rename-context $(kubectl config current-context) $MGMT_NAME
cd ../kubeflow
. kpt-set.sh
kubectl config use-context "${MGMTCTXT}"
kubectl create namespace "${PROJECT_ID}" --dry-run=client -o yaml | kubectl apply -f -

pushd "../management"
kpt cfg set -R . name "${MGMT_NAME}"
kpt cfg set -R . gcloud.core.project "${PROJECT_ID}"
kpt cfg set -R . managed-project "${PROJECT_ID}"

gcloud beta anthos apply ./managed-project/iam.yaml

popd

gcloud container clusters get-credentials \
    "${KF_NAME}" \
    --zone "${ZONE}" \
    --project "${PROJECT_ID}"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=user:$ADMIN_EMAIL \
    --role=roles/iap.httpsResourceAccessor

make apply

kubectl config delete-context $KF_NAME
gcloud container clusters get-credentials "${KF_NAME}" --zone "${ZONE}" --project "${PROJECT_ID}"
kubectl config rename-context $(kubectl config current-context) $KF_NAME
