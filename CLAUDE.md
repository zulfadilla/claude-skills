# Projek: Video Infografik

Repo ini ialah studio untuk menghasilkan **video infografik** (data + carta +
angka beranimasi → MP4) memakai dua skill dalam `.claude/skills/`:

| Skill | Bila guna |
|---|---|
| `vox-style-video` | **Default untuk infografik.** Gaya editorial (kertas, stabilo, carta, peta, sumber). Animasi CSS sahaja → render deterministik ke MP4 dengan `render.mjs`. |
| `bang-motion` | Bila pengguna mahu lebih sinematik / promo / kinetic typography / kartun, atau mengeluh hasil "macam PPT". GSAP + `scripts/export-frames.mjs`. Patuhi hukum anti-PPT dalam SKILL.md-nya. |

Bahasa kerja: Bahasa Melayu (ikut bahasa pengguna).

> **Peraturan utama:** bila pengguna kata "buat video" (atau apa-apa permintaan
> video), invoke skill **`buat-video`** dan panggilan pertama ialah
> **AskUserQuestion** — pilihan gaya, narator, nisbah, durasi. Jangan tulis
> skrip/kod sebelum pengguna memilih.

Narator percuma: `bin/narator.sh <slug> shafiqah|husein` (MeloTTS-MS, lokal,
paling natural untuk BM; default) atau `ms-MY-YasminNeural` (edge-tts) →
`narasi.mp3` + `narasi.srt`. Sampel suara: `narator/sampel/`. Jangan guna
speaker `anwar-ibrahim` (meniru tokoh sebenar).

## Struktur

```
infografik/infografik.css   komponen carta tambahan (donut, garis, piktogram, bar mendatar,
                            bar bertindan, grid statistik, versus, bulatan) — sambungan kit vox
projek/_templat/            templat projek baharu (brief.md, data.md, video.html)
projek/<slug>/              satu folder setiap video
  brief.md                  topik, penonton, nisbah, durasi, gaya
  data.md                   setiap angka + sumber + tahun (WAJIB sebelum bina babak)
  video.html                babak
  output/                   MP4 + stills (diabaikan git)
bin/projek-baru.sh <slug>   salin templat
bin/render.sh <slug> [...]  render MP4 / stills
bin/narator.sh <slug> [suara] [kadar]  narasi.txt → narasi.mp3 + .srt (percuma)
bin/pasang-melo.sh          pasang MeloTTS-MS ke .tts/melo (sekali sahaja)
```

## Aliran kerja infografik

1. **Brief** – `bin/projek-baru.sh <slug>`, isi `brief.md`. Default: 16:9
   1920×1080, 30–60 s, gaya `vox-style-video`. 9:16 (1080×1920) untuk
   Reels/TikTok/Shorts.
2. **Data dahulu** – isi `data.md`: angka, unit, tahun, sumber (pautan).
   Jangan reka angka. Jika data contoh/ilustrasi, tulis "Data ilustrasi" pada skrin.
3. **Skrip + papan cerita** – satu idea per babak, 4–6 s setiap babak,
   setiap angka ada `.source` di skrin. Ikut `references/style-guide.md` skill vox.
4. **Pilih carta yang betul** (satu idea satu carta):
   - perubahan masa → `.line-chart` · bandingan kategori → `.bars` / `.hbars`
   - bahagian keseluruhan → `.stack` atau `.donut` · "X daripada 10" → `.picto`
   - angka utama → `.counter` / `.pct` / `.stats` · dua pilihan → `.versus`
   - saiz relatif → `.bubbles` · lokasi → `.map`
   Contoh penggunaan semua: `projek/contoh-sampah-plastik/video.html`.
5. **Semak stills** – `bin/render.sh <slug> --stills 2,8,14` lalu baca PNG;
   betulkan pertindihan/teks kecil (≥ 40 px pada 1080p).
6. **Render** – `bin/render.sh <slug>` → `projek/<slug>/output/<slug>.mp4`.
   Pilihan: `--audio vo.mp3 --music bed.mp3 --width 1080 --height 1920`.
7. **Serah** – hantar MP4 dengan SendUserFile, senaraikan sumber data.

## Peraturan

- Animasi hanya CSS `@keyframes` (untuk vox). Tiada `setTimeout`/rAF.
- Jangan guna logo/nama/jingle media sebenar; gaya sahaja.
- MP4 tidak di-commit (`.gitignore`) — hantar kepada pengguna.
