#!/bin/sh

#########################################################################
# Federico Simonetta <federicosimonetta at disroot.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#########################################################################

check_deps () {
    if command -v "apt-get" &> /dev/null; then
        # debian/ubuntu based
        packager="apt-get install"
        wireguard="wireguard"
        x11vnc="x11vnc"
    elif command -v "pacman" &> /dev/null; then
        # arch/manjaro based
        packager="pacman -Sy"
        wireguard="wireguard-tools"
        x11vnc="x11vnc"
    elif command -v "dnf" &> /dev/null; then
        # fedora based
        packager="dnf install"
        wireguard="wireguard-tools"
        x11vnc="x11vnc"
    fi

    packages=""
    if ! command -v "wg-quick" &> /dev/null; then
        # add wireguard to installation list
        packages="$packages $wireguard"
    fi

    if ! command -v "x11vnc" &> /dev/null; then
        # add x11vnc to installation list
        packages="$packages $x11vnc"
    fi

    if [ ! -z "$packages" ]; then
        echo "Need sudo password for installing the following packages:"
        echo ">> $packages"
        echo -n "Password: "
        read -n passwd
        echo $passwd | sudo $packager $packages
    fi
}

prepare_vpn() {
    # take the final part of this script nad writes it to file
    ARCHIVE=$(awk '/^#__WIREGUARD_CONF__#/ {print NR + 1; exit 0; }' $0)
    tail -n+$ARCHIVE $0 > $1
}

launch_assistance () {
    check_deps
    prepare_vpn $1
    wg-quick up $1
    echo "VPN set up!"
    echo "Now starting x11vnc press CTRL+C to exit and to stop the VPN"
    x11vnc
}

on_exit () {
    wg-quick down $1
    rm $1
    rm $0
    echo "VPN removed!"
}

trap on_exit EXIT
trap on_exit SIGINT
check_deps
vpn_conf="./myvpn.conf"
launch_assistance $vpn_conf
on_exit $vpn_conf
exit 0

#__WIREGUARD_CONF__#
