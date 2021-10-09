# 1. Edit <placeholders>.
# 2. Other env vars are configurable, but with default values set below.
if [[ "$KF_SUFFIX" = "" ]]; then
    export KF_SUFFIX=$(tr -dc a-z0-9 </dev/urandom | head -c 4 ; echo '')
fi
# The KF_PROJECT env var contains the Google Cloud project ID where Kubeflow
# cluster will be deployed to.

export KF_PROJECT=$PROJECT_ID
# You can get your project number by running this command
# (replace ${KF_PROJECT} with the actual project ID):
# gcloud projects describe --format='value(projectNumber)' "${KF_PROJECT}"
export KF_PROJECT_NUMBER=$(gcloud projects describe --format='value(projectNumber)' "$PROJECT_ID")
######################
# NOTICE: The following env vars have default values, but they are also configurable.

######################

# KF_NAME env var is name of your new Kubeflow cluster.
# It should satisfy the following prerequisites:
# * be unique within your project, e.g. if you already deployed cluster with the
# name "kubeflow", use a different name when deploying another Kubeflow cluster.
# * start with a lowercase letter
# * only contain lowercase letters, numbers and "-"s (hyphens)
# * end with a number or a letter
# * contain no more than 24 characters
export KF_NAME=kubeflow-$KF_SUFFIX
# Default values for managed storage used by Kubeflow Pipelines (KFP), you can
# override as you like.
# The CloudSQL instance and Cloud Storage bucket instance are created during
# deployment, so you should make sure their names are not used before.
export CLOUDSQL_NAME=${KF_NAME}
# Note, Cloud Storage bucket name needs to be globally unique across projects.
# So we default to a name related to ${KF_PROJECT}.
export BUCKET_NAME="${KF_NAME}"
# LOCATION can either be a zone or a region, that determines whether the deployed
# Kubeflow cluster is a zonal cluster or a regional cluster.
# Specify LOCATION as a region like the following line to create a regional Kubeflow cluster.
# export LOCATION=us-central1
export LOCATION=us-central1-a
# REGION should match the region part of LOCATION.
export REGION=us-central1
# Preferred zone of Cloud SQL. Note, ZONE should be in REGION.
export ZONE=$LOCATION
# Anthos Service Mesh version label
export ASM_LABEL=asm-193-2
