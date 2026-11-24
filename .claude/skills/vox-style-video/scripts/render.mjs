#!/usr/bin/env node
// Deterministic renderer: pauses every CSS/Web animation, seeks to each frame,
// screenshots, and pipes PNGs into ffmpeg.
//
// node render.mjs video.html --out out.mp4 [--fps 30] [--width 1920 --height 1080]
//      [--audio vo.mp3] [--music bed.mp3] [--from 0 --to 12] [--crf 18]
//      [--stills 1,5.5,10 --out previewDir]
import { spawn } from 'node:child_process';
import { createRequire } from 'node:module';
import fs from 'node:fs';
import path from 'node:path';
import { pathToFileURL } from 'node:url';

const require = createRequire(import.meta.url);
let chromium;
try { ({ chromium } = require('playwright')); }
catch { ({ chromium } = await import('playwright')); }

const argv = process.argv.slice(2);
const input = argv.find(a => !a.startsWith('--') && !argv[argv.indexOf(a) - 1]?.startsWith('--')) ?? argv[0];
const opt = (k, d) => { const i = argv.indexOf(`--${k}`); return i >= 0 ? argv[i + 1] : d; };
if (!input || !fs.existsSync(input)) { console.error('usage: node render.mjs video.html --out out.mp4 [options]'); process.exit(1); }

const W = +opt('width', 1920), H = +opt('height', 1080);
const stills = opt('stills');
const out = opt('out', stills ? 'preview' : 'out.mp4');

const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: W, height: H }, deviceScaleFactor: 1 });
await page.goto(pathToFileURL(path.resolve(input)).href, { waitUntil: 'load' });
await page.evaluate(async () => {
  await document.fonts.ready;
  await Promise.all([...document.images].map(i => i.decode().catch(() => {})));
});

const meta = await page.evaluate(() => ({
  duration: parseFloat(document.querySelector('meta[name=duration]')?.content || '0'),
  fps: parseFloat(document.querySelector('meta[name=fps]')?.content || '30'),
}));
const fps = +opt('fps', meta.fps);
const from = +opt('from', 0), to = +opt('to', meta.duration);
if (!to) { console.error('Set <meta name="duration" content="SECONDS"> or pass --to'); process.exit(1); }

// Pause everything once; seek per frame. Animations created later (e.g. a class
// toggled by CSS) are picked up because we re-query each frame.
const seek = t => page.evaluate(ms => {
  for (const a of document.getAnimations()) { a.pause(); a.currentTime = ms; }
}, t * 1000);

if (stills) {
  fs.mkdirSync(out, { recursive: true });
  for (const s of stills.split(',').map(Number)) {
    await seek(s);
    const f = path.join(out, `still_${String(s).replace('.', '_')}s.png`);
    await page.screenshot({ path: f });
    console.log(f);
  }
  await browser.close();
  process.exit(0);
}

const audio = opt('audio'), music = opt('music');
const args = ['-y', '-loglevel', 'error', '-f', 'image2pipe', '-framerate', String(fps), '-c:v', 'png', '-i', '-'];
if (audio) args.push('-i', audio);
if (music) args.push('-stream_loop', '-1', '-i', music);
args.push('-c:v', 'libx264', '-preset', 'medium', '-crf', opt('crf', '18'), '-pix_fmt', 'yuv420p', '-movflags', '+faststart');
if (audio && music) {
  args.push('-filter_complex', '[2:a]volume=0.18[m];[1:a][m]amix=inputs=2:duration=first:dropout_transition=0[a]', '-map', '0:v', '-map', '[a]');
} else if (music) {
  args.push('-filter_complex', '[1:a]volume=0.5,afade=t=out:st=' + Math.max(0, to - from - 1.5) + ':d=1.5[a]', '-map', '0:v', '-map', '[a]');
} else if (audio) {
  args.push('-map', '0:v', '-map', '1:a');
}
if (audio || music) args.push('-c:a', 'aac', '-b:a', '192k', '-t', String(to - from));
args.push(out);

const ff = spawn('ffmpeg', args, { stdio: ['pipe', 'inherit', 'inherit'] });
const done = new Promise((res, rej) => ff.on('close', c => (c ? rej(new Error('ffmpeg exit ' + c)) : res())));

const total = Math.round((to - from) * fps);
const t0 = Date.now();
for (let i = 0; i < total; i++) {
  await seek(from + i / fps);
  const buf = await page.screenshot({ type: 'png' });
  if (!ff.stdin.write(buf)) await new Promise(r => ff.stdin.once('drain', r));
  if (i % fps === 0) process.stdout.write(`\r${i}/${total} frames (${((Date.now() - t0) / 1000).toFixed(0)}s)`);
}
ff.stdin.end();
await done;
await browser.close();
console.log(`\nwrote ${out}`);
