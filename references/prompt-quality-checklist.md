# Prompt Quality Checklist

Use this checklist when generating or reviewing final visual prompts.

## Card Package

- Default deliverable is exactly two Markdown file contents: `cards.md` and `prompts.md`.
- `cards.md` contains page structure, page type, page goal, visible text, semantic mapping, avoid-misread notes when relevant, and `发布配文`.
- `prompts.md` contains selected style, Style Lock, prompt skeleton or style notes, and page prompts.
- Default card set starts with 1 cover card plus the user-provided or generated content cards.
- Do not add a back-cover card unless the user asks for a closing page.
- Each content card has one core claim and 3-5 short visible information strips at most.
- Do not output stage analysis, variable tables, or a separate self-check report by default.

## Visual System

- One main color system for the full series
- One background type for the full series
- One texture plan for the full series
- One main visual style for the full series
- One selected Style Lock for the full series unless the user explicitly asks for a hybrid
- Reused borders, containers, arrows, icons, and line weights across cards
- Page types are selected from the Xiaohongshu page type library
- The main visual changes by page role, but the visual DNA stays stable

## Each Prompt

- Starts with a parameter tag such as `[3:4, 1K]`
- Uses the structured fields: generation target, visual mood, layout, content hierarchy, visual anchor, color, and avoid rules
- Includes visible title text
- Includes visible bullet/info strip text where needed
- Includes visible summary or call-to-action text where needed
- Names a concrete main visual object and the relationship it must express
- States layout position: top, middle, bottom, side note, or equivalent structure
- States hierarchy and whitespace
- Avoids vague-only style wording
- Does not put ratio in ordinary prose when it already appears in the parameter tag
- Does not collapse the prompt into one sentence unless the user explicitly asks for ultra-short prompts

## Concept Accuracy

- No fake web-checking claims
- Dynamic facts are marked as uncertain when not verifiable
- Visual prompt text does not introduce unsupported new factual claims
- Main visuals preserve the source concept hierarchy
- Side-note concepts are not promoted into equal pillars, equal layers, or a three-part architecture
- Pure analogy or "顺便说一下" concepts are usually excluded from the image prompt's `内容层级` and `视觉锚点`
- Analogies are shown as small comparison notes only when needed, never as shared architecture
- Deployment concepts are excluded from the main visual when the page's core claim is not about deployment; if mentioned, they stay as text-only notes with no icon, module, arrow, cloud, or server
- If the page has likely misreadings, the prompt has a clear `避免` clause

## Stop Conditions

- If the user asks for actual bitmap generation, stop this skill and route to an image-generation skill.
- If the user asks for PPTX, HTML, frontend, or deck packaging, stop this skill and route to the relevant production skill.
- If the generated prompts are the requested endpoint, do not ask for confirmation and do not continue into image generation.
