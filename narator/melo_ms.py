"""Narator BM natural, percuma & lokal: MeloTTS-MS (Mesolitica, MIT).
Guna: python narator/melo_ms.py narasi.txt out.wav [--suara shafiqah|husein] [--laju 1.0]
Juga tulis out.srt (masa setiap baris) untuk menyelaraskan babak.
Suara 'anwar-ibrahim' dalam model SENGAJA tidak disokong: ia meniru suara tokoh
sebenar — tidak sesuai untuk narasi (penyamaran)."""
import argparse, os, sys, numpy as np, soundfile as sf
from huggingface_hub import hf_hub_download
from melo.api import TTS

SUARA = {'husein': 0, 'shafiqah': 1}
ap = argparse.ArgumentParser()
ap.add_argument('teks'); ap.add_argument('out')
ap.add_argument('--suara', default='shafiqah', choices=SUARA)
ap.add_argument('--laju', type=float, default=1.0)
ap.add_argument('--jeda', type=float, default=0.35, help='senyap antara baris (s)')
a = ap.parse_args()

lines = [l.strip() for l in open(a.teks, encoding='utf-8') if l.strip()]
ckpt = hf_hub_download('mesolitica/MeloTTS-MS', 'model.pth')
cfg = hf_hub_download('mesolitica/MeloTTS-MS', 'config.json')
m = TTS(language='MS', config_path=cfg, ckpt_path=ckpt, device='cpu'); m.eval()
sr = m.hps.data.sampling_rate
gap = np.zeros(int(sr * a.jeda), dtype=np.float32)
chunks, srt, t = [], [], 0.1
chunks.append(np.zeros(int(sr * 0.1), dtype=np.float32))
fmt = lambda s: f"{int(s//3600):02d}:{int(s%3600//60):02d}:{int(s%60):02d},{int(s*1000%1000):03d}"
for i, line in enumerate(lines, 1):
    audio = m.tts_to_file(line, SUARA[a.suara], quiet=True, split=True, sdp_ratio=0.2,
                          noise_scale=0.667, speed=a.laju).astype(np.float32)
    d = len(audio) / sr
    srt.append(f"{i}\n{fmt(t)} --> {fmt(t + d)}\n{line}\n")
    chunks += [audio, gap]; t += d + a.jeda
    print(f"{i}/{len(lines)} {d:.1f}s", file=sys.stderr)
sf.write(a.out, np.concatenate(chunks), sr)
open(os.path.splitext(a.out)[0] + '.srt', 'w', encoding='utf-8').write('\n'.join(srt))
print(f"{a.out}: {t:.1f}s ({a.suara})")
