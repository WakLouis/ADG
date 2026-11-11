#!/usr/bin/env bash
set -euo pipefail
clock="${1:-long}"
case "$clock" in long|short) ;; *) echo "usage: $0 long|short" >&2; exit 2;; esac
: "${SDE_INSTALL:=${SDE:?Set SDE to the P4 Studio directory}/install}"
root="$(cd "$(dirname "$0")/.." && pwd)"
name="epoch_tofino2_$clock"
mkdir -p "$root/build/$name"
"$SDE_INSTALL/bin/bf-p4c" --std p4-16 --target tofino2 --arch t2na --auto-init-metadata -g \
    -o "$root/build/$name" "$root/p4src/$name.p4"
