#!/usr/bin/env bash
# Guna: bin/render.sh <slug> [--stills 2,8] [--audio vo.mp3] [--music m.mp3] [--width 1080 --height 1920] ...
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
slug="${1:?guna: bin/render.sh <slug> [pilihan render.mjs]}"; shift
dir="$root/projek/$slug"
[ -f "$dir/video.html" ] || { echo "Tiada $dir/video.html" >&2; exit 1; }
mkdir -p "$dir/output"
out="$dir/output/$slug.mp4"
[[ " $* " == *" --stills "* ]] && out="$dir/output/stills"
cd "$dir"
exec node "$root/.claude/skills/vox-style-video/scripts/render.mjs" video.html --out "$out" "$@"
