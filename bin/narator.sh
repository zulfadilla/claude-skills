#!/usr/bin/env bash
# Narator PERCUMA (Microsoft Edge neural TTS via edge-tts, tiada API key).
# Guna: bin/narator.sh <slug> [suara] [kadar]
#   baca  projek/<slug>/narasi.txt
#   tulis projek/<slug>/output/narasi.mp3 + narasi.srt (masa setiap ayat, untuk sync babak)
# Suara: ms-MY-YasminNeural (default, perempuan) | ms-MY-OsmanNeural (lelaki)
#        id-ID-GadisNeural | id-ID-ArdiNeural | en-US-AvaNeural ... (edge-tts --list-voices)
# Kadar: +0% default; cth +8% lebih laju, -5% lebih perlahan
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
slug="${1:?guna: bin/narator.sh <slug> [suara] [kadar]}"
voice="${2:-ms-MY-YasminNeural}"; rate="${3:-+0%}"
dir="$root/projek/$slug"; txt="$dir/narasi.txt"
[ -f "$txt" ] || { echo "Tiada $txt — tulis skrip narasi dahulu" >&2; exit 1; }
command -v edge-tts >/dev/null || pip install -q edge-tts
# Persekitaran berproksi (sesi awan): tambah CA proksi kepada certifi sekali sahaja
if [ -f /root/.ccr/ca-bundle.crt ]; then
  C=$(python3 -c "import certifi;print(certifi.where())")
  grep -q CCR_PROXY "$C" || { echo "# CCR_PROXY" >> "$C"; cat /root/.ccr/ca-bundle.crt >> "$C"; }
fi
mkdir -p "$dir/output"
edge-tts --voice "$voice" --rate="$rate" -f "$txt" \
  --write-media "$dir/output/narasi.mp3" --write-subtitles "$dir/output/narasi.srt"
dur=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$dir/output/narasi.mp3")
echo "narasi.mp3: ${dur}s  ($voice, $rate)"
echo "Masa ayat: $dir/output/narasi.srt"
