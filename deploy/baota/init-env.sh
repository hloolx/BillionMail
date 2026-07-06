#!/usr/bin/env bash
set -eu

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "${ROOT_DIR}"

if [ -f ".env" ]; then
  echo ".env already exists: ${ROOT_DIR}/.env"
  exit 0
fi

rand_hex() {
  openssl rand -hex 32 | cut -c1-"$1"
}

ADMIN_USERNAME="admin$(rand_hex 6)"
ADMIN_PASSWORD="$(rand_hex 16)"
SAFE_PATH="$(rand_hex 10)"
DBPASS="$(rand_hex 32)"
REDISPASS="$(rand_hex 32)"

cat > .env <<EOF
ADMIN_USERNAME=${ADMIN_USERNAME}
ADMIN_PASSWORD=${ADMIN_PASSWORD}
SafePath=${SAFE_PATH}

BILLIONMAIL_HOSTNAME=mail.oai.sb

DBNAME=billionmail
DBUSER=billionmail
DBPASS=${DBPASS}
REDISPASS=${REDISPASS}

SMTP_PORT=25
SMTPS_PORT=465
SUBMISSION_PORT=587
IMAP_PORT=143
IMAPS_PORT=993
POP_PORT=110
POPS_PORT=995
REDIS_PORT=127.0.0.1:26379
SQL_PORT=127.0.0.1:25432

HTTP_PORT=80
HTTPS_PORT=443

WEB_BASE_PATH=
AAPANEL_SSO_SECRET=
TZ=Asia/Singapore
IPV4_NETWORK=172.66.1
FAIL2BAN_INIT=y
IP_WHITELIST_ENABLE=false
RETENTION_DAYS=7
EOF

mkdir -p ssl
cp -n ssl-self-signed/* ssl/

echo "Generated ${ROOT_DIR}/.env"
echo "BillionMail URL: https://mail.oai.sb/${SAFE_PATH}"
echo "Username: ${ADMIN_USERNAME}"
echo "Password: ${ADMIN_PASSWORD}"
