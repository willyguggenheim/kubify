#!/usr/bin/env bash
set -e



kubectl --kubeconfig=/var/lib/kubelet/kubeconfig drain --force=true --ignore-daemonsets=true --delete-local-data "$HOSTNAME"
