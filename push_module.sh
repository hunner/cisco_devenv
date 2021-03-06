#!/bin/sh

echo "WARNING: This copies the module to the switch's /etc/puppetlabs/code/modules directory for switch-local development. It may cause undefined behavior when editing code and using pluginsync from the master"
ssh -F files/switch.ssh-config n9kv1 'sudo rm -rf /nxos/tmp/*'
scp -F files/switch.ssh-config -r cisco-network-puppet-module n9kv1:/nxos/tmp
ssh -F files/switch.ssh-config n9kv1 'sudo rm -rf /etc/puppetlabs/code/modules/cisco-network-puppet-module'
ssh -F files/switch.ssh-config n9kv1 'rm -rf /nxos/tmp/cisco-network-puppet-module/.git'
ssh -F files/switch.ssh-config n9kv1 'sudo mv /nxos/tmp/cisco-network-puppet-module /etc/puppetlabs/code/modules/'
