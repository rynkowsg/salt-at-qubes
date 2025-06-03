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

### UTILITY FUNCTIONS

# Function to join array elements with a delimiter
join_by() {
  local delimiter="$1"
  shift
  local first="$1"
  shift
  printf "%s" "$first" "${@/#/$delimiter}"
}

### REST

set -x
DEBIAN_DEV_TEMPLATES="tpl-dev-debian-11"
FEDORA_DEV_TEMPLATES="tpl-dev-fedora-39"
DEV_QUBES="${DEV_QUBES:-"work-rynkowsg"}"
set +x

# debug
#sudo qubesctl --show-output --targets="dom0" state.apply debug.print_vars
#sudo qubesctl --show-output --targets="tpl-dev-debian-11" --skip-dom0 state.apply debug.print_vars

print_states() {
  # Preview with `slsutil.renderer`
  # Caviat: slsutil.renderer unfortunately does not resolve slspath so jinja can't import stuff with it
  sudo qubesctl --show-output --targets="${DEBIAN_DEV_TEMPLATES}" slsutil.renderer /srv/salt/rynkowski/catalog/docker_rootless/setup_tpl.sls default_renderer='jinja'
#  sudo qubesctl --show-output --targets="${DEBIAN_DEV_TEMPLATES}" slsutil.renderer /srv/salt/rynkowski/catalog/misc/pkgs_updated.sls default_renderer='jinja'
#  sudo qubesctl --show-output --targets="${DEBIAN_DEV_TEMPLATES}" slsutil.renderer /srv/salt/rynkowski/tpl-dev-debian/install.sls default_renderer='jinja'

  # Preview with `state.show_sls`
  # Caviat: Does not show bare YAML, but processes SLS
#  sudo qubesctl --show-output --targets="${DEBIAN_DEV_TEMPLATES}" state.show_sls rynkowski.tpl-dev-debian.install --output=yaml
}

run_states_for_dom0() {
    local dom0_states=(
#      "catalog.debug.echo_pillar"
#      "catalog.debug.print_vars"
      "catalog.dom0.install_templates_debian_minimal"
      "catalog.dom0.install_templates_fedora_minimal"
    )
    sudo qubesctl --show-output --targets=dom0 state.apply "$(join_by ',' "${dom0_states[@]}")"
}

run_states_for_dev() {
  # -------------------
  # template dev fedora
  # -------------------

  local debian_dev_states_for_dom0=(
    "tpl-dev-debian.clone"
  )
  sudo qubesctl --show-output --targets=dom0 state.apply "$(join_by ',' "${debian_dev_states_for_dom0[@]}")"

  local debian_dev_states_for_templates=(
#    "catalog.debug.print_vars"
    "tpl-dev-debian.install"
    "catalog.docker_rootless.setup_tpl"
  )
  sudo qubesctl --show-output --targets="${DEBIAN_DEV_TEMPLATES}" --skip-dom0 state.apply "$(join_by ',' "${debian_dev_states_for_templates[@]}")"

  # -------------------
  # template dev fedora
  # -------------------

  local fedora_dev_states_for_dom0=(
    "tpl-dev-fedora.clone"
  )
  sudo qubesctl --show-output --targets=dom0 state.apply "$(join_by ',' "${fedora_dev_states_for_dom0[@]}")"
  local fedora_dev_states_for_templates=(
#    "catalog.debug.print_vars"
    "tpl-dev-fedora.install"
    "catalog.misc.python_build_deps_installed"
    "catalog.docker_rootless.setup_tpl"
  )
  sudo qubesctl --show-output --targets="${FEDORA_DEV_TEMPLATES}" --skip-dom0 state.apply "$(join_by ',' "${fedora_dev_states_for_templates[@]}")"

  # ----------
  # qubes: dev
  # ----------

  sudo qubesctl --show-output --targets="${DEV_QUBES}" --skip-dom0 state.apply catalog.docker_rootless.setup_qube
}

#print_states
set -x
run_states_for_dom0
run_states_for_dev
set +x

echo "run completed"
