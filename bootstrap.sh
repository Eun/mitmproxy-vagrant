#!/usr/bin/env bash
set -euo pipefail

# This is needed to supress annoying (but harmeless) error messages from apt-get
export DEBIAN_FRONTEND=noninteractive


# Fix DNS issues
echo "nameserver 8.8.8.8" > /etc/resolv.conf


echo "Installing dependencies"
apt-get update
apt-get install -y curl sudo screen vim
echo "Installing dependenices - done"

echo "Installing mitmproxy"
wget -nv -c https://snapshots.mitmproxy.org/7.0.2/mitmproxy-7.0.2-linux.tar.gz -O - | tar -xz
mv mitmdump mitmproxy mitmweb /usr/sbin/
echo "Installing mitmproxy - done"