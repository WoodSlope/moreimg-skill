# MoreImg

Chinese documentation: `README.md`.

MoreImg is a Codex Skill for turning a user-approved topic, Chinese article draft, Xiaohongshu note copy, or paged card copy into reusable, design-style-aware image-text note prompt packs.

It optimizes content into a visual-generation-ready structure instead of inventing a new topic strategy or producing final images.

Default output:

- `cards.md`: card structure, page type, visible text, semantic mapping, avoid-misread notes, and publish caption.
- `prompts.md`: selected style, Style Lock, prompt skeleton, and structured per-page text-to-image prompts.

Fixed pipeline:

```text
topic/article/card copy -> Page Spec -> cards.md + prompts.md
```

MoreImg stops at prompt and caption generation. It does not generate bitmap images, build HTML, assemble PPTX files, create thumbnail boards, or package zip files.

## Design Reference

The pre-generation workflow is inspired by the local `visual-style-ppt-skill` and its public repository:

```text
https://github.com/irenerachel/visual-style-ppt-skill
```

MoreImg adapts these useful ideas:

- reusable style files under `styles/`
- one selected `Style Lock` per output set
- page type selection before prompt writing
- structured prompt fields instead of loose one-line prompts
- style extraction and reusable style saving
- revision flow for partial prompt/card updates
- final quality checklist before output

MoreImg intentionally does not copy the Image2-only generation route, thumbnail-board confirmation gate, image review loop, image-only PPTX assembly, or zip packaging from `visual-style-ppt-skill`.

## Scope

Use MoreImg when the target artifact is a Xiaohongshu-style image-text note prompt pack. Route to an image generation, PPT, or frontend skill when the user asks for actual images, slide decks, HTML, or production files.

## Built-In Styles

- `xhs-tech-knowledge`: light silver-blue technology knowledge cards.
- `xhs-terminal-tech-magazine`: dark terminal/HUD technology cards.
- `xhs-impact-grid-editorial`: institutional report and consulting grid cards.
- `xhs-french-editorial-commerce`: French editorial commerce and lifestyle cards.
- `xhs-warm-photo-editorial`: warm real-photo editorial cards for AI tool notes and lifestyle-like knowledge posts.

## Common Usage

List available styles:

```text
用 MoreImg 列出可用风格。
```

Call a style by file name:

```text
用 MoreImg 调用 xhs-terminal-tech-magazine，把这篇文章做成小红书图文卡提示词。
```

Call a style by Chinese alias:

```text
用法式电商杂志风，把这段文案做成 4 页小红书卡片提示词。
```

Call the warm real-photo editorial style:

```text
用暖调真实摄影杂志风，把这篇 AI 工具心得做成小红书图文卡提示词。
```

Default output remains `cards.md` plus `prompts.md`; listing styles is the main exception and returns only a concise style list.

## Output Examples

Each example includes one source article plus the generated `cards.md` and `prompts.md` pair:

| Scenario | Source Article | cards.md | prompts.md |
| --- | --- | --- | --- |
| Workflow / Skill concept relationship | [workflow-concept.md](test-fixtures/articles/workflow-concept.md) | [cards.md](test-fixtures/expected/workflow-concept/cards.md) | [prompts.md](test-fixtures/expected/workflow-concept/prompts.md) |
| Terminal tech magazine debugging note | [agent-debug-terminal.md](test-fixtures/articles/agent-debug-terminal.md) | [cards.md](test-fixtures/expected/agent-debug-terminal/cards.md) | [prompts.md](test-fixtures/expected/agent-debug-terminal/prompts.md) |
| French editorial commerce capsule wardrobe | [capsule-wardrobe-commerce.md](test-fixtures/articles/capsule-wardrobe-commerce.md) | [cards.md](test-fixtures/expected/capsule-wardrobe-commerce/cards.md) | [prompts.md](test-fixtures/expected/capsule-wardrobe-commerce/prompts.md) |

More complete baselines live under `test-fixtures/expected/`.

## Repository Layout

- `.gitignore`: local ignore rules for system files, editor files, temporary files, logs, and generated artifacts.
- `SKILL.md`: runtime instructions and the fixed MoreImg workflow.
- `README.md`: Chinese user-facing documentation and GitHub default landing page.
- `README_EN.md`: English documentation.
- `README_CN.md`: Chinese documentation mirror for compatibility.
- `CONTRIBUTING.md`: contribution rules for workflow changes, fixtures, style files, and open-source maintenance.
- `RELEASE_CHECKLIST.md`: publishing checklist for open-source release hygiene and validation.
- `RELEASE_NOTES.md`: initial release notes and validation summary.
- `references/`: runtime reference files plus `regression-tests.md` for maintenance pressure scenarios.
- `styles/`: reusable visual style files. New built-in styles should follow the same section schema as existing files.
- `test-fixtures/`: reusable source articles and manual expected outputs for regression review.
- `scripts/check-fixtures.sh`: lightweight mechanical checks over runtime rules, style files, fixtures, and expected outputs.
- `agents/openai.yaml`: optional OpenAI/Codex agent metadata; the core skill does not depend on it.

Maintenance files are not required runtime references. Keep `test-fixtures/`, `expected/`, and `references/regression-tests.md` out of `SKILL.md` runtime routes unless a future change truly needs them during normal prompt generation.

Paged/unpaged long-article fixtures protect the single Page Spec pipeline: preserve existing page structures, generate pages only when missing, and keep the final prompt skeleton identical.

## License

MoreImg is released under the MIT License. See `LICENSE`.

The referenced `visual-style-ppt-skill` repository describes itself as a personal skill repository and recommends adding a formal open source license if it is later publicly distributed, used for external contribution, or reused as a template. Checked against the public README on 2026-06-28. This README records design inspiration and workflow boundaries; it is not a license grant for that repository.
