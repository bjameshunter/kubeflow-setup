#!/bin/bash

export BUCKET_NAME=management-kubeflow-bjh
export PROJECT_ID=kubeflow-tutorial-328115
export ADMIN_EMAIL=bjameshunter@gmail.com
export MGMT_PROJECT=$PROJECT_ID
export MGMTCTXT=management
export MGMT_NAME=management
export MGMT_DIR=$PWD/management
export ZONE=us-central1-a
export LOCATION=$ZONE
export K8S_VERSION=1.20
# required, but should be defined elsewhere
if [[ -z "${KUBECONFIG}" ]]; then
    echo "KUBECONFIG env var is required"
    exit 1
fi
if [[ -z "${KUBE_GITHUB_TOKEN}" ]]; then
    echo "KUBE_GITHUB_TOKEN env var is required"
    exit 1
fi
if [[ -z "${CLIENT_ID}" ]]; then
    echo "CLIENT_ID env var is required"
    exit 1
fi
if [[ -z "${CLIENT_SECRET}" ]]; then
    echo "CLIENT_SECRET env var is required"
    exit 1
fi


