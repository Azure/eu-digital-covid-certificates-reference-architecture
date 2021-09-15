#!/bin/bash

set -euo pipefail

echo "Fetching Database Access Token..."
ACCESS_TOKEN=$(curl --silent -H "Metadata: true" "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fossrdbms-aad.database.windows.net" | jq -r .access_token)

for f in trusted-party-*.json; do
	echo "Reading $f"

    export COUNTRY=$(cat $f | jq -r .country)
    export TYPE=$(cat $f | jq -r .certificate_type)
    export THUMBPRINT=$(cat $f | jq -r .thumbprint)
    export RAW=$(cat $f | jq -r .raw_data)
    export SIGNATURE=$(cat $f | jq -r .signature)

    envsubst < sql-template.txt >> /tmp/${COUNTRY}-${TYPE}.sql

    echo "Loading ${COUNTRY} ${TYPE} cert into the database:"
    mysql -h ${DATABASE_HOST} -u ${DATABASE_USER} -p${ACCESS_TOKEN} -D ${DATABASE_NAME} --enable-cleartext-plugin < /tmp/${COUNTRY}-${TYPE}.sql
done

echo "Done"
exit 0
