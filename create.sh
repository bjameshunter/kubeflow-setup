#!/bin/bash

# see https://www.kubeflow.org/docs/distributions/gke/ for more detail
source env.sh

cd management
bash kpt-set.sh

make apply-cluster
make create-context
make apply-kcc

cd ../kubeflow
source env.sh
bash kpt-set.sh
kubectl config use-context "${MGMTCTXT}"
kubectl create namespace "${PROJECT_ID}"

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
