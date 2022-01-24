#!/usr/bin/env sh
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Dependencies: see the provided link.
#
# Description: Mount shared directory inside QEMU virtual machine with 9pfs.
# Link: https://wiki.qemu.org/Documentation/9psetup

mount \
  -t 9p \
  -o trans=virtio \
  -oversion=9p2000.L,posixacl,msize=104857600,cache=loose \
  share \
  /mnt/share
