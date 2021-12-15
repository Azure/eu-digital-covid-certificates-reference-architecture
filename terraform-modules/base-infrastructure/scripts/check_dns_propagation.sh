#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -euo pipefail

iterations=0
check_propagation() {
    FQDN="${1}"
    IP_ADDRESS="${2}"
    max_iterations="${3}"
    wait_seconds="${4}"
    sleep 60

    while true; do
        iterations=$((iterations + 1))
        echo "Polling FQDN [${FQDN}] for Private IP [${IP_ADDRESS}] - Attempt $iterations"
        sleep $wait_seconds

        diggResp=$(dig +short ${FQDN})
        echo "dig Response: ${diggResp}"
        # If the DNS Lookup of the FQDN returns equal to private ip address then return.
        if [ "${diggResp}" == "${IP_ADDRESS}" ]; then
            echo "Found FQDN [${FQDN}] with new Private IP [${IP_ADDRESS}]"
            break
        fi

        if [ "${iterations}" -ge "${max_iterations}" ]; then
            echo "Loop Timeout - finding Private IP [${IP_ADDRESS}] found in FQDN [${FQDN}]"
            exit 1
        fi
    done
}

check_propagation $1 $2 $3 $4
