# archlive-better

This is an [archiso](https://wiki.archlinux.org/title/Archiso) config
with changes and additional features from the *releng* profile.

## Major differences
- Graphical environment (xfce).
- Graphical browser (netsurf).
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

## How to install it on local EFI System Partition (ESP)
Extract the contents of the arch directory in there:
```sh
bsdtar -v -x --no-same-permissions --strip-components 1 \
    -f <archlive-better.iso>                            \
    -C /boot/EFI/archiso                                \
    arch
```

Add boot entry, example for systemd-boot:

```
title   Arch Live Better
linux   /EFI/archiso/boot/x86_64/vmlinuz-linux
initrd  /EFI/archiso/boot/x86_64/initramfs-linux.img
options archisobasedir=/EFI/archiso 
options archisosearchfilename=/EFI/archiso/boot/x86_64/vmlinuz-linux
```
