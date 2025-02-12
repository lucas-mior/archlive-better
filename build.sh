#!/bin/sh

set -x

dir="$(dirname "$0")"
work="/var/cache/archlive-work/"
iso_dir="${1:-/tmp/}"
[ ! -e "$iso_dir" ] && mkdir "$iso_dir"

sudo bash -c "rm $work/build*; rm $work/iso.*"

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
