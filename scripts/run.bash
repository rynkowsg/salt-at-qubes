#!/usr/bin/env bash

# Bash Strict Mode Settings
set -euo pipefail
# Set dir variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P || exit 1)"

### TRAP

declare -a _ON_EXIT_ITEMS=()

on_exit() {
  for i in "${_ON_EXIT_ITEMS[@]}"; do
    eval "$i"
  done
}

add_on_exit() {
  local -r n=${#_ON_EXIT_ITEMS[*]}
  _ON_EXIT_ITEMS[n]="$*"
  # set the trap only the first time
  if [[ $n -eq 0 ]]; then
    trap on_exit EXIT INT
  fi
}

### REST

set -x

DEBIAN_DEV_TEMPLATES="tpl-dev-debian-11"
FEDORA_DEV_TEMPLATES="tpl-dev-fedora-39"
DEV_QUBES="${DEV_QUBES:-"work-rynkowsg"}"

# debug
#sudo qubesctl --show-output --targets="dom0" state.apply debug.print_vars
#sudo qubesctl --show-output --targets="tpl-dev-debian-11" --skip-dom0 state.apply debug.print_vars

run_states() {
  # dom0
  # (no dom0-specific states yet)
  # dev templates - debian
  sudo qubesctl --show-output --targets=dom0 state.apply tpl-debian-minimal.create
  sudo qubesctl --show-output --targets=dom0 state.apply tpl-dev-debian.clone
  sudo qubesctl --show-output --targets="${DEBIAN_DEV_TEMPLATES}" --skip-dom0 state.apply tpl-dev-debian.install
  # dev templates - fedora
  sudo qubesctl --show-output --targets=dom0 state.apply tpl-fedora-minimal.create
  sudo qubesctl --show-output --targets=dom0 state.apply tpl-dev-fedora.clone
  sudo qubesctl --show-output --targets="${FEDORA_DEV_TEMPLATES}" --skip-dom0 state.apply tpl-dev-fedora.install
  sudo qubesctl --show-output --targets="${FEDORA_DEV_TEMPLATES}" --skip-dom0 state.apply tpl-dev-fedora.install-python-build-deps
  sudo qubesctl --show-output --targets="${FEDORA_DEV_TEMPLATES}" --skip-dom0 state.apply catalog.docker_rootless.setup_tpl
  # dev qubes
  sudo qubesctl --show-output --targets="${DEV_QUBES}" --skip-dom0 state.apply catalog.docker_rootless.setup_qube
}

# the two below should be equivalent, but I prefer run_states
run_states

set +x

echo "run completed"
