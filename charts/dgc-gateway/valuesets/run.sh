#!/bin/bash

set -euo pipefail

echo "Fetching Database Access Token..."
ACCESS_TOKEN=$(curl --silent -H "Metadata: true" "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fossrdbms-aad.database.windows.net" | jq -r .access_token)


for file in *.json; do
    echo "Loading Valueset from ${file}:"
    VS=$(basename $file .json)
    echo "" > /tmp/${VS}.sql

    cat <<EOF > /tmp/${VS}.sql
INSERT INTO valueset VALUES (
'$VS', '$(cat ${file} | sed "s|'|\\\'|g")')
ON DUPLICATE KEY UPDATE
json = '$(cat ${file} | sed "s|'|\\\'|g")';
EOF

    mysql -h ${DATABASE_HOST} -u ${DATABASE_USER} -p${ACCESS_TOKEN} -D ${DATABASE_NAME} --enable-cleartext-plugin < /tmp/${VS}.sql
done

echo "Done"
exit 0
