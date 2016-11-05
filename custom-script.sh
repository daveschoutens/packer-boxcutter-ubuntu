#!/usr/bin/env bash

set -eux

# Eliminate ugly 'no-tty' error message during shell provisioning in vagrant
echo "==> Eliminating annoying 'stdin: no tty' errors..."
sudo sed -i '/tty/!s/mesg n/tty -s \&\& mesg n/' /root/.profile

# Fix nasty apt-get provisioning issue: "dpkg-preconfigure: unable to re-open stdin: No such file or directory"
# This fix eliminates the "dpkg-preconfigure" step from applying all the time
# An alternate fix is to "export DEBIAN_FRONTEND=noninteractive" to each shell script (or set it on the users env)
# to avoid looking for stdin...

# if [ -s "/etc/apt/apt.conf.d/70debconf" ]
# then
sudo rm -v /etc/apt/apt.conf.d/70debconf
# fi

# Fix locale issues for root and vagrant users (issue prevents gnome-terminal from working)
echo "==> Fixing locale issues..."
echo "==> Generating locale for en_US.UTF-8"
locale-gen --purge "en_US.UTF-8"

echo "==> Setting root locale"
localectl set-locale LANG="en_US.UTF-8"

echo "==> Setting vagrant user locale"
sudo -H -u vagrant bash -c 'localectl set-locale LANG="en_US.UTF-8"'

# Disable periodic / automatic updates. These updates happen on boot and thus prevent vagrant provisioners from using apt/dpkg
# Source: http://www.hiroom2.com/2016/05/18/ubuntu-16-04-auto-apt-update-and-apt-upgrade/#sec-7
echo "==> Disabling automatic unattended updates"
systemctl disable apt-daily.service # disable run when system boot
systemctl disable apt-daily.timer   # disable timer run
