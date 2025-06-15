{#
#}

{%- set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] -%}

{% load_yaml as pkgs_to_install -%}
# pciutils
# Purpose: Provides utilities to inspect and manipulate PCI devices (e.g., lspci).
# Needed for: Debugging hardware, inspecting what PCI devices (like USB controllers) are available.
- pciutils

# qubes-input-proxy-sender
# A client-side daemon for forwarding USB input devices (mouse/keyboard)
# to dom0 via Qubes’ qubes.InputKeyboard and qubes.InputMouse RPC services.
# Needed for: Allowing USB input devices to be safely proxied from sys-usb to dom0.
- qubes-input-proxy-sender

# qubes-usb-proxy
# Purpose: Implements the USB proxy system for Qubes. Allows VMs to
# attach USB devices through sys-usb, avoiding direct USB access in dom0.
# Needed for: qvm-usb functionality – safely mediates USB access.
- qubes-usb-proxy

# app for pairing logitech devices
- solaar
{%- endload %}

include:
  - catalog.misc.pkgs_updated

"{{ ns }}/pkgs_installed":
{% if grains['os'] == 'Fedora' and grains['osmajorrelease'] >= 41 %}
  cmd.run:
    - require:
        - cmd: catalog.misc.pkgs_updated/default
    - name: dnf5 install -y {{ pkgs_to_install | join(' ') }}
{% else %}
  pkg.installed:
    - require:
        - pkg: catalog.misc.pkgs_updated/default
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs: {{ pkgs_to_install | sequence | yaml }}
{% endif %}
