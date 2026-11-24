---
name: vox-style-video
description: Make editorial "explainer" videos in the style popularised by outlets like Vox — paper-textured backgrounds, highlighter swipes over key words, cut-out archival photos, animated maps and charts, quote cards with sources, slow Ken Burns pans and film grain. Use when the user asks for a "video style Vox", "explainer video", "video penjelasan", a documentary-style motion graphic, or wants a script/storyboard turned into an animated MP4. Covers research → script → storyboard → HTML/CSS scenes → deterministic frame render with Playwright + ffmpeg → optional voiceover and music mux.
---

# Vox-style explainer video

Builds a finished MP4 from a topic or script. Every scene is plain HTML + CSS
animations; `scripts/render.mjs` pauses all animations and seeks them frame by
frame, so the output is deterministic (no dropped frames, no screen recording).

Do **not** use any real outlet's logo, name, intro sting, music or channel
branding in the output. The *style* (editorial collage, highlighter, maps,
paper texture) is the goal — not impersonation. Use the user's own channel
name/brand if they give one.

## Workflow

1. **Brief** – confirm (or pick sensible defaults, don't over-ask):
   topic/angle, language of narration (default: the user's language),
   length (default 60–90 s), aspect (16:9 1920×1080 default; 9:16 1080×1920
   for Shorts/Reels/TikTok), and whether they have voiceover audio.
2. **Script** – follow `references/style-guide.md` → "Script". One central
   question, a cold-open hook, 3–5 beats, each beat one claim + one piece of
   evidence. ~150 words per minute of narration. Show the script to the user
   before building scenes if the topic is factual and sources matter.
3. **Storyboard** – a table: `# | t_start–t_end | narration line | visual
   (component from the kit) | on-screen text`. Each scene 3–8 s. Change the
   visual at least every ~4 s.
4. **Build** – copy `templates/` into a working folder (e.g. `./video/`), and
   write `video.html` using components from `templates/kit.css`
   (see `templates/example.html` for every component in use). Rules:
   - Set `<meta name="duration" content="SECONDS">` and fps optionally via
     `<meta name="fps" content="30">`.
   - Each scene is `<section class="scene" style="--start:X;--dur:Y">` (unitless seconds).
     The kit fades scenes in/out from those variables; children use
     `--d` (unitless seconds, delay **relative to scene start**) for their own entrance.
   - Animate only with CSS `@keyframes`/`animation` (or the Web Animations
     API). No `setTimeout`, `requestAnimationFrame` or JS-driven tweening —
     the renderer can only seek animations, not wall-clock code.
   - Images: local files or `data:` URIs. Remote images are fine only if the
     network allows the host; prefer downloading into the folder first. Use
     public-domain / CC / user-supplied images and put credits in the
     `.source` caption.
5. **Preview** – render stills to check layout fast:
   `node scripts/render.mjs video.html --stills 2,6,12 --out preview`
   then Read the PNGs and fix overlaps / unreadable text before a full render.
6. **Voiceover (optional)** – if the user has audio, use it. Otherwise, if the
   ElevenLabs MCP tools are available, generate narration
   (`creative_list_voices` → pick a voice → `creative_generate_speech`), download
   the file, and adjust scene `--start` times to the narration (use
   `ffprobe` for the duration; `creative_transcribe_audio` gives word timings
   if you need tight sync). Never invent a voice_id.
7. **Render** –
   `node scripts/render.mjs video.html --out out.mp4 [--audio vo.mp3] [--music bed.mp3]`
   Music is ducked to ~18% under voice automatically. Add `--width 1080
   --height 1920` for vertical.
   Speed: ~3–4 frames/s at 1080p (≈ 9 s of render per 1 s of video) — always
   check with `--stills` first, and use `--from/--to` to re-render one section.
8. **Deliver** – put the MP4 in the user's working directory, send it with
   SendUserFile, and list the sources/credits used.

## Files

- `references/style-guide.md` – the look & storytelling rules. Read before step 2.
- `templates/kit.css` – design tokens + components: paper bg, grain, vignette,
  `.headline`, `.hl` highlighter, `.cutout` photo, `.quote` card, `.map` pin +
  ring, `.bars` chart, `.counter`, `.timeline`, `.lower-third`, `.source`
  caption, `.kenburns`, `.underline-draw`, `.circle-draw`, `.arrow-draw`.
- `templates/example.html` – a 24 s demo using every component. Start from it.
- `scripts/render.mjs` – Playwright → PNG frames → ffmpeg (H.264, yuv420p,
  +faststart). Flags: `--out`, `--fps`, `--width`, `--height`, `--audio`,
  `--music`, `--stills t1,t2`, `--from`, `--to`, `--crf`.

## Quick test

```bash
cd ~/.claude/skills/vox-style-video
node scripts/render.mjs templates/example.html --out /tmp/vox-demo.mp4
```
