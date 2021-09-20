#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -euo pipefail

# Check if required commands are installed.
if ! command -v "javac" &> /dev/null
then
    echo "Java JDK required to run dgc-cli for signing - please install on machine."
    exit 1
fi
if ! command -v "jq" &> /dev/null
then
    echo "jq required - please install on machine."
    exit 1
fi

ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# get Current Date in ISO format and add 49 hours to aling with the Gateway rules of needing to be greater then 48 hours
if [ "$(uname)" == "Darwin" ]; then
    # Mac OS X
    date=$(gdate -d "+49 hours" -u "+%Y-%m-%dT%H:%M:%SZ")
elif [ "$(expr substr "$(uname -s)" 1 5)" == "Linux" ]; then
# Linux / Windows WSL
    date=$(date -d "+49 hours" -u "+%Y-%m-%dT%H:%M:%SZ")
fi

# Required Absolute file Path for dgc-cli to read the Keys.
pushd "${CERTS_DIR}"
CERTS_DIR_FULL_PATH="$(pwd)"
popd

upsert_ruleset() {
    # Clean any previous changes to the repo
    pushd ${ABSOLUTE_PATH}/../rules

    # Iterate through Country Code Rules and sign.
    for i in $(find . -name 'rule.json'); do
        echo "Signing Rule: ${i}"
        # Append current date to rules json file
        tmp=$(mktemp)
        jq --arg a "$date" '.ValidFrom = $a' "$i" > "$tmp"
        # Sign Rule set with Country Key.
        dgc-cli signing sign-string -c "${CERTS_DIR_FULL_PATH}/${COUNTRY_CODE}_cert_upload.pem" -k "${CERTS_DIR_FULL_PATH}/${COUNTRY_CODE}_key_upload.pem" -o out -i "$tmp"
        # Upload Signed Rule set to DGC Gateway.
        curl --verbose --cert "${CERTS_DIR_FULL_PATH}/${COUNTRY_CODE}_cert_auth.pem" --key "${CERTS_DIR_FULL_PATH}/${COUNTRY_CODE}_key_auth.pem" -X POST --data-binary @out --header "Content-Type: application/cms" "${DGC_URL}"
    done
    popd
}

upsert_ruleset
