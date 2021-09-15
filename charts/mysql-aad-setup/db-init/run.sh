#!/bin/bash

set -euo pipefail

echo "Fetching Database Access Token..."
ACCESS_TOKEN=$(curl --silent -H "Metadata: true" "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fossrdbms-aad.database.windows.net" | jq -r .access_token)

echo "Rendering SQL:"
envsubst < create-aad-user.sql.tmpl > /tmp/create-aad-user.sql

echo "Initializing Database..."
mysql -h ${DATABASE_HOST} -u ${DATABASE_ADMIN_USER} -p${ACCESS_TOKEN} --enable-cleartext-plugin < /tmp/create-aad-user.sql

echo "Done"
exit 0
