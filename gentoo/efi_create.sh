#!/usr/bin/env sh

readonly kernel_version="$1"

cp "/boot/vmlinuz-${kernel_version}-gentoo" "/boot/EFI/Gentoo/vmlinuz-${kernel_version}-gentoo.efi"
