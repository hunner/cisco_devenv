#!/bin/sh

if ! `grep puppet /etc/hosts` ; then
  cat >> /etc/hosts <<EOF
127.0.0.1 puppet pe-puppet pe-puppet.localdomain
EOF
fi
if ! [ -f /vagrant/files/puppet.tar ] ; then
  curl http://enterprise.delivery.puppetlabs.net/2015.2/preview/puppet-enterprise-2015.2.1-rc1-5-g0d9d47c-el-7-x86_64.tar > /vagrant/files/puppet.tar
fi
if ! [ -d $HOME/puppet ] ; then
  tar xvf /vagrant/files/puppet.tar -C $HOME
fi
if ! [ -d /opt/puppetlabs ] ; then
  $HOME/puppet*/puppet-enterprise-installer -a /vagrant/files/master.answers
fi
ln -s /vagrant/cisco-network-puppet-module /etc/puppetlabs/code/modules/cisco
ln -s /vagrant/netdev_stdlib /etc/puppetlabs/code/modules/netdev_stdlib
echo 10.168.1.3 >> /etc/puppetlabs/puppet/autosign.conf
echo -e "root:vagrant" | chpasswd
echo -e "vagrant:vagrant" | chpasswd
echo 1 > /proc/sys/net/ipv4/ip_forward
echo net.ipv4.ip_forward = 1 > /etc/sysctl.d/ip_forward.conf
/sbin/iptables -D INPUT -j REJECT --reject-with icmp-host-prohibited
/sbin/iptables -D FORWARD -j REJECT --reject-with icmp-host-prohibited
/sbin/iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
/sbin/iptables -A FORWARD -i enp0s3 -o enp0s8 -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A FORWARD -i enp0s8 -o enp0s3 -j ACCEPT
