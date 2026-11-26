#!/usr/bin/env bash
# Narator PERCUMA. Dua enjin:
#   MeloTTS-MS (lokal, BM paling natural): suara shafiqah | husein  (pasang: bin/pasang-melo.sh)
#   edge-tts (Microsoft, perlu internet):  suara ms-MY-YasminNeural | ms-MY-OsmanNeural | *MultilingualNeural ...
# Guna: bin/narator.sh <slug> [suara] [kadar]
#   baca  projek/<slug>/narasi.txt
#   tulis projek/<slug>/output/narasi.mp3 + narasi.srt (masa setiap ayat, untuk sync babak)
# Suara: ms-MY-YasminNeural (default, perempuan) | ms-MY-OsmanNeural (lelaki)
#        id-ID-GadisNeural | id-ID-ArdiNeural | en-US-AvaNeural ... (edge-tts --list-voices)
# Kadar: +0% default; cth +8% lebih laju, -5% lebih perlahan
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
slug="${1:?guna: bin/narator.sh <slug> [suara] [kadar]}"
voice="${2:-shafiqah}"; rate="${3:-+0%}"
dir="$root/projek/$slug"; txt="$dir/narasi.txt"
[ -f "$txt" ] || { echo "Tiada $txt — tulis skrip narasi dahulu" >&2; exit 1; }
mkdir -p "$dir/output"
if [[ "$voice" == shafiqah || "$voice" == husein ]]; then
  [ -x "$root/.tts/melo/bin/python" ] || "$root/bin/pasang-melo.sh"
  [ -f /root/.ccr/ca-bundle.crt ] && export SSL_CERT_FILE=/root/.ccr/ca-bundle.crt REQUESTS_CA_BUNDLE=/root/.ccr/ca-bundle.crt
  export HF_HUB_DISABLE_XET=1
  # kadar edge-tts "+10%" -> laju 1.10
  laju=$(python3 -c "import sys;r=sys.argv[1].rstrip('%');print(round(1+float(r)/100,3))" "$rate")
  "$root/.tts/melo/bin/python" "$root/narator/melo_ms.py" "$txt" "$dir/output/narasi.wav" --suara "$voice" --laju "$laju" 2>/dev/null
  ffmpeg -loglevel error -y -i "$dir/output/narasi.wav" -b:a 192k "$dir/output/narasi.mp3"
  echo "narasi.mp3 ($voice, MeloTTS-MS) · masa ayat: $dir/output/narasi.srt"; exit 0
fi
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
