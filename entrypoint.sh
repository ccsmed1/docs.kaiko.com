#!/usr/bin/env bash
set -euo pipefail

uid=${USER_ID:-1101}
user=user
home=/app

useradd ${user} --user-group --non-unique --uid=${uid} --home=${home}
cd ${home}
exec /usr/local/bin/gosu ${user} "$@"
