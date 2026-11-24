# Style guide – editorial explainer

## Script

- **Open with a question or a surprising fact** in the first 5 s
  ("Kenapa harga beras naik, padahal panen melimpah?"). No "Halo guys".
- Structure: Hook → Context ("to understand this, we have to go back to…")
  → 3–5 evidence beats → Turn (the counter-intuitive insight) → Payoff that
  answers the opening question → one-line kicker.
- Each beat = **one claim + one concrete piece of evidence** (a number, a
  quote, a map, a document). Name the source on screen.
- Conversational, second person, short sentences. ~150 wpm.
  60 s ≈ 150 words, 90 s ≈ 225 words.
- Write numbers the way they'll be shown: "3 dari 10 orang", not "30.4%".
- Mark the word to highlight in each line with `==word==` in the script; it
  becomes the `.hl` highlight on screen.

## Look

| Element | Rule |
|---|---|
| Background | Warm off-white paper (`--paper`) with subtle texture; dark navy (`--ink-bg`) for "dramatic" beats only. |
| Type | Headlines: heavy grotesque (Inter Black/ExtraBold), tight tracking, max ~7 words. Quotes: serif italic. Captions/sources: small mono or sans, uppercase. |
| Accent | One highlighter colour (`--accent`, yellow) for emphasis; one secondary (`--accent-2`, red-orange) for pins, arrows, "bad" data. Don't add more. |
| Photos | Cut-out / torn-edge archival photos, slight rotation (−3°…3°), drop shadow, often desaturated with an accent duotone. Credit every photo. |
| Motion | Slow and purposeful. Entrances 0.4–0.8 s, ease-out. Ken Burns on every still (scale 1 → 1.08 over the scene). Highlighter wipes L→R after the word appears (~0.3 s later). |
| Maps | Simplified shapes, muted land, one highlighted region, a pulsing ring on the point of interest, a label in a white tag. |
| Data | One idea per chart. Bars grow from baseline, value labels count up, the key bar in accent colour, rest in grey. Source line under the chart. |
| Texture | Film grain + vignette on top of everything (kit does this via `.stage::after`). |
| Pace | New visual every 3–5 s. Hold the key insight 1 s longer than feels needed. |

## Scene recipes (map to kit components)

- **Cold open**: `.headline` with `.hl` on one word, over a `.kenburns` photo dimmed.
- **"Go back in time"**: `.timeline` with years popping in; `.cutout` photos per year.
- **Where**: `.map` with `.pin` + `.ring`, `.lower-third` naming the place.
- **How big**: `.counter` big number + `.bars` comparison.
- **Who said**: `.quote` card + `.source`, photo `.cutout` beside it.
- **Document evidence**: screenshot/doc image as `.cutout` with `.circle-draw`
  or `.underline-draw` over the key line.
- **Payoff**: dark scene (`.scene.dark`), single sentence, highlighter on the answer.

## Accessibility

- Text on screen ≥ 40 px at 1080p (≥ 48 px for 9:16).
- Keep important text inside the central 90% (title-safe).
- Burned-in subtitles: optional `.subtitle` strip at the bottom — add it if the
  user targets social platforms (most watch muted).
