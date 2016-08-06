#!/bin/bash

cd /opt/flyway
_url="${1}";
_user="${2}";
_password="${3}";
shift;
shift;
shift;
_command="${@}";

cp /drivers/* drivers/
cp /sql/* sql/

cat <<EOF >> conf/flyway.conf
flyway.url=${_url}
flyway.user=${_user}
flyway.password=${_password}
EOF
echo "Running flyway ${_command}"
./flyway ${_command}
