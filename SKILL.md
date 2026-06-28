---
name: MoreImg
description: 当用户提供中文文章、图文笔记文案、卡片文案，并希望生成小红书风格文生图提示词、卡片提示词、调用/保存图文卡风格时使用。
---

# MoreImg

## Goal

MoreImg turns a user-approved topic, article draft, long-form note, or paged Xiaohongshu card copy into a design-style-aware text-to-image prompt pack for Xiaohongshu image-text cards.

The skill's job is to optimize the provided content into a visual-generation-ready structure, not to invent a new topic strategy or produce final images. It should preserve the user's core meaning, normalize the material into `Page Spec`, apply one selected visual style, and output:

- `cards.md`: optimized card content, page types, visible text, semantic mapping, avoid-misread notes, and publish caption.
- `prompts.md`: one Style Lock and structured per-page text-to-image prompts.

All future optimization should strengthen this path: topic/article/card copy -> Page Spec -> `cards.md` + `prompts.md`.

## Core Idea

Turn Xiaohongshu image-text card style into a reusable `Style Lock`, then apply it to each page with a structured `Page Prompt`, and finish with a publish-ready caption.

Do not build prompts from a long variable table. Use this structure instead:

```text
Style Lock = 全局视觉 DNA
Page Type = 页面角色
Page Spec = 统一页面规格：页型、页面目标、入图文字、语义映射、避免误读
cards.md = 图文笔记内容、页型、入图文字、发布配文
prompts.md = 风格锁、提示词骨架、逐页文生图提示词
```

Default output is two Markdown file contents: `cards.md` and `prompts.md`. Stop there. Do not generate images, assemble PPTX files, or create frontend artifacts unless the user explicitly switches to another skill.

## Optimization Direction

Optimize this skill for stable, repeatable prompt-pack generation, not for shaving small amounts of output text.

- Keep one fixed generation pipeline: input -> Page Spec -> `cards.md` -> `prompts.md`.
- Keep one default deliverable: `cards.md` + `prompts.md`.
- Treat `cards.md` as the semantic source of truth and `prompts.md` as the execution prompt pack.
- Prefer consistency, semantic accuracy, and reusable output over prompts-only shortcuts or output-branch proliferation.
- Add a new branch only when it protects the skill boundary, such as style listing, style saving, revision, or routing actual image/PPT production to another skill.
- Do not add narrow exceptions just because a user could copy less text from the final answer.

## When Not To Use

- The user asks to generate the actual bitmap image, not prompts. Use the image-generation skill instead.
- The user asks for frontend HTML, PPT, or deck production. Use the relevant presentation/frontend skill instead.
- The user only wants ordinary copywriting polish and does not ask for card prompts, image prompts, style reuse, or Xiaohongshu image-text note packaging.

## Runtime References

Read only the references needed for the current route.

For standard article/card-to-prompt generation:

- Read `references/xhs-page-types.md` for Xiaohongshu page type selection.
- Read `references/prompt-quality-checklist.md` for final prompt review.
- Read exactly one selected style file from `styles/`. If no style is named, read `styles/xhs-tech-knowledge.md`.

For conditional routes:

- If the user asks to revise an existing `cards.md` or `prompts.md`, read `references/prompt-revision.md`.
- If the user asks to save, extract, rename, or update a reusable style, read `references/style-extraction.md`.
- If the user asks to list, call, save, rename, or update styles, inspect files in `styles/`; for listing, inspect only headings, aliases, positioning, and default parameters unless more detail is requested.
- Do not read or summarize maintenance materials such as `test-fixtures/`, `expected/`, or `references/regression-tests.md` during normal use.

## Default Behavior

- Default mode: two-file content output. Do not output judgment, visual-parameter tables, staged analysis, or self-check sections unless there is a real risk to mention.
- Default deliverable: `cards.md` + `prompts.md`.
- Fixed generation pipeline: normalize any article, card copy, or page-structured source into one `Page Spec`, then generate `cards.md` and `prompts.md` from that same Page Spec.
- Default aspect and size tag: `[3:4, 1K]`.
- Default language: Chinese-first. Keep necessary product names, model names, and technical terms in their original form.
- Default style: `styles/xhs-tech-knowledge.md` unless the user names another saved style or provides a reference style.
- Default text density: low to medium. Cover pages use one title, one subtitle, and one tagline. Content pages use one title, 3-5 short information strips, and at most one summary line.
- Default page labels: `封面页` and `内容页1/N`. Do not create a back-cover page unless the user asks for a closing page.
- Default style isolation: use one Style Lock for one note. Do not blend unrelated saved styles unless the user explicitly asks for a hybrid.
- Default endpoint: this skill ends after `cards.md` and `prompts.md`. It must remain usable by other agents and non-Codex models such as DeepSeek, so output plain Markdown and avoid tool-specific assumptions except simple parameter tags like `[3:4, 1K]`.
- Do not write files to disk unless the user explicitly asks to save/update local files or provides paths. Asking to save, update, rename, or create a reusable style counts as permission to write under `styles/`. By default, output generated card/prompt file contents in the chat.

