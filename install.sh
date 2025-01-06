#!/bin/sh
set -eu
trap "tput rmcup" EXIT

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
    echo "HOOKS"
    echo
    echo "Hooks are located in <NAME>/hooks."
    echo
    echo "Hooks:"
    echo "  pre-install.sh"
    echo "  post-install.sh"
    echo "  post-config.sh"
    echo
    echo
    echo "PACKAGE DEFINITIONS"
    echo
    echo "Package definitions are expected at <NAME> or <NAME>/package."
    echo "They are whitespace separated key value pairs."
    echo
    echo "Keys:"
    echo "  ARCH        Name in the Arch Repository or AUR."
    echo "  CARGO       Name of the corresponding Rust crate."
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

hook() {
    name="$1"
    shift

    echo
    echo "Running $name hooks..."
    echo

    for package in "$@"; do
        hook="$package/hooks/$name.sh"
        [ -f "$hook" ] && echo "  $package $name" && "./$hook"
    done || true
}

hook pre-install "$@"

os_id=$(awk 'BEGIN {FS="="} $1=="ID" {print $2}' /etc/os-release)
echo
echo "Determining and installing packages for $os_id..."
echo

pkgs_yay=""
for package in "$@"; do
    conf="$package"
    [ -d "$conf" ] && conf="$conf/package"

    [ "$conf" = "install.sh" ] && conf=""

    if [ -f "$conf" ]; then
        get_package() {
            awk -v key="$1" '$1==key {print $2}' "$conf"
        }

        pkg=""

        arch="$(get_package ARCH)"
        if [ -z "$pkg" ] && [ -n "$arch" ] && [ "$os_id" = "arch" ]; then
            pkg="$arch"
            if yay -T "$pkg" >/dev/null 2>&1; then
                echo "$pkg already installed"
            else
                echo "Installing $pkg via yay"
                pkgs_yay="$pkgs_yay $pkg"
            fi
        fi

        cargo="$(get_package CARGO)"
        if [ -z "$pkg" ] && [ -n "$cargo" ]; then
            pkg="$cargo"
            echo "Installing $pkg via cargo"
            tput smcup
            cargo install "$pkg"
            tput rmcup
        fi

        if [ -z "$pkg" ]; then
            echo "$package not found"
            exit 1
        fi
    fi
done

tput smcup
# shellcheck disable=SC2086
[ -n "$pkgs_yay" ] && yay -Sq $pkgs_yay
tput rmcup

hook post-install "$@"

echo
echo "Installing configurations..."
echo

# <https://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html>
for package in "$@"; do
    xdg_config="${XDG_CONFIG_HOME:-$HOME/.config}/$package"
    [ -d "$package/config" ] && mkdir -p "$xdg_config" && stow -vR --dotfiles -t "$xdg_config" -d "$package" config
    [ -d "$package/home" ] && stow -vR --dotfiles -t "$HOME" -d "$package" config
done

hook post-config "$@"
