#!/usr/bin/env bash
# Pasang MeloTTS-MS (narator BM natural, percuma, lokal) ke .tts/melo
# Perlu: uv, python3.11, espeak-ng. Akses: huggingface.co (+ CDN), download.pytorch.org
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"; cd "$root"
[ -f /root/.ccr/ca-bundle.crt ] && export SSL_CERT_FILE=/root/.ccr/ca-bundle.crt REQUESTS_CA_BUNDLE=/root/.ccr/ca-bundle.crt UV_NATIVE_TLS=1 NLTK_ALLOW_PROXIED_URLOPEN=1
command -v espeak-ng >/dev/null || apt-get install -y -q espeak-ng
[ -x .tts/melo/bin/python ] || uv venv -q -p 3.11 .tts/melo
P=.tts/melo/bin/python
uv pip install -q -p $P torch torchaudio --index-url https://download.pytorch.org/whl/cpu
uv pip install -q -p $P "git+https://github.com/mesolitica/MeloTTS-MS"
uv pip install -q -p $P "git+https://github.com/mesolitica/malaya-speech" malaya phonemizer soundfile
uv pip install -q -p $P "transformers==4.40.2"   # malaya perlukan >4.27 (pin asal MeloTTS)
$P -m unidic download
$P -c "import nltk;[nltk.download(p,quiet=True) for p in ['cmudict','averaged_perceptron_tagger','averaged_perceptron_tagger_eng']]"
echo "MeloTTS-MS siap: bin/narator.sh <slug> shafiqah|husein"
