# salt at qubes

This repo contains salt config in my Qubes.

## Install

Optionally, run this to preview the README and copy paste rest of commands:

```bash
qvm-run --pass-io work-rynkowsg 'cat $HOME/src/playground/salt-at-qubes/README.md'
```

Install `bootstrap_salt`:

```bash
SRC_QUBE=work-rynkowsg
qvm-copy-from-vm "${SRC_QUBE}" src/playground/salt-at-qubes/scripts/dom0/bootstrap_salt
mv "${HOME}/QubesIncoming/${SRC_QUBE}/bootstrap_salt" "${HOME}/bin/bootstrap_salt"
```
