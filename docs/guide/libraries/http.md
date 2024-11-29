# Http

Library for sending http requests using [libsoup 3](https://gitlab.gnome.org/GNOME/libsoup).

## Usage

You can browse the [Http reference](https://aylur.github.io/libastal/apps).

### CLI

```sh
# Not yet written
```

## Installation

1. install dependencies

:::code-group

```sh [<i class="devicon-archlinux-plain"></i> Arch]
sudo pacman -Syu meson vala json-glib libsoup3 gobject-introspection
```

```sh [<i class="devicon-fedora-plain"></i> Fedora]
sudo dnf install meson vala valadoc json-glib-devel libsoup3-devel gobject-introspection-devel
```

```sh [<i class="devicon-ubuntu-plain"></i> Ubuntu]
sudo apt install meson valac libjson-glib-dev libsoup-3.0-dev gobject-introspection
```

:::

2. clone repo

```sh
git clone https://github.com/aylur/astal.git
cd astal/lib/http
```

3. install

```sh
meson setup --prefix /usr build
meson install -C build
```

## Usage

### Library

:::code-group

```js [<i class="devicon-javascript-plain"></i> JavaScript]
# Not yet documented
```

```py [<i class="devicon-python-plain"></i> Python]
# Not yet documented
```

```lua [<i class="devicon-lua-plain"></i> Lua]
# Not yet documented
```

```vala [<i class="devicon-vala-plain"></i> Vala]
# Not yet documented
```

:::
