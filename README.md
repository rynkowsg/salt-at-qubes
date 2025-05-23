# salt at qubes

This repo contains salt config in my Qubes.

## Install

Optionally, run this to preview the README and copy-paste what follows:

```bash
qvm-run --pass-io work-rynkowsg 'cat $HOME/src/playground/salt-at-qubes/README.md'
```

Install `bootstrap_salt`:

```bash
SRC_QUBE=work-rynkowsg
qvm-copy-from-vm "${SRC_QUBE}" src/playground/salt-at-qubes/scripts/dom0/bootstrap_salt
mv "${HOME}/QubesIncoming/${SRC_QUBE}/bootstrap_salt" "${HOME}/bin/bootstrap_salt"
```

## Similar repos

The majority of the Salt code in this repo was taken from my dom0,
and it got there being installed by RPMs made from these repos:

- https://github.com/QubesOS/qubes-mgmt-salt
- https://github.com/QubesOS/qubes-mgmt-salt-base
- https://github.com/QubesOS/qubes-mgmt-salt-base-topd
- https://github.com/QubesOS/qubes-mgmt-salt-base-config
- https://github.com/QubesOS/qubes-mgmt-salt-base-overrides
- https://github.com/QubesOS/qubes-mgmt-salt-dom0-qvm
- https://github.com/QubesOS/qubes-mgmt-salt-dom0-update
- https://github.com/QubesOS/qubes-mgmt-salt-dom0-virtual-machines

Similar repos:

- https://github.com/unman/shaker
- https://github.com/ben-grande/qusal
