#!/bin/sh -e

topdir=`cd "${0%/*}" && echo "$PWD"`
cd "$topdir"

D=/opt/sway

p() {
    echo
    echo "\033[1;32m* $*\033[0m"
    echo
}

meson_install() {
    meson install -C build --only-changed
}

meson_build() {
    [ ! -f build/build.ninja ] && \
        LDFLAGS="-Wl,-rpath,$D/lib/x86_64-linux-gnu" \
            meson setup build \
            --buildtype=release --strip --prefix="$D" \
            -Dauto_features=disabled \
            -Dpkg_config_path="$D/lib/x86_64-linux-gnu/pkgconfig:$D/share/pkgconfig" \
            -Db_lto=true \
            "$@"
    ninja -C build
    meson_install
}

if [ ! -e "$D" ]; then
    sudo mkdir -p "$D"
    sudo chown $USER:$USER "$D"
fi

p deb packages
sudo apt install --no-install-recommends \
    meson \
    libxcb-dri3-dev \
    libxcb-present-dev \
    libxcb-render0-dev \
    libxcb-render-util0-dev \
    libxcb-res0-dev \
    libxcb-xinput-dev \
    libpipewire-0.3-dev \
    libinih-dev \
    libinput-dev \
    libgtkmm-3.0-dev \
    libdbusmenu-gtk3-dev \
    libupower-glib-dev \
    libjsoncpp-dev \
    libnl-genl-3-dev \
    libxkbregistry-dev \
    libturbojpeg-dev \
    libfontconfig-dev \
    libfreetype-dev \
    libharfbuzz-dev \
    libpixman-1-dev \
    libutf8proc-dev \
    libxkbcommon-dev \
    libpng-dev \
    scdoc wob slurp grim

p wayland
[ ! -d wayland ] && git clone https://gitlab.freedesktop.org/wayland/wayland.git
cd wayland
git fetch origin
git checkout 1.21.0
meson_build -Ddocumentation=false -Ddtd_validation=false -Dtests=false
cd - > /dev/null

p wayland-protocols
[ ! -d wayland-protocols ] && git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git
cd wayland-protocols
git fetch origin
git checkout 1.27
meson_build -Dtests=false
cd - > /dev/null

p libdrm
[ ! -d drm ] && git clone https://gitlab.freedesktop.org/mesa/drm.git
cd drm
git fetch origin
git checkout libdrm-2.4.113
meson_build -Dudev=true
cd - > /dev/null

p libseat
[ ! -d seatd ] && git clone https://git.sr.ht/~kennylevinsen/seatd
cd seatd
git fetch origin
git checkout 0.7.0
meson_build \
    -Dserver=disabled \
    -Dlibseat-seatd=disabled \
    -Dlibseat-logind=systemd \
    -Dlibseat-builtin=disabled
cd - > /dev/null

p wlroots
[ ! -d wlroots ] && git clone https://gitlab.freedesktop.org/wlroots/wlroots.git
cd wlroots
git fetch origin
git checkout 0.15.1
meson_build \
    -Dbackends=drm,libinput,x11 \
    -Dexamples=false \
    -Drenderers=gles2 \
    -Dxcb-errors=disabled \
    -Dxwayland=enabled
cd - > /dev/null

p sway
[ ! -d sway ] && git clone https://github.com/swaywm/sway.git
cd sway
git fetch origin
git checkout 1.7
meson_build \
    -Dbash-completions=false \
    -Dfish-completions=true \
    -Dzsh-completions=true \
    -Dgdk-pixbuf=enabled \
    -Dman-pages=enabled \
    -Dtray=enabled \
    -Dxwayland=enabled \
    -Dsd-bus-provider=libsystemd
cd - > /dev/null

p mako
[ ! -d mako ] && git clone https://github.com/emersion/mako.git
cd mako
git fetch origin
git checkout v1.7.1
meson_build \
    -Dfish-completions=false \
    -Dzsh-completions=false \
    -Dicons=enabled \
    -Dman-pages=enabled \
    -Dsd-bus-provider=libsystemd
cd - > /dev/null

p swaylock
[ ! -d swaylock ] && git clone https://github.com/swaywm/swaylock.git
cd swaylock
git fetch origin
git checkout 1.6
meson_build \
    -Dpam=enabled \
    -Dgdk-pixbuf=enabled \
    -Dman-pages=enabled \
    -Dzsh-completions=true \
    -Dbash-completions=false \
    -Dfish-completions=true
cd - > /dev/null