## Workflow

1. Classify the request:
   - Article or card copy to prompt pack.
   - Saved style operation: list, call, save, rename, update.
   - Prompt revision for one page or one style.
   - Existing two-file workflow: update `cards.md`, `prompts.md`, or both.
2. Select one Style Lock:
   - If the user only asks to list available styles and provides no source content, follow `Style Operations`, output the style list, and stop.
   - Match a style by file name, Chinese title, alias, or obvious semantic description.
   - Use the style explicitly named by the user.
   - If none is named, use `xhs-tech-knowledge`.
   - If multiple styles are plausible and materially different, ask one short clarifying question instead of blending them.
   - If the user provides a visual reference or style description and asks to save it, read `references/style-extraction.md` and create a style file under `styles/`.
   - Use exactly one selected Style Lock for one note unless the user explicitly asks for a hybrid.
3. Normalize the input into one `Page Spec` list:
   - Every page spec must include: page label, page type, page goal, visible text, semantic mapping, and avoid-misread note when relevant.
   - If the user already provided card pages or a page-by-page article, preserve page count, page order, and page intent; only compress or normalize what is needed for image generation.
   - If the user provided a long article without page structure, create one cover claim and 2-7 content pages, with one core claim per page and short visible text only.
   - After Page Spec normalization, do not maintain separate workflows for paged and unpaged inputs. All inputs use the same `cards.md` and `prompts.md` generation steps.
4. Select or confirm a page type for each page from `references/xhs-page-types.md`.
5. Lock the content-to-visual mapping for each page before writing prompts:
   - Identify the page's primary claim.
   - Identify the primary relationship that the visual must show.
   - Identify secondary or side-note concepts that must not become the main visual.
   - Identify forbidden visual metaphors that would distort the source meaning.
   - Do this internally by default; expose it only when the user asks for review or debugging.
6. Build `cards.md` from the Page Spec:
   - Keep the normalized page order and page intent.
   - Preserve the core claim and key terms.
   - Do not silently invent examples, data, brands, or historical claims.
   - Include `发布配文` in `cards.md`.
7. Build `prompts.md` from the same Page Spec:
   - Include selected style name and Style Lock.
   - Include prompt skeleton or style-specific prompt notes.
   - Each page prompt must start with the parameter tag, usually `[3:4, 1K]`.
   - Each page prompt includes the selected Style Lock as a short phrase, not a long repeated paragraph.
   - Each page prompt must use the structured prompt fields in `Page Prompt Format`.
   - The main visual must express the primary relationship, not the most visually convenient list of concepts.
   - Side-note concepts should appear as small notes, corner labels, or secondary callouts, not as equal pillars.
   - If there is a likely misreading, write it explicitly in `避免`.
8. Generate the publish caption:
   - If the user already provided a publish caption, preserve its meaning and lightly tighten it.
   - If no caption is provided, write one from the same claims used in the cards.
   - Do not introduce new facts, examples, dates, product claims, or unsupported conclusions.
9. Internally run `references/prompt-quality-checklist.md` before output. Fix failures silently unless the user asked for a review report.
10. Output the deliverable. By default, include only `cards.md` and `prompts.md` file contents.
11. If the material is a long article without page structure, let `cards.md` contain the generated Page Spec as card copy.
12. If there are obvious factual/time-sensitive risks, add a short `风险提示` in `cards.md`. Do not perform a long fact-check report unless the user asks.

## Style Operations

Use this section when the user asks to list, choose, call, save, rename, or update reusable styles.

### List Styles

If the user asks "有哪些风格", "列出风格", "可用风格", "style list", or similar and does not provide article/card content to process:

- Output only a concise style list and usage examples.
- Do not output `cards.md` or `prompts.md`.
- Do not expose full Style Locks unless the user explicitly asks for details.
- Do not read or summarize maintenance materials such as `test-fixtures/` or `expected/`.

Generate the style list from the current `styles/*.md` files. Do not rely on a hard-coded style table in this file; saved styles may change independently of `SKILL.md`.

Default output shape:

```markdown
## 可用风格

| 风格ID | 别名/关键词 | 适合内容 | 慎用场景 |
| --- | --- | --- | --- |
| {style-file-stem} | {别名 line, compressed} | {from 风格定位 / 默认用途} | {from 风格隔离 / 页型适配 / 负面约束} |

## 调用示例

用 MoreImg 调用 {风格ID}，把这篇文章做成小红书图文卡提示词。
用{别名/关键词}，把这段文案做成 4 页小红书卡片提示词。
```

