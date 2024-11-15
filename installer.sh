#!/bin/bash

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

install_fastfetch_ubuntu() {
    add-apt-repository -y ppa:zhangsongcui3371/fastfetch
    apt update
    apt install fastfetch
}

install_fastfetch_debian() {
    if command_exists "wget"; then
        architecture=$(dpkg --print-architecture)
        if [ "$architecture" == "arm64" ] || [ "$architecture" == "aarch64" ]; then
            architecture="aarch64"
        fi
        wget "https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-${architecture}.deb" -O /tmp/fastfetch-linux-${architecture}.deb
        dpkg -i /tmp/fastfetch-linux-${architecture}.deb
        rm /tmp/fastfetch-linux-${architecture}.deb
    else
        echo "Hey, you need 'wget' to download fastfetch. How about installing it and trying again?"
        exit 1
    fi
}

install_fastfetch_arch() {
    pacman -S fastfetch --noconfirm
}

install_fastfetch_fedora() {
    dnf install fastfetch
}

install_fastfetch_gentoo() {
    emerge --ask app-misc/fastfetch
}

install_fastfetch_alpine() {
    apk add --upgrade fastfetch
}

install_fastfetch_nixos() {
    nix-shell -p fastfetch
}

install_fastfetch_opensuse() {
    zypper install fastfetch
}

install_fastfetch_alt() {
    apt-get install fastfetch
}

main() {
    if [ -f "/etc/os-release" ]; then
        source "/etc/os-release"
        if [[ "$ID" == "ubuntu" ]]; then
            echo "Getting fastfetch for Ubuntu... Hang tight!"
            install_fastfetch_ubuntu
        elif [[ "$ID" == "debian" ]]; then
            echo "Grabbing fastfetch for Debian... Just a moment!"
            install_fastfetch_debian
        elif command_exists "pacman"; then
            echo "Downloading fastfetch for Arch Linux... Sit back and relax!"
            install_fastfetch_arch
        elif command_exists "dnf"; then
            echo "Fetching fastfetch for Fedora... Just a moment!"
            install_fastfetch_fedora
        elif command_exists "emerge"; then
            echo "Installing fastfetch for Gentoo... Almost there!"
            install_fastfetch_gentoo
        elif command_exists "apk"; then
            echo "Adding fastfetch to Alpine Linux... Just a quick one!"
            install_fastfetch_alpine
        elif command_exists "nix-shell"; then
            echo "Preparing fastfetch for NixOS... Hang tight!"
            install_fastfetch_nixos
        elif command_exists "zypper"; then
            echo "Snapping fastfetch for openSUSE... Just a moment!"
            install_fastfetch_opensuse
        elif command_exists "apt-get"; then
            echo "Fetching fastfetch for ALT Linux... Hold on tight!"
            install_fastfetch_alt
        else
            echo "Sorry, I can't recognize your distribution. You'll need to install fastfetch manually : ("
            exit 1
        fi
    else
        echo "Oops! Something went wrong. I couldn't detect your Linux distribution :/"
        exit 1
    fi
}

main
