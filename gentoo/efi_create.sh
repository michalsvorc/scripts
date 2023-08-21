#!/usr/bin/env sh

readonly kernel_version="$1"

# TODO check if /boot is mounted

cp "/boot/vmlinuz-${kernel_version}" "/boot/EFI/Gentoo/vmlinuz-${kernel_version}.efi"
