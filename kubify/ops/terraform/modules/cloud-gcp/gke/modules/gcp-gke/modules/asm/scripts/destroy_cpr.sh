#!/usr/bin/env bash

set -e

if [ "$#" -lt 1 ]; then
    >&2 echo "Not all expected arguments set."
    exit 1
fi

REVISION_NAME=$1; shift

if ! kubectl delete controlplanerevision -n istio-system "${REVISION_NAME}" ; then
  echo "ControlPlaneRevision ${REVISION_NAME} not found"
fi
