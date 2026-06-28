# MoreImg Test Fixtures

These files are manual test inputs for MoreImg maintenance. They are not runtime references and should not be added to `SKILL.md` required references.

## Test Matrix

| Fixture | Recommended style | Main risk tested |
| --- | --- | --- |
| `articles/workflow-concept.md` | `xhs-tech-knowledge` | Concept hierarchy: Workflow / Skill / microservice side-note |
| `articles/agent-debug-terminal.md` | `xhs-terminal-tech-magazine` | Technical flow compression and terminal/HUD style isolation |
| `articles/ai-project-decision-report.md` | `xhs-impact-grid-editorial` | Report-style structure without PPT/deck leakage |
| `articles/capsule-wardrobe-commerce.md` | `xhs-french-editorial-commerce` | Lifestyle/editorial-commerce style without technology-card leakage |
| `articles/structured-ai-knowledge-base.md` | `xhs-tech-knowledge` | Long article already has page structure; preserve page count and page intent |
| `articles/unstructured-ai-knowledge-base.md` | `xhs-tech-knowledge` | Long article has no page structure; generate cards, but keep prompt format identical |

## Manual Run Prompts

```text
用 MoreImg 调用 xhs-tech-knowledge，把 test-fixtures/articles/workflow-concept.md 做成 3 页小红书图文卡提示词。
```

```text
用 MoreImg 调用 xhs-terminal-tech-magazine，把 test-fixtures/articles/agent-debug-terminal.md 做成 4 页小红书图文卡提示词。
```

```text
用 MoreImg 调用 xhs-impact-grid-editorial，把 test-fixtures/articles/ai-project-decision-report.md 做成 4 页小红书图文卡提示词。
```

```text
用 MoreImg 调用 xhs-french-editorial-commerce，把 test-fixtures/articles/capsule-wardrobe-commerce.md 做成 4 页小红书图文卡提示词。
```

```text
用 MoreImg 调用 xhs-tech-knowledge，把 test-fixtures/articles/structured-ai-knowledge-base.md 做成 3 页小红书图文卡提示词。
```

```text
用 MoreImg 调用 xhs-tech-knowledge，把 test-fixtures/articles/unstructured-ai-knowledge-base.md 做成 4 页小红书图文卡提示词。
```

## Pass Criteria

- Output contains only `cards.md` and `prompts.md` unless the user explicitly asks for review notes.
- `cards.md` includes `发布配文`.
- Every page prompt starts with `[3:4, 1K]` unless the user explicitly asks otherwise.
- Every page prompt uses the same structured fields: `画面气质`、`排版`、`内容层级`、`视觉锚点`、`色彩`、`避免`.
- One note uses exactly one selected Style Lock.
- Existing page structure is preserved when the source already has pages; page structure is generated only when the source has no pages.
- No Image2, PPTX, HTML, thumbnail board, zip, or generation workflow appears in the output.
- Side-note concepts stay visually weak and do not become equal pillars.

## Expected Outputs

`expected/` stores manual reference outputs for each fixture:

```text
expected/{fixture-name}/cards.md
expected/{fixture-name}/prompts.md
```

Use these files as comparison baselines after editing MoreImg. They are not golden tests that must match byte-for-byte; they define the expected shape, style isolation, concept mapping, and prompt structure.

## Mechanical Check

Run:

```bash
scripts/check-fixtures.sh
```

The script checks file completeness, prompt tag counts, publish captions, selected style names, production-flow term leakage, and the Workflow/Skill/microservice side-note guardrail. It does not judge visual taste or semantic quality beyond these mechanical constraints.