p swayidle
[ ! -d swayidle ] && git clone https://github.com/swaywm/swayidle.git
cd swayidle
git fetch origin
git checkout 1.7.1
meson_build \
    -Dlogind=enabled \
    -Dlogind-provider=systemd \
    -Dman-pages=enabled \
    -Dzsh-completions=true \
    -Dbash-completions=false \
    -Dfish-completions=true
cd - > /dev/null

p swaybg
[ ! -d swaybg ] && git clone https://github.com/swaywm/swaybg.git
cd swaybg
git fetch origin
git checkout v1.1.1
meson_build \
    -Dman-pages=enabled \
    -Dgdk-pixbuf=enabled
cd - > /dev/null

p xdg-desktop-portal-wlr
[ ! -d xdg-desktop-portal-wlr ] && git clone https://github.com/emersion/xdg-desktop-portal-wlr.git
cd xdg-desktop-portal-wlr
git fetch origin
git checkout v0.6.0
meson_build \
    -Dman-pages=enabled \
    -Dsd-bus-provider=libsystemd
cd - > /dev/null

p waybar
[ ! -d Waybar ] && git clone https://github.com/Alexays/Waybar.git
cd Waybar
git fetch origin
git checkout 0.9.15
meson_build \
    -Ddbusmenu-gtk=enabled \
    -Dgtk-layer-shell=disabled \
    -Dlibevdev=disabled \
    -Dlibinput=enabled \
    -Dlibnl=enabled \
    -Dlibudev=enabled \
    -Dlogind=enabled \
    -Dman-pages=enabled \
    -Dpulseaudio=enabled \
    -Dupower_glib=enabled \
    -Drfkill=enabled
cd - > /dev/null

p wayvnc
[ ! -d wayvnc ] && git clone https://github.com/any1/wayvnc.git
cd wayvnc
mkdir -p subprojects
[ ! -d subprojects/neatvnc ] && git clone https://github.com/any1/neatvnc.git subprojects/neatvnc
git -C subprojects/neatvnc fetch origin
git -C subprojects/neatvnc checkout v0.5.1
[ ! -d subprojects/aml ] && git clone https://github.com/any1/aml.git subprojects/aml
git -C subprojects/aml fetch origin
git -C subprojects/aml checkout v0.2.2
git fetch origin
git checkout v0.5.0
meson_build \
    -Dman-pages=disabled \
    -Dscreencopy-dmabuf=enabled \
    -Dpam=enabled \
    -Dneatvnc:jpeg=enabled
cd - > /dev/null

p foot
[ ! -d foot ] && git clone https://codeberg.org/dnkl/foot.git
cd foot
git fetch origin
git checkout 1.13.1-79-g59c9dfe1
if [ -d subprojects/fcft ]; then
    git -C subprojects/fcft fetch origin
    git -C subprojects/fcft checkout origin/master
fi
if [ -d subprojects/tllist ]; then
    git -C subprojects/tllist fetch origin
    git -C subprojects/tllist checkout origin/master
fi
PATH="$D/bin:$PATH" LDFLAGS='-Wl,-rpath,/opt/sway/lib/x86_64-linux-gnu' CC=gcc \
./pgo/pgo.sh \
    full-headless-sway . build \
    --strip --prefix="$D" \
    -Dauto_features=disabled \
    -Dpkg_config_path="$D/lib/x86_64-linux-gnu/pkgconfig:$D/share/pkgconfig" \
    -Ddocs=enabled \
    -Dthemes=true \
    -Dime=true \
    -Dgrapheme-clustering=enabled \
    -Dterminfo=enabled \
    -Dsystemd-units-dir="$D/lib/systemd/user" \
    -Dfcft:grapheme-shaping=enabled \
    -Dfcft:run-shaping=enabled \
    -Dfcft:svg-backend=none
meson_install
install -t ~/.terminfo/f/ build/f/*
cd - > /dev/null

p fuzzel
[ ! -d fuzzel ] && git clone https://codeberg.org/dnkl/fuzzel.git
cd fuzzel
git fetch origin
git checkout 1.8.0
meson_build \
    -Dpng-backend=libpng \
    -Dsvg-backend=nanosvg
cd - > /dev/null

p override dbus-1 services
mkdir -p ~/.local/share/dbus-1/services
ln -snf /opt/sway/share/dbus-1/services/fr.emersion.mako.service ~/.local/share/dbus-1/services/
ln -snf /opt/sway/share/dbus-1/services/org.freedesktop.impl.portal.desktop.wlr.service ~/.local/share/dbus-1/services/
