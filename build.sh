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

{
    custom="custom"
    surf="/tmp/surf"

    if [ "$(find ./surf/ -maxdepth 0 -mtime +2)" ] || [ ! -e "./surf/" ]; then
        rm -rf surf "/tmp/$custom"
        git clone https://aur.archlinux.org/surf.git "$surf"
        pushd "$surf"
        PKGEXT=".pkg.tar" makepkg
        popd ..
    fi

    previous_dir="$PWD"

    [ ! -e "/tmp/$custom" ] && mkdir "/tmp/$custom"
    cp "$surf"/*.pkg.tar -t "/tmp/$custom"

    cd "$previous_dir"

    repo-add "/tmp/$custom/$custom.db.tar.zst" \
             "/tmp/$custom/"*.pkg.tar
    if ! grep -q "^surf$" "$packages" ; then
        echo "surf" >> "$packages" 
    fi
}

sudo mkarchiso -v -w "$work" -o "$iso_dir" "$dir"
