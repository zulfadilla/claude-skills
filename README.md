# claude-skills

Studio **video infografik** dengan skill Claude Code. Panduan kerja penuh: [`CLAUDE.md`](CLAUDE.md).

| Skill | Fungsi |
|---|---|
| `vox-style-video` | Video explainer gaya editorial (kertas, stabilo, peta, carta) → MP4 |
| `bang-motion` | Motion graphic web (opener, promo, kinetic typography, 5 gaya explainer) — oleh Bang Tutorial, lesen MIT |

## Cara guna

- **Dalam projek ini sendiri:** buka sesi Claude Code dengan repo ini — skill dalam `.claude/skills/` dimuat automatik.
- **Untuk semua projek (komputer sendiri):**
  ```bash
  git clone https://github.com/zulfadilla/claude-skills.git
  cp -r claude-skills/.claude/skills/* ~/.claude/skills/
  ```

## Video infografik

```bash
bin/projek-baru.sh nama-video          # salin projek/_templat
bin/render.sh nama-video --stills 2,8  # semak bingkai
bin/narator.sh nama-video ms-MY-YasminNeural   # narasi.txt → suara percuma
bin/render.sh nama-video --audio projek/nama-video/output/narasi.mp3
bin/render.sh nama-video               # → projek/nama-video/output/nama-video.mp4
```

- `infografik/infografik.css` — donut, carta garis, piktogram, bar mendatar, bar bertindan, grid statistik, versus, bulatan.
- `projek/contoh-sampah-plastik/` — contoh lengkap (data OECD 2022).

Mulakan dengan berkata **"buat video …"** — skill `buat-video` akan terus beri pilihan gaya, narator, nisbah & durasi.

Keperluan: Node 18+, Playwright (Chromium), ffmpeg, Python + `pip install edge-tts` (narator percuma).
