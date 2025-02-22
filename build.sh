#!/bin/sh

# set -e
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

install="$dir/airootfs/root/install.html"
network="$dir/airootfs/root/network.html"

wiki_domain="wiki.archlinux.org"

wget -qO - "https://${wiki_domain}/title/Installation_guide" > "$install"
wget -qO - "https://${wiki_domain}/title/Network_configuration" > "$network"

{
    rm -rf surf custom
    git clone https://aur.archlinux.org/surf.git
    cd surf
    PKGEXT=".pkg.tar" makepkg
    cd ..
    mkdir ./custom
    mv surf/surf-2.1-6-x86_64.pkg.tar custom/
    repo-add custom/custom.db.tar.zst custom/surf-2.1-6-x86_64.pkg.tar || exit
    if ! grep -q "^surf$" ./packages.x86_64 ; then
        echo "surf" >> ./packages.x86_64 
    fi
}

sudo mkarchiso -v -w "$work" -o "$iso_dir" "$dir"
