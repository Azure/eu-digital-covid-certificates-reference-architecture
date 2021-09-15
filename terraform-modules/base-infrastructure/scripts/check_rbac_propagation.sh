#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -euo pipefail

max_iterations=$MAX_ITERATIONS
wait_seconds=$WAIT_SECONDS
iterations=0

check_propagation() {
    while true; do
        iterations=$((iterations + 1))
        echo "Polling Scope [id=${SCOPE}] for role with Principal [id=${PRINCIPAL_ID}] - Attempt $iterations"
        sleep $wait_seconds

        # Use check Json of role assignments of the scope to see if contains the Resources managed identity, if present role is propagated.
        scopeJson=$(az role assignment list --scope ${SCOPE} -o json | jq --arg v "$PRINCIPAL_ID" '.[] | select(.principalId | contains($v))  | any ')
        if [ "${scopeJson}" = true ]; then
            echo "Found Role with Principal [id=${PRINCIPAL_ID}] found in Scope [id=${SCOPE}]"
            break
        fi

        if [ "$iterations" -ge "$max_iterations" ]; then
            echo "Loop Timeout - finding Role with Principal [id=${PRINCIPAL_ID}] found in Scope [id=${SCOPE}]"
            exit 1
        fi
    done
}

check_propagation
