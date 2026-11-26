---
name: buat-video
description: Pintu masuk untuk SETIAP permintaan video dalam repo ini. Gunakan serta-merta apabila pengguna berkata "buat video", "buatkan video", "nak video", "video infografik", "video pasal …", "explainer", "video promo" atau seumpamanya. Langkah pertama WAJIB ialah memaparkan pilihan (AskUserQuestion) untuk gaya video, narator, nisbah dan durasi — sebelum menulis skrip atau kod. Kemudian serahkan kepada skill gaya yang dipilih (vox-style-video atau bang-motion) dan narator percuma (MeloTTS-MS / edge-tts).
---

# Buat video — pilih dahulu, baru bina

## Langkah 1 — TERUS paparkan pilihan (jangan tanya dalam teks, jangan mula riset dulu)

Panggilan pertama ialah **AskUserQuestion** dengan 4 soalan ini (semua dalam
satu panggilan). Jika topik belum diberi, pengguna boleh taip dalam "Other" /
balasan seterusnya — tetap tunjuk pilihan dahulu.

**S1 · Gaya video** (header `Gaya`)
| Label | Penerangan (letak dalam `description`) | Skill |
|---|---|---|
| Infografik editorial (Recommended) | Latar kertas, stabilo, carta & angka beranimasi, sumber di skrin. Terbaik untuk data/fakta. | `vox-style-video` + `infografik/infografik.css` |
| Jurnalisme visual / kolase | Foto potongan, peta, dokumen, kamera menyusuri satu dunia kolase. | `bang-motion` → `starter-explainer-jurnalisme.html` |
| Kartun edukasi | Watak flat berwarna cerah, panggung hidup, sesuai kanak-kanak/umum. | `bang-motion` → `starter-explainer-panggung.html` (atau `-kartun`) |
| Sinematik / kinetic typography | Teks besar bergerak, gaya promo/opener, tenaga tinggi. | `bang-motion` → `starter-opener.html` |

Dalam `description` S1 sebut juga bahawa "Other" boleh pilih: *sketsa vintage*
(`starter-explainer-sketsa`), *katalog putih* (`starter-explainer-katalog`),
*aksi berterusan* (`starter-explainer`). Gunakan `preview` untuk setiap
pilihan: lakaran ASCII ringkas susun atur satu babak.

**S2 · Narator** (header `Narator`)
| Label | Penerangan |
|---|---|
| Shafiqah — BM perempuan (Recommended) | Percuma, lokal (MeloTTS-MS, Mesolitica). Paling natural untuk BM. |
| Husein — BM lelaki | Percuma, lokal (MeloTTS-MS). |
| ElevenLabs (kualiti premium) | Paling ekspresif; guna kredit akaun ElevenLabs pengguna (semak baki dulu). |
| Tanpa narator | Teks di skrin + sari kata sahaja (sesuai tonton tanpa bunyi). |

"Other" → Yasmin/Osman (`ms-MY-YasminNeural`/`ms-MY-OsmanNeural`, edge-tts,
lebih mendatar), suara Multilingual (`en-US-AvaMultilingualNeural`…), atau
Indonesia (`id-ID-GadisNeural`). Sampel: `narator/sampel/` (melotts-ms/,
multilingual/) — tawarkan untuk hantar dengan SendUserFile jika pengguna ragu.
Jangan sekali-kali guna speaker `anwar-ibrahim` dalam model MeloTTS-MS: ia
meniru suara tokoh sebenar.

**S3 · Nisbah** (header `Nisbah`): `16:9 YouTube (Recommended)` · `9:16 Reels/TikTok/Shorts` · `1:1 Instagram feed`

**S4 · Durasi** (header `Durasi`): `30 s` · `60 s (Recommended)` · `90 s` · `2–3 minit`

## Langkah 2 — Projek & data

1. `bin/projek-baru.sh <slug>`; isi `brief.md` dengan jawapan di atas.
2. Riset & isi `data.md` (angka + sumber). Jangan reka angka.
3. Tulis `narasi.txt` (~150 patah perkataan/minit, satu ayat satu baris,
   angka ditulis seperti disebut: "sembilan peratus"). Tunjuk skrip kepada
   pengguna jika topik fakta.

## Langkah 3 — Narator

- **MeloTTS-MS (Shafiqah/Husein) atau edge-tts (lain-lain):**
  `bin/narator.sh <slug> <suara> [+5%]` → `output/narasi.mp3` + `output/narasi.srt`.
  MeloTTS dipasang automatik kali pertama (`bin/pasang-melo.sh`, ~5 minit). Guna masa dalam `.srt` untuk
  set `--start/--dur` setiap babak supaya visual tepat dengan ayat.
- **ElevenLabs:** ikut arahan MCP ElevenLabs (`creative_list_voices` → pilih
  suara → `creative_generate_speech`); beritahu ia guna kredit.
- **Tanpa narator:** tambah `.subtitle`/teks lebih lama di skrin, muzik sahaja.

## Langkah 4 — Bina mengikut skill gaya

- Infografik editorial → ikut `CLAUDE.md` + skill `vox-style-video`;
  render `bin/render.sh <slug> --audio projek/<slug>/output/narasi.mp3`.
- Gaya `bang-motion` → baca SKILL.md bang-motion (hukum anti-PPT, style
  brief), mulakan dari starter yang dipetakan di atas, render dengan
  `scripts/export-frames.mjs` + ffmpeg, mux `narasi.mp3`.
- 9:16 → `--width 1080 --height 1920`; 1:1 → `--width 1080 --height 1080`.

## Langkah 5 — Semak & serah

Stills dahulu (baca PNG, betulkan), kemudian MP4 → SendUserFile + senarai sumber
data + nama suara narator.
