#!/usr/bin/env bash
# Guna: bin/projek-baru.sh <slug>   → cipta projek/<slug>/ daripada templat
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
slug="${1:?guna: bin/projek-baru.sh <slug>}"
dest="$root/projek/$slug"
[ -e "$dest" ] && { echo "Sudah wujud: $dest" >&2; exit 1; }
cp -r "$root/projek/_templat" "$dest"
mkdir -p "$dest/output"
echo "Projek baharu: $dest"
