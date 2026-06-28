# Contributing to MoreImg

MoreImg is optimized for one stable job:

```text
topic/article/card copy -> Page Spec -> cards.md + prompts.md
```

Contributions should strengthen that path. Do not add features that turn MoreImg into an image generator, PPT builder, HTML generator, thumbnail-board workflow, or zip packager.

## Before Changing Runtime Behavior

Runtime behavior includes trigger conditions, routing, required references, workflow steps, output format, style selection, prompt structure, and completion rules.

Before changing runtime behavior:

1. Add or update a pressure scenario in `references/regression-tests.md`.
2. Add or update a fixture in `test-fixtures/articles/` when the change affects input handling.
3. Add or update expected outputs under `test-fixtures/expected/{fixture}/` when the change affects `cards.md` or `prompts.md`.
4. Update `scripts/check-fixtures.sh` for mechanical rules that can be checked reliably.
5. Run `scripts/check-fixtures.sh`.

Do not publish a workflow change based only on reading the skill and deciding it looks clear.

## Runtime Boundaries

Keep these rules intact unless there is a deliberate design decision and matching regression coverage:

- Default output is `cards.md` plus `prompts.md`.
- `cards.md` is the semantic source of truth.
- `prompts.md` is the execution prompt pack.
- `cards.md` includes `发布配文` for Xiaohongshu image-text note prompt packs.
- All article, long-note, and paged-card inputs normalize into one `Page Spec` shape before output.
- Paged inputs preserve page count, page order, and page intent unless the content is too text-heavy for image generation.
- Unpaged long articles generate a concise card structure but use the same final prompt skeleton.
- One note uses exactly one Style Lock unless the user explicitly asks for a hybrid.
- Maintenance materials are not runtime references.

## Runtime References

Keep `SKILL.md` route-scoped:

- Standard generation may read `references/xhs-page-types.md`, `references/prompt-quality-checklist.md`, and exactly one selected style file.
- Revision may read `references/prompt-revision.md`.
- Style saving or extraction may read `references/style-extraction.md`.
- Normal use should not read `test-fixtures/`, `expected/`, or `references/regression-tests.md`.

Only add a new runtime reference when it changes behavior in a reusable way. Put tests, examples, and maintenance notes outside runtime routes.

## Style Files

Reusable styles live in `styles/`. New built-in styles should include:

```text
# Style Name

别名：...

## 风格定位

## 视觉 DNA

## Style Lock

## 色彩建议

## 页型适配

## 图片构图规则

## 默认输出参数

## 排版规则

## 信息密度

## 推荐提示词骨架

## 负面约束

## 质量检查
```

Optional `Prompt Notes` are fine when a style needs extra calling guidance, but the reusable prompt schema should remain in `推荐提示词骨架`.

Do not put one-time article content, exact reference-image text, watermarks, account names, page numbers, or generated card copy into a style file.

## Prompt-Pack Quality

A valid MoreImg output keeps:

- two Markdown file contents only, unless the user asked for analysis or a style list
- page type, page goal, visible text, semantic mapping, and avoid-misread notes in `cards.md`
- selected style, Style Lock, and structured per-page prompts in `prompts.md`
- one parameter tag such as `[3:4, 1K]` at the start of every page prompt
- fields for `画面气质`, `排版`, `内容层级`, `视觉锚点`, `色彩`, and `避免`
- short visible text instead of long article paragraphs
- source concept hierarchy, especially for side-note concepts that should not become equal visual pillars

## What Not To Optimize

Do not add prompts-only branches just to reduce a small amount of output text. Users can copy the portion they need; the stable two-file output is more important than shaving minor token cost.

Do not split paged and unpaged sources into different final workflows. The preprocessing can differ, but the final `cards.md` and `prompts.md` structure should stay the same.

Do not add confirmation gates, thumbnail boards, image review loops, PPT assembly, HTML export, or package generation to this skill.

## Checks

Run:

```bash
scripts/check-fixtures.sh
```

The script checks mechanical guardrails. It does not replace human review of semantic accuracy, visual taste, or whether a new rule belongs in the runtime path.
