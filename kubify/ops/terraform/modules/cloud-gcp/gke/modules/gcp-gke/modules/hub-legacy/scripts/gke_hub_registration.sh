#!/usr/bin/env bash


set -e

if [ "$#" -lt 5 ]; then
    >&2 echo "Not all expected arguments set."
    exit 1
fi

GKE_CLUSTER_FLAG=$1
MEMBERSHIP_NAME=$2
SERVICE_ACCOUNT_KEY=$3
CLUSTER_URI=$4
HUB_PROJECT_ID=$5
LABELS=$6

#write temp key, cleanup at exit
tmp_file=$(mktemp)
# shellcheck disable=SC2064
trap "rm -rf $tmp_file" EXIT
base64 --help | grep "\--decode" && B64_ARG="--decode" || B64_ARG="-d"
echo "${SERVICE_ACCOUNT_KEY}" | base64 ${B64_ARG} > "$tmp_file"

if [[ ${GKE_CLUSTER_FLAG} == 1 ]]; then
    echo "Registering GKE Cluster."
    gcloud container hub memberships register "${MEMBERSHIP_NAME}" --gke-uri="${CLUSTER_URI}" --service-account-key-file="${tmp_file}" --project="${HUB_PROJECT_ID}" --quiet
else
    echo "Registering a non-GKE Cluster. Using current-context to register Hub membership."
    #Get the kubeconfig
    CONTEXT=$(kubectl config current-context)
    gcloud container hub memberships register "${MEMBERSHIP_NAME}" --context="${CONTEXT}" --service-account-key-file="${tmp_file}" --project="${HUB_PROJECT_ID}" --quiet
fi


# Add labels to the registered cluster
if [ -z ${LABELS+x} ]; then
    echo "No hub labels to apply."
else
    gcloud container hub memberships update "${MEMBERSHIP_NAME}" --update-labels "$LABELS" --project="${HUB_PROJECT_ID}"
fi
