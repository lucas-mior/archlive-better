#!/bin/sh

set -e
if [ -z "$1" ]; then
    echo "usage: $0 <output directory>"
    exit 1
fi
set -x

iso_dir="$1"
packages="./packages.x86_64"

dir=$(dirname "$0")
work="/tmp/archlive-better/"
if [ ! -e "$iso_dir" ]; then
    mkdir "$iso_dir"
fi

sudo bash -c "rm -rf /$work/*"

install="$dir/airootfs/root/install.html"
network="$dir/airootfs/root/network.html"

wiki_domain="wiki.archlinux.org"

if [ -n "$(find "$network" -mtime +2)" ] || [ ! -e "$network" ]; then
    wget -qO - "https://${wiki_domain}/title/Network_configuration" > "$network"
    wget -qO - "https://${wiki_domain}/title/Installation_guide" > "$install"
fi

sudo mkarchiso -v -w "$work" -o "$iso_dir" "$dir"
