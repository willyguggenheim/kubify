#!/bin/bash


set -e

if [ "$#" -lt 4 ]; then
    >&2 echo "Not all expected arguments set."
    exit 1
fi

GKE_CLUSTER_FLAG=$1
MEMBERSHIP_NAME=$2
CLUSTER_URI=$3
HUB_PROJECT_ID=$4

if [[ ${GKE_CLUSTER_FLAG} == 1 ]]; then
    echo "Un-Registering GKE Cluster."
    gcloud container hub memberships unregister "${MEMBERSHIP_NAME}" --gke-uri="${CLUSTER_URI}" --project "${HUB_PROJECT_ID}"
else
    echo "Un-Registering a non-GKE Cluster. Using current-context to unregister Hub membership."
    #Get Current context
    CONTEXT=$(kubectl config current-context)
    gcloud container hub memberships unregister "${MEMBERSHIP_NAME}" --context="${CONTEXT}" --project="${HUB_PROJECT_ID}"
fi
