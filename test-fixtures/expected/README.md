# Expected Outputs

These expected outputs are manual regression references for MoreImg. They are not runtime references.

Each fixture has:

- `cards.md`: expected card package and publish caption
- `prompts.md`: expected selected style, Style Lock, and page prompts

Use them to compare whether a future MoreImg change preserves:

- two-file output shape
- selected style isolation
- `[3:4, 1K]` parameter tags
- concise visible text
- concept hierarchy and side-note handling
- no image generation, PPT, HTML, thumbnail board, or packaging workflow
