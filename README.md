# archlive-better

This is an [archiso](https://wiki.archlinux.org/title/Archiso) config
with changes and additional features from the *releng* profile.

## Major differences
- Graphical environment (xfce).
- Graphical browser (surf).
- Offline installation guide and network configuration pages from the wiki.
- Copy to ram is optional and disabled by default. Change on boot menu.
- No accessibility boot entries
- No pxe stuff
- No early KMS loading
- Brazilian keyboard
- Only `en_US.UTF-8` locale

## How to build
```sh
git clone https://github.com/lucas-mior/archlive-better
cd archlive-better
./build.sh <iso destination directory>
```
