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

DEBIAN_TEMPLATES="tpl-dev-debian-11"
FEDORA_TEMPLATES="tpl-dev-fedora-39"

# debug
#sudo qubesctl --show-output --targets="dom0" state.apply debug.print_vars
#sudo qubesctl --show-output --targets="tpl-dev-debian-11" --skip-dom0 state.apply debug.print_vars

run_tops() {
  # before
  sudo qubesctl --show-output top.enabled

  # enable / plan to disable
  sudo qubesctl --show-output top.enable tpl-debian-minimal
  add_on_exit sudo qubesctl --show-output top.disable tpl-debian-minimal
  sudo qubesctl --show-output top.enable tpl-fedora-minimal
  add_on_exit sudo qubesctl --show-output top.disable tpl-fedora-minimal
  sudo qubesctl --show-output top.enable tpl-dev-debian
  add_on_exit sudo qubesctl --show-output top.disable tpl-dev-debian
  sudo qubesctl --show-output top.enable tpl-dev-fedora
  add_on_exit sudo qubesctl --show-output top.disable tpl-dev-fedora
  add_on_exit sudo qubesctl --show-output top.enabled

  # actions
  sudo qubesctl --show-output top.enabled
  sudo qubesctl --show-output state.highstate
  sudo qubesctl --show-output --targets="${DEBIAN_TEMPLATES}" state.apply
  sudo qubesctl --show-output --targets="${FEDORA_TEMPLATES}" state.apply
}

run_states() {
  sudo qubesctl --show-output --targets=dom0 state.apply tpl-debian-minimal.create
  sudo qubesctl --show-output --targets=dom0 state.apply tpl-fedora-minimal.create

  sudo qubesctl --show-output --targets=dom0 state.apply tpl-dev-debian.clone
  sudo qubesctl --show-output --targets="${DEBIAN_TEMPLATES}" --skip-dom0 state.apply tpl-dev-debian.install

  sudo qubesctl --show-output --targets=dom0 state.apply tpl-dev-fedora.clone
  sudo qubesctl --show-output --targets="${FEDORA_TEMPLATES}" --skip-dom0 state.apply tpl-dev-fedora.install
  sudo qubesctl --show-output --targets="${FEDORA_TEMPLATES}" --skip-dom0 state.apply tpl-dev-fedora.install-python-build-deps
}

# the two below should be equivalent, but I prefer run_states
#run_tops
run_states

set +x

echo "run completed"
