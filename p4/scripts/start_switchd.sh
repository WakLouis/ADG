#!/usr/bin/env bash
set -euo pipefail
clock="${1:-long}"
case "$clock" in long|short) ;; *) echo "usage: $0 long|short" >&2; exit 2;; esac
: "${SDE_INSTALL:=${SDE:?Set SDE to the P4 Studio directory}/install}"
root="$(cd "$(dirname "$0")/.." && pwd)"
name="epoch_tofino2_$clock"
exec "$SDE_INSTALL/bin/bf_switchd" --install-dir "$SDE_INSTALL" \
    --conf-file "$root/build/$name/$name.conf"