### Call A Style

When the user names a style:

- Exact file names win over aliases.
- Chinese titles and aliases can match saved style files.
- Semantic matches are allowed when there is only one obvious candidate, such as "法式电商杂志风" -> `xhs-french-editorial-commerce`.
- If a request could mean multiple styles, ask one short clarifying question with the likely candidates.
- After selection, read the selected style file and use its `Style Lock`, prompt notes, negative constraints, and default parameter tag.
- `prompts.md` must name the selected style in `## 使用风格`.
- Do not silently fall back to `xhs-tech-knowledge` when the user named another available style.
- Do not mix multiple Style Locks unless the user explicitly requests a hybrid.

### Save Or Update A Style

When the user asks to save a reference style, update a style, rename a style, or create a reusable style:

- Read and follow `references/style-extraction.md`.
- Save or update a file under `styles/`.
- Do not edit `SKILL.md` just to add a one-off visual preference.
- Do not include one-time article content, page titles, or generated card copy in the style file.

## Content-To-Visual Mapping Rules

Before writing `主视觉`, decide the semantic role of each concept:

```text
主概念：本页最重要的对象
主关系：本页真正要解释的关系
辅助概念：支撑主关系的对象
旁注概念：只用于补充说明，不能和主概念并列
旁注处理：不入图 / 只作文字小注 / 弱化图形旁注
禁止误读：画面绝不能暗示的错误关系
```

Rules:

- Do not promote a side note into the main visual.
- If a side note is only an analogy, "顺便说一下", "容易联想到", or non-core background explanation, default to `不入图`; keep it out of `内容层级` and `视觉锚点`.
- If a side note must stay visible for comprehension, use only a tiny text note with no icon, module, arrow, cloud, server, or node.
- Do not turn concepts from different abstraction levels into equal layers, equal pillars, or a three-part architecture.
- Do not use a "三层关系图", "三栏并列", "架构层级图", or "中心-左右模块" just because there are three nouns in the text.
- If the source says two things are related by analogy, show it as a small comparison note, not as a shared architecture.
- If the source says one concept orchestrates another, the visual should show directionality: orchestrator -> capability units.
- If the source says a concept is a deployment method but the page's primary relationship is not about deployment, do not visualize that deployment concept. If it must be mentioned, make it a tiny text note only.
- Add a clear `避免` clause whenever the page contains concepts that are easy to over-equalize.
- Do not include non-core side-note nouns in `内容层级` as normal bullet points; image models often turn listed nouns into visible objects.

Example:

```text
Source meaning: Workflow 是流程调度者；Skill 是被调度的能力单元；微服务只是部署方式的补充类比。
Correct visual: Workflow 流程骨架调度多个 Skill 能力积木。微服务默认不入图；如必须保留，只能是一行很小的文字旁注，不画云端、服务器、模块或箭头。
Avoid: 把 Workflow、Skill、微服务画成并列三层架构；把微服务画成云端服务模块并接入主关系图。
```

## Page Prompt Format

Use this structured skeleton by default. It is adapted from the visual-style PPT prompt pattern, but tuned for Xiaohongshu image-text cards:

```text
[参数标签] 生成一张小红书图文卡片，页型是「{页型}」，主题是「{主题}」。
画面气质：{Style Lock short phrase}。
排版：{页面结构、标题区、模块区、留白、边距、阅读顺序}。
内容层级：大标题「{标题}」，副标题/提示「{副标题}」，3-5 个短要点包括「{要点1}」「{要点2}」「{要点3}」，总结「{总结}」。
视觉锚点：{主视觉对象与关系表达，必须符合原文概念层级}。
色彩：{主色、辅助色、背景、线条/容器颜色、对比关系}。
避免：{负面约束，尤其是容易误读的概念关系}。
```

Example:

```text
[3:4, 1K] 生成一张小红书图文卡片，页型是「流程页」，主题是「Workflow 的发展脉络」。
画面气质：银灰蓝科技知识卡，细网格纸纹，线框图标，几何黑体，留白充足。
排版：上方强标题区，中部四阶段纵向时间线，底部一句总结，模块间距稳定，手机端可读。
内容层级：大标题「Workflow 的发展脉络」，要点包括「传统软件：流程写在代码里」「自动化工具：拖拽可视化」「云端平台：在线服务」「AI 智能体：执行骨架」，总结「Workflow 一直都在」。
视觉锚点：四阶段纵向时间线，每个阶段一个线框节点图标和一个短信息模块。
色彩：浅灰蓝背景，深海蓝文字与线条，少量青蓝强调，低饱和，高对比。
避免：大段正文、复杂箭头、过多小字、混合 3D 和手绘。
```

Do not use this older pattern by default:

```text
3:4比例，[主色系]，低饱和，字体风格为...
```

