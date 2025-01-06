#!/bin/sh
set -eu

if [ "$1" = "--help" ]; then
    echo "Usage: $(basename "$0") [PACKAGE]..."
    echo "Install packages and configurations from this repository."
    echo
    echo "      --help        display this help and exit"
    echo
    echo "Examples:"
    echo "  $(basename "$0") git    Install git package and configuration"
    echo "  $(basename "$0") *      Install all packages and configurations in this repository"
    echo
    echo
    echo "PACKAGE DEFINITIONS"
    echo
    echo "Package definitions are expected at <NAME> or <NAME>/package."
    echo "They are whitespace separated key value pairs."
    echo
    echo "Keys:"
    echo "  DEFAULT     Name in the system repository. Only used as fallback."
    echo "  ARCH        Name in the Arch Repository or AUR."
    echo
    echo
    echo "PACKAGE CONFIGURATION"
    echo
    echo "Package configuration uses GNU Stow to manage symlinks."
    echo
    echo "Target locations:"
    echo "  <NAME>/config   \$XDG_CONFIG_HOME/<NAME> or \$HOME/.config/<NAME>"
    echo "  <NAME>/home     \$HOME"
    exit
fi

os_id=$(awk 'BEGIN {FS="="} $1=="ID" {print $2}' /etc/os-release)
pkgs_yay=""

echo "Determining and installing packages for $os_id..."
echo

for package in "$@"; do
    conf="$package"
    [ -d "$conf" ] && conf="$conf/package"

    [ "$conf" = "install.sh" ] && conf=""

    if [ -f "$conf" ]; then
        get_package() {
            awk -v key="$1" '$1==key {print $2}' "$conf"
        }

        not_found() {
            echo "$package not found"
            exit 1
        }

        already_installed() {
            echo "$package already installed"
        }

        case $os_id in
        arch)
            pkg=$(get_package ARCH)
            pkg=${pkg:-$(get_package DEFAULT)}
            [ -z "$pkg" ] && not_found
            yay -T "$pkg" >/dev/null 2>&1 && already_installed || pkgs_yay="$pkgs_yay $pkg"
            ;;
        esac
    fi
done

case "$pkgs_yay" in
*[!\ ]*)
    # shellcheck disable=SC2086
    yay -Sq $pkgs_yay
    echo
    ;;
esac

echo
echo "Installing configurations..."
echo

# <https://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html>
for package in "$@"; do
    xdg_config="${XDG_CONFIG_HOME:-$HOME/.config}/$package"
    [ -d "$package/config" ] && mkdir -p "$xdg_config" && stow -vR --dotfiles -t "$xdg_config" -d "$package" config
    [ -d "$package/home" ] && stow -vR --dotfiles -t "$HOME" -d "$package" config
done
