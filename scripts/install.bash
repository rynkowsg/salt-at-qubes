#!/usr/bin/env bash

# Bash Strict Mode Settings
set -euo pipefail
# Set dir variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P || exit 1)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd -P || exit 1)"

set -x

# copy minion data
sudo cp "${ROOT_DIR}/dom0/etc/salt/minion.d/rynkowski.conf" "/etc/salt/minion.d/rynkowski.conf"

# copy formulas
sudo rm -rf /srv/salt/rynkowski
sudo cp -r "${ROOT_DIR}/dom0/srv/salt/rynkowski" "/srv/salt/rynkowski"

echo "install completed"
