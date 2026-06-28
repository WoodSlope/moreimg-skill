# MoreImg Regression Tests

This file is for skill maintenance, not a required runtime reference.

## 1. Relationship Page With Side-Note Concept

User says:

```text
用 MoreImg 把 Workflow、Skill、微服务这篇文章生成 3 页小红书图文卡提示词。
```

Risk without the skill:

- The relationship page becomes "Workflow / Skill / 微服务三层关系图".
- Microservice is promoted into an equal conceptual pillar.
- Microservice appears as a cloud/server/module visual connected to Workflow or Skill, even though it is only an analogy or side note in the source.

Expected behavior:

- `cards.md` says the primary relationship is `Workflow 调度 Skill`.
- Microservice is described as a side note about deployment or analogy, not as visible image content for the relationship page.
- `prompts.md` visual anchor shows `Workflow 流程骨架 -> Skill 能力积木`.
- `prompts.md` content hierarchy does not list `微服务：管部署` as a normal visual bullet for the relationship page.
- `避免` explicitly blocks "Workflow、Skill、微服务三层并列架构" and also blocks cloud/server/microservice modules connected to the main visual.

Pass/fail:

- Pass if the relationship page's main visual only shows Workflow orchestrating Skill, and microservice is absent from the visual anchor.
- Fail if the prompt asks for a three-layer, three-column, equal-pillar diagram, or any microservice/cloud/server module connected to the main relationship.

## 2. User Asks For Direct Prompts

User says:

```text
直接给这篇文章的 3:4 小红书卡片文生图提示词。
```

Risk without the skill:

- Output becomes one-line prompts only.
- No `cards.md`, no `prompts.md`, no publish caption.
- Old ratio prose such as `3:4比例` appears instead of `[3:4, 1K]`.

Expected behavior:

- Output only two Markdown file contents: `cards.md` and `prompts.md`.
- `cards.md` includes `发布配文`.
- Each page prompt starts with `[3:4, 1K]`.
- Structured fields are preserved.

Pass/fail:

- Pass if no staged analysis, self-check report, or variable table is exposed.
- Fail if the deliverable is scattered across many chat sections.

## 3. User Asks For Actual Image Or PPT Production

User says:

```text
基于这些提示词生成图片。
```

or:

```text
把这些卡片做成 PPTX。
```

Risk without the skill:

- MoreImg continues beyond its scope and starts image generation or deck packaging.

Expected behavior:

- MoreImg stops at prompt/caption generation.
- Route image generation to an image-generation skill.
- Route PPTX/HTML/deck production to a production skill.

Pass/fail:

- Pass if MoreImg does not generate images, PPTX, HTML, thumbnail boards, or zip packages.
- Fail if MoreImg expands the deliverable beyond `cards.md` and `prompts.md`.

## 4. User Calls A Saved Style

User says:

```text
用 MoreImg 调用 xhs-terminal-tech-magazine，把这篇文章做成小红书图文卡提示词。
```

or:

```text
用法式电商杂志风，生成小红书卡片提示词。
```

Risk without the skill:

- The output silently falls back to `xhs-tech-knowledge`.
- Multiple styles are blended in the same note.
- Style files copied from PPT workflows leak 16:9, 2K, PPTX, thumbnail, or deck behavior into MoreImg.

Expected behavior:

- Match style by file name, Chinese name, alias, or obvious semantic description.
- Use exactly one selected Style Lock for the full note.
- Keep MoreImg default endpoint: only `cards.md` and `prompts.md`.
- Every prompt still starts with `[3:4, 1K]` unless the user explicitly asks for another parameter tag.

Pass/fail:

- Pass if the selected style's visual DNA appears in `prompts.md` and no unrelated style is mixed in.
- Fail if the result combines several style files, changes into PPT/deck language, or omits `发布配文`.

## 5. User Lists Available Styles

User says:

```text
用 MoreImg 列出可用风格。
```

Risk without the skill:

- The output starts generating `cards.md` and `prompts.md` even though no article was provided.
- The output dumps full Style Locks and wastes tokens.
- The output reads or summarizes maintenance materials such as `test-fixtures/` or `expected/`.

Expected behavior:

- Output a concise `可用风格` table.
- Include style ID, aliases/keywords, suitable content, and cautious-use scenarios.
- Include 1-2 calling examples.
- Generate the list from current `styles/*.md` files, not from a hard-coded table in `SKILL.md`.
- Stop after the list.

Pass/fail:

- Pass if no card prompts are generated and no maintenance fixture content is exposed.
- Fail if the response mixes style listing with article processing output or omits a saved style that exists in `styles/`.

## 6. User Saves A Reference Image Style

User says:

```text
复用
```

then after reviewing the extracted style:

```text
保存
```

Risk without the skill:

- The reference image is treated as one-off chat advice and not saved as a reusable style.
- The saved style copies watermarks, account names, exact titles, page numbers, or image subjects from the reference.
- The style file omits MoreImg defaults such as `[3:4, 1K]`, `默认比例：3:4`, or a structured prompt skeleton.
- The new style is saved but not discoverable in the available-style list.

Expected behavior:

- Save a reusable style file under `styles/`.
- Preserve visual DNA only: layout, color mood, typography mood, image style, density, page-type adaptation, negative constraints.
- Explicitly forbid copying reference watermarks, account identity, exact text, and page numbers.
- Update lightweight discovery/check materials when the style becomes built-in.

Pass/fail:

- Pass if the style can be called by ID or alias and fixture checks validate its basic structure.
- Fail if the style file contains one-off content from the reference image or omits the default parameter tag.

## 7. Structured Long Article Keeps Its Page Structure

User says:

```text
用 MoreImg 调用 xhs-tech-knowledge，把这篇已经分好第1页、第2页、第3页的小红书长文做成提示词。
```

Risk without the skill:

- The agent treats the source as an unstructured article and re-plans the page count.
- User-provided page intent is overwritten by generic cover / list / summary pages.
- The final prompt format differs from unstructured-article outputs.

Expected behavior:

- Preserve the user-provided page count and page themes.
- Compress visible text only where needed for image generation.
- Add semantic mapping and avoid-misread notes.
- Output the same `prompts.md` field structure used by all fixtures.

Pass/fail:

- Pass if `cards.md` keeps the original page count and `prompts.md` uses the standard fields.
- Fail if the structured source is expanded into a new carousel plan or produces a different prompt skeleton.

## 8. Unstructured Long Article Generates Pages But Keeps Prompt Shape

User says:

```text
用 MoreImg 调用 xhs-tech-knowledge，把这篇没有页结构的长文章做成小红书图文卡提示词。
```

Risk without the skill:

- The agent outputs one-line prompts or a planning report instead of `cards.md` and `prompts.md`.
- Generated pages use a different prompt skeleton from already paged inputs.
- The article is over-expanded into too many pages or copied as long paragraphs.

Expected behavior:

- Generate a concise card structure from the article.
- Keep each page to one core claim, short visible text, semantic mapping, and avoid-misread notes.
- Use the exact same structured prompt fields as already paged inputs.

Pass/fail:

- Pass if the unstructured route differs only in pre-processing, not final `prompts.md` structure.
- Fail if the final prompt skeleton diverges or long article paragraphs are pasted into image prompts.
