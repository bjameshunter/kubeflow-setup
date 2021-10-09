#!/bin/bash

# see https://www.kubeflow.org/docs/distributions/gke/ for more detail
source env.sh
source kubeflow/env.sh

cd management
bash kpt-set.sh

make apply-cluster
make create-context
make apply-kcc

cd ../kubeflow
bash kpt-set.sh
kubectl config use-context "${MGMTCTXT}"
kubectl create namespace "${KF_PROJECT}"

pushd "../management"
kpt cfg set -R . name "${MGMT_NAME}"
kpt cfg set -R . gcloud.core.project "${MGMT_PROJECT}"
kpt cfg set -R . managed-project "${KF_PROJECT}"

gcloud beta anthos apply ./managed-project/iam.yaml

popd

gcloud container clusters get-credentials \
    "${KF_NAME}" \
    --zone "${ZONE}" \
    --project "${KF_PROJECT}"

gcloud projects add-iam-policy-binding ${KF_PROJECT} \
    --member=user:$ADMIN_EMAIL \
    --role=roles/iap.httpsResourceAccessor

