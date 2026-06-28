# MoreImg Release Checklist

Use this checklist before publishing MoreImg as an open-source repository.

## Runtime Contract

- `SKILL.md` has a clear `Goal` section.
- The fixed pipeline is intact: `topic/article/card copy -> Page Spec -> cards.md + prompts.md`.
- Default output remains `cards.md` plus `prompts.md`.
- `cards.md` includes `发布配文` for Xiaohongshu image-text note prompt packs.
- MoreImg stops at prompt and caption generation.
- The release does not add bitmap generation, PPT, HTML, thumbnail-board, zip packaging, or deck assembly workflows.

## Open Source Metadata

- `LICENSE` exists and uses the MIT License.
- `CONTRIBUTING.md` exists and documents contribution rules.
- `README_CN.md` exists and explains the user-facing workflow in Chinese.
- `RELEASE_NOTES.md` exists and summarizes the initial release.
- `README.md` explains the design reference to `visual-style-ppt-skill` and makes clear that MoreImg does not copy its production workflow.
- `README.md` lists the repository layout, including `.gitignore` and `RELEASE_CHECKLIST.md`.

## File Hygiene

- No temporary, backup, editor, log, build, or zip artifacts are included.
- No empty directories are included.
- No personal absolute home-directory paths or local Codex workspace paths are included in release-facing docs.
- No secrets, API keys, auth tokens, private credentials, or local service URLs are included.
- `test-fixtures/`, `styles/`, `references/`, and `agents/openai.yaml` are intentionally kept.

## Validation

Run:

```bash
scripts/check-fixtures.sh
```

Optional local hygiene checks:

```bash
find . -type f | sort
find . -type d -empty -print
rg -n '(/U[s]ers/|/home/|[.]codex|api[_-]?key|auth[_-]?token|access[_-]?token|secret|bearer)' . --glob '!RELEASE_CHECKLIST.md'
```

The fixture script checks mechanical guardrails. It does not replace human review of semantic accuracy, visual taste, source attribution, or whether a new runtime rule belongs in `SKILL.md`.
