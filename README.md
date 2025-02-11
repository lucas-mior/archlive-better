# archlive-better

This is an [archiso](https://wiki.archlinux.org/title/Archiso) config
with changes and additional features from the *releng* profile.
Major differences:
- Graphical environment (xfce).
- Graphical browser (firefox).
- Offline installation guide and network configuration pages from the wiki.
- Copy to ram is optional and disabled by default. Change on boot menu.
- Bigger (~400MB more)
- Accessibility stuff removed

## How to build
```sh
git clone https://github.com/lucas-mior/archlive-better
cd archlive-better
./build.sh # by default it saves the iso file at /tmp/
```
