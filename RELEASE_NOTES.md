# Release Notes

## Initial Open-Source Release

MoreImg turns a user-approved topic, Chinese article draft, Xiaohongshu note copy, or paged card copy into a design-style-aware Xiaohongshu image-text note prompt pack.

Default output:

- `cards.md`: card structure, page type, visible text, semantic mapping, avoid-misread notes, and publish caption.
- `prompts.md`: selected style, Style Lock, prompt skeleton, and structured per-page text-to-image prompts.

Core workflow:

```text
topic/article/card copy -> Page Spec -> cards.md + prompts.md
```

Included in this release:

- Runtime skill instructions in `SKILL.md`.
- Five built-in Xiaohongshu visual styles under `styles/`.
- Runtime references for page types, prompt quality, prompt revision, and style extraction.
- Regression scenarios, source fixtures, and expected outputs for maintenance.
- Local validation script: `scripts/check-fixtures.sh`.
- MIT License, contribution rules, release checklist, English README, and Chinese README.

Known boundary:

MoreImg stops at prompt and publish-caption generation. It does not generate bitmap images, build HTML, assemble PPTX files, create thumbnail boards, or package zip files.

Validation:

```bash
scripts/check-fixtures.sh
```
