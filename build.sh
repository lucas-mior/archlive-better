#!/bin/sh

if [ -z "$1" ]; then
    echo "usage: $0 <output directory>"
    exit 1
fi
set -x

iso_dir="$1"

dir="$(dirname "$0")"
work="/tmp/archlive-better/"
if [ ! -e "$iso_dir" ]; then
    mkdir "$iso_dir"
fi

sudo bash -c "rm -rf /$work/*"

wiki_install="$dir/airootfs/root/install.html"
wiki_network="$dir/airootfs/root/network.html"

if [ "$(find "$wiki_install" -mtime +2)" ] || [ ! -e "$wiki_install" ]; then
    wget -qO - "https://wiki.archlinux.org/title/Installation_guide" \
        > "$wiki_install"
fi
if [ "$(find "$wiki_network" -mtime +2)" ] || [ ! -e "$wiki_network" ]; then
    wget -qO - "https://wiki.archlinux.org/title/Network_configuration" \
        > "$wiki_network"
fi

sudo mkarchiso -v -w "$work" -o "$iso_dir" "$dir"