The ratio and size belong in the parameter tag, not as ordinary prompt prose.

Do not collapse these fields into one sentence unless the user explicitly asks for ultra-short prompts. The structured fields are part of the generation quality control.

## Publish Caption

Always include `发布配文` by default for Xiaohongshu image-text note prompt packs.

Caption structure:

```text
发布配文

开头钩子：1-2 句，直接点出误区、痛点、反常识或核心观点。

正文：2-4 个短段落，解释卡片主线，语言口语化，适合小红书图文笔记。

记忆句：1 句总结，让读者能带走一个判断。

话题标签：5-8 个，优先复用原文主题词。
```

Rules:

- Use the same conceptual claims as the cards.
- Keep it shorter than the source article.
- Preserve the user's tone when a caption is already provided.
- Hashtags should be relevant and not excessive.
- Do not add fake urgency, fake authority, unverifiable statistics, or dates not present in the source.

## Output Format

Default output is two Markdown file contents:

````markdown
## cards.md

```markdown
# 图文笔记内容

## 页面结构

### 封面页
- 页型：
- 页面目标：
- 入图文字：
- 语义映射：
- 避免误读：

### 内容页1/N
- 页型：
- 页面目标：
- 入图文字：
- 语义映射：
- 避免误读：

## 发布配文
...
```

## prompts.md

```markdown
# 文生图提示词

## 使用风格
...

## Style Lock
...

## 提示词

### 封面页
[3:4, 1K] ...

### 内容页1/N
[3:4, 1K] ...
```
````

Only add these optional sections when needed:

- `风险提示`: inside `cards.md`, when the source contains obvious factual, time-sensitive, or overloaded-text risks.
- `已保存风格`: when the user asks to save a reusable style.

## Style Library

Saved styles live in `styles/`. Each style file must include:

```text
# Style Name

别名：...

## 风格定位

## 视觉 DNA

## Style Lock

## 色彩建议

## 页型适配

## 默认输出参数

## 推荐提示词骨架

## 负面约束

## 质量检查
```

Style files should capture reusable visual DNA:

- color mood
- background and texture
- typography mood
- layout rhythm
- container/border behavior
- text density
- suitable page types
- negative constraints
Optional `Prompt Notes` are allowed when a style needs extra calling guidance, but the reusable prompt schema should live in `推荐提示词骨架`.

When extracting a style from a visual reference, read and follow `references/style-extraction.md`. When revising an existing output, read and follow `references/prompt-revision.md`.

Do not edit `SKILL.md` just to change a visual style. Add or update a style file instead.

## Completion Standard

- The output contains `cards.md` and `prompts.md` file contents unless the user asked for analysis rather than generation.
- Generation output uses one Page Spec pipeline and normally contains both `cards.md` and `prompts.md`.
- `cards.md` contains page structure, page type, visible text, semantic mapping, and publish caption.
- `prompts.md` contains style name, Style Lock, and structured page prompts.
- Every page prompt starts with a parameter tag such as `[3:4, 1K]`.
- One note uses exactly one Style Lock unless the user asks for a hybrid.
- Page prompts use the structured fields: generation target, visual mood, layout, content hierarchy, visual anchor, color, and avoid rules.
- Paged and unpaged inputs must be normalized into the same Page Spec shape before output generation.
- Main visuals preserve the source concept hierarchy and do not upgrade side notes into equal core concepts.
- Existing page structure is preserved unless it is too text-heavy for image generation.
- Long text is compressed into short visible labels.
- Publish caption reuses card claims and does not add new unsupported information.
- No unsupported factual claims are added.

## Common Mistakes

- Do not output visual variable tables by default.
- Do not expose internal workflow stages.
- Do not scatter deliverables across many chat sections; use `cards.md` and `prompts.md`.
- Do not output one-line prompts by default; use the structured prompt skeleton for better image generation.
- Do not repeat an uncontrolled long boilerplate in every page prompt; use the selected Style Lock inside the `画面气质` field.
- Do not put `3:4比例` in the prompt prose when `[3:4, 1K]` can be used.
- Do not let the number of nouns in a paragraph determine the visual structure; follow the source concept hierarchy.
- Do not represent side-note concepts as equal visual pillars.
- Do not re-plan page count or page topics when the user already provided a page-by-page structure; normalize it into Page Spec instead.
- Do not expose a separate planning report for unstructured long articles; put the generated structure directly into `cards.md`.
- Do not ask for confirmation before producing prompts unless page count, style, or ratio is genuinely missing and risky.
- Do not copy PPT packaging, thumbnail-board, or confirmation-gate behavior from slide skills.
- Do not omit `发布配文` when the user is making a Xiaohongshu image-text note.
- Do not depend on Codex-only tools or local files in the final answer; the generated prompt pack should be readable and usable by any agent.
