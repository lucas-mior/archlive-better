#!/bin/sh

set -e
if [ -z "$1" ]; then
    echo "usage: $0 <output directory>"
    exit 1
fi
set -x

iso_dir="$1"
packages="./packages.x86_64"

dir="$(dirname "$0")"
work="/tmp/archlive-better/"
if [ ! -e "$iso_dir" ]; then
    mkdir "$iso_dir"
fi

sudo bash -c "rm -rf /$work/*"

install="$dir/airootfs/root/install.html"
network="$dir/airootfs/root/network.html"

wiki_domain="wiki.archlinux.org"

if [ "$(find "$network" -mtime +2)" ] || [ ! -e "$network" ]; then
    wget -qO - "https://${wiki_domain}/title/Network_configuration" > "$network"
    wget -qO - "https://${wiki_domain}/title/Installation_guide" > "$install"
fi

aur () {
    pkg="$1"
    d="/tmp/$1"
    if [ "$(find "$d" -maxdepth 0 -mtime +2)" ] || [ ! -e "$d" ]; then
        rm -rf "$d" "/tmp/$custom"
        git clone "https://aur.archlinux.org/$pkg.git" "$d"
        previous_dir="$PWD"
        cd "$d"
        PKGEXT=".pkg.tar" makepkg
        cd "$previous_dir"
    fi

    [ ! -e "/tmp/$custom" ] && mkdir "/tmp/$custom"
    cp "$d"/*.pkg.tar -t "/tmp/$custom"
    if ! grep -q "^$pkg$" "$packages" ; then
        echo "$pkg" >> "$packages" 
    fi
}

{
    custom="custom"

    aur surf
    aur localepurge

    repo-add "/tmp/$custom/$custom.db.tar.zst" \
             "/tmp/$custom/"*.pkg.tar
}

sudo mkarchiso -v -w "$work" -o "$iso_dir" "$dir"
