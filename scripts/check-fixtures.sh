#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

EXPECTED_DIR="$ROOT/test-fixtures/expected"
ARTICLES_DIR="$ROOT/test-fixtures/articles"
STYLES_DIR="$ROOT/styles"
SKILL_FILE="$ROOT/SKILL.md"
AGENT_FILE="$ROOT/agents/openai.yaml"
LICENSE_FILE="$ROOT/LICENSE"
CONTRIBUTING_FILE="$ROOT/CONTRIBUTING.md"
GITIGNORE_FILE="$ROOT/.gitignore"
RELEASE_CHECKLIST_FILE="$ROOT/RELEASE_CHECKLIST.md"
README_CN_FILE="$ROOT/README_CN.md"
README_EN_FILE="$ROOT/README_EN.md"
RELEASE_NOTES_FILE="$ROOT/RELEASE_NOTES.md"

errors=()

fail() {
  errors+=("$1")
}

require_file() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    fail "Missing file: $path"
  fi
}

require_contains() {
  local path="$1"
  local pattern="$2"
  local label="$3"
  if ! grep -Eq "$pattern" "$path"; then
    fail "$label not found in $path"
  fi
}

require_not_contains() {
  local path="$1"
  local pattern="$2"
  local label="$3"
  if grep -Eq "$pattern" "$path"; then
    fail "$label found in $path"
  fi
}

count_matches() {
  local path="$1"
  local pattern="$2"
  grep -Ec "$pattern" "$path" || true
}

production_terms='Image2|Image 2|PPTX|HTML|thumbnail|zip|deck|PPT|组装|打包|生成图片'

require_file "$SKILL_FILE"
require_file "$AGENT_FILE"
require_file "$LICENSE_FILE"
require_file "$CONTRIBUTING_FILE"
require_file "$GITIGNORE_FILE"
require_file "$RELEASE_CHECKLIST_FILE"
require_file "$README_CN_FILE"
require_file "$README_EN_FILE"
require_file "$RELEASE_NOTES_FILE"
require_file "$ROOT/assets/readme/prompt-card-example-0.png"
require_file "$ROOT/assets/readme/prompt-card-example-1.png"
require_file "$ROOT/assets/readme/prompt-card-example-2.png"
require_file "$ROOT/assets/readme/prompt-card-example-3.png"
require_file "$EXPECTED_DIR/README.md"
require_file "$ROOT/references/prompt-quality-checklist.md"

require_contains "$LICENSE_FILE" '^MIT License$' "MIT license title"
require_contains "$LICENSE_FILE" 'Copyright \(c\) 2026 MoreImg contributors' "license copyright holder"
require_contains "$ROOT/README.md" 'English documentation: `README_EN\.md`' "README English switch"
require_contains "$ROOT/README.md" 'MoreImg 是一个 Codex Skill' "README Chinese default"
require_contains "$ROOT/README.md" 'MoreImg 使用 MIT License' "README license section"
require_contains "$CONTRIBUTING_FILE" 'topic/article/card copy -> Page Spec -> cards\.md \+ prompts\.md' "contributing fixed pipeline"
require_contains "$CONTRIBUTING_FILE" 'Default output is `cards\.md` plus `prompts\.md`' "contributing default output"
require_contains "$CONTRIBUTING_FILE" '`cards\.md` includes `发布配文`' "contributing publish caption rule"
require_contains "$CONTRIBUTING_FILE" 'Maintenance materials are not runtime references' "contributing runtime reference boundary"
require_contains "$CONTRIBUTING_FILE" 'Do not add prompts-only branches' "contributing prompts-only guardrail"
require_contains "$CONTRIBUTING_FILE" 'scripts/check-fixtures\.sh' "contributing check command"
require_contains "$ROOT/README.md" 'CONTRIBUTING\.md' "README contributing file"
require_contains "$ROOT/README.md" 'RELEASE_CHECKLIST\.md' "README release checklist file"
require_contains "$ROOT/README.md" '\.gitignore' "README gitignore file"
require_contains "$ROOT/README.md" 'README_CN\.md' "README Chinese doc file"
require_contains "$ROOT/README.md" 'README_EN\.md' "README English doc file"
require_contains "$ROOT/README.md" 'RELEASE_NOTES\.md' "README release notes file"
require_contains "$ROOT/README.md" '^## 输出示例$' "README output examples section"
require_contains "$ROOT/README.md" 'test-fixtures/expected/workflow-concept/cards\.md' "README workflow cards example"
require_contains "$ROOT/README.md" 'test-fixtures/expected/agent-debug-terminal/prompts\.md' "README terminal prompts example"
require_contains "$ROOT/README.md" 'test-fixtures/expected/capsule-wardrobe-commerce/cards\.md' "README commerce cards example"
require_contains "$ROOT/README.md" '^## 图文卡提示词生成示例$' "README visual example section"
require_contains "$ROOT/README.md" 'assets/readme/prompt-card-example-0\.png' "README visual example 0"
require_contains "$ROOT/README.md" 'assets/readme/prompt-card-example-3\.png' "README visual example 3"
require_contains "$README_CN_FILE" 'topic/article/card copy -> Page Spec -> cards\.md \+ prompts\.md' "Chinese README fixed pipeline"
require_contains "$README_CN_FILE" '默认输出始终是 `cards\.md` 加 `prompts\.md`' "Chinese README default output"
require_contains "$README_CN_FILE" '不生成位图图片，不制作 HTML，不组装 PPTX' "Chinese README production boundary"
require_contains "$README_CN_FILE" '发布前运行' "Chinese README release check"
require_contains "$README_CN_FILE" 'MIT License' "Chinese README license"
require_contains "$README_CN_FILE" 'RELEASE_NOTES\.md' "Chinese README release notes"
require_contains "$README_CN_FILE" '^## 输出示例$' "Chinese README output examples section"
require_contains "$README_CN_FILE" 'test-fixtures/expected/workflow-concept/prompts\.md' "Chinese README workflow prompts example"
require_contains "$README_CN_FILE" '^## 图文卡提示词生成示例$' "Chinese README visual example section"
require_contains "$README_CN_FILE" 'assets/readme/prompt-card-example-0\.png' "Chinese README visual example 0"
require_contains "$README_EN_FILE" 'Chinese documentation: `README\.md`' "English README Chinese switch"
require_contains "$README_EN_FILE" 'MoreImg is a Codex Skill' "English README content"
require_contains "$README_EN_FILE" 'MoreImg is released under the MIT License' "English README license"
require_contains "$README_EN_FILE" '^## Output Examples$' "English README output examples section"
require_contains "$README_EN_FILE" 'test-fixtures/expected/workflow-concept/cards\.md' "English README workflow cards example"
require_contains "$GITIGNORE_FILE" '^\.DS_Store$' "gitignore system file"
require_contains "$GITIGNORE_FILE" '^\.vscode/$' "gitignore editor directory"
require_contains "$GITIGNORE_FILE" '^\*\.tmp$' "gitignore temporary files"
require_contains "$GITIGNORE_FILE" '^\*\.bak$' "gitignore backup files"
require_contains "$GITIGNORE_FILE" '^\*\.log$' "gitignore log files"
require_contains "$GITIGNORE_FILE" '^\*\.zip$' "gitignore zip files"
require_contains "$RELEASE_CHECKLIST_FILE" 'topic/article/card copy -> Page Spec -> cards\.md \+ prompts\.md' "release checklist fixed pipeline"
require_contains "$RELEASE_CHECKLIST_FILE" 'MIT License' "release checklist MIT"
require_contains "$RELEASE_CHECKLIST_FILE" 'CONTRIBUTING\.md' "release checklist contributing"
require_contains "$RELEASE_CHECKLIST_FILE" 'README\.md` is Chinese-first' "release checklist Chinese default README"
require_contains "$RELEASE_CHECKLIST_FILE" 'README_EN\.md' "release checklist English README"
require_contains "$RELEASE_CHECKLIST_FILE" 'README_CN\.md' "release checklist Chinese README"
require_contains "$RELEASE_CHECKLIST_FILE" 'RELEASE_NOTES\.md' "release checklist release notes"
require_contains "$RELEASE_CHECKLIST_FILE" 'scripts/check-fixtures\.sh' "release checklist check command"
require_contains "$RELEASE_CHECKLIST_FILE" 'No temporary, backup, editor, log, build, or zip artifacts are included' "release checklist file hygiene"
require_contains "$RELEASE_CHECKLIST_FILE" 'does not add bitmap generation, PPT, HTML, thumbnail-board, zip packaging, or deck assembly workflows' "release checklist production boundary"
require_contains "$RELEASE_NOTES_FILE" 'Initial Open-Source Release' "release notes title"
require_contains "$RELEASE_NOTES_FILE" 'topic/article/card copy -> Page Spec -> cards\.md \+ prompts\.md' "release notes fixed pipeline"
require_contains "$RELEASE_NOTES_FILE" 'scripts/check-fixtures\.sh' "release notes validation"

require_contains "$SKILL_FILE" '^## Goal$' "goal section"
require_contains "$SKILL_FILE" 'user-approved topic, article draft, long-form note, or paged Xiaohongshu card copy' "goal input scope"
require_contains "$SKILL_FILE" 'design-style-aware text-to-image prompt pack' "goal output scope"
require_contains "$SKILL_FILE" 'not to invent a new topic strategy or produce final images' "goal boundary"
require_contains "$SKILL_FILE" 'topic/article/card copy -> Page Spec -> `cards\.md` \+ `prompts\.md`' "goal pipeline"
require_contains "$SKILL_FILE" 'input -> Page Spec -> `cards\.md` -> `prompts\.md`' "single pipeline optimization direction"
require_contains "$SKILL_FILE" 'stable, repeatable prompt-pack generation' "stable optimization target"
require_contains "$SKILL_FILE" 'provided card pages or a page-by-page article, preserve page count, page order, and page intent' "structured input preservation rule"
require_contains "$SKILL_FILE" 'long article without page structure, create one cover claim and 2-4 content pages' "unstructured input normalization rule"
require_contains "$SKILL_FILE" 'do not maintain separate workflows for paged and unpaged inputs' "single Page Spec pipeline rule"
require_contains "$SKILL_FILE" '^## Runtime References$' "runtime references section"
require_contains "$SKILL_FILE" 'Read only the references needed for the current route' "route-scoped reference rule"
require_contains "$SKILL_FILE" 'Generate the style list from the current `styles/\*\.md` files' "dynamic style list rule"
require_contains "$SKILL_FILE" '3-5 个短要点包括' "3-5 prompt skeleton wording"

runtime_refs="$(awk '/^## Runtime References/{flag=1; next} /^## Default Behavior/{flag=0} flag {print}' "$SKILL_FILE")"
runtime_positive_refs="$(printf '%s\n' "$runtime_refs" | grep -Ev 'Do not read|maintenance materials' || true)"
if printf '%s\n' "$runtime_positive_refs" | grep -Eq 'test-fixtures|expected/|regression-tests\.md|workflow-concept|agent-debug-terminal|ai-project-decision-report|capsule-wardrobe-commerce'; then
  fail "maintenance material found in SKILL.md Runtime References"
fi
require_contains "$SKILL_FILE" 'Do not read or summarize maintenance materials' "maintenance-material negative rule"
standard_refs="$(awk '/^For standard article\/card-to-prompt generation:/{flag=1; next} /^For conditional routes:/{flag=0} flag {print}' "$SKILL_FILE")"
if printf '%s\n' "$standard_refs" | grep -Eq 'style-extraction|prompt-revision|regression-tests'; then
  fail "conditional reference found in standard generation route"
fi
require_not_contains "$AGENT_FILE" 'suitability|self-check|visual system|PPTX|HTML|thumbnail|zip|deck' "old default prompt wording"

style_count="$(find "$STYLES_DIR" -maxdepth 1 -type f -name '*.md' | wc -l | tr -d '[:space:]')"
if [[ "$style_count" -lt 5 ]]; then
  fail "Expected at least 5 style files, found $style_count"
fi

for style in \
  xhs-tech-knowledge \
  xhs-terminal-tech-magazine \
  xhs-impact-grid-editorial \
  xhs-french-editorial-commerce \
  xhs-warm-photo-editorial
do
  style_file="$STYLES_DIR/$style.md"
  require_file "$style_file"
  if [[ -f "$style_file" ]]; then
    require_contains "$style_file" '^## Style Lock$' "Style Lock section"
    require_contains "$style_file" '默认参数标签：`\[3:4, 1K\]`' "default parameter tag"
    require_contains "$style_file" '默认比例：3:4' "default ratio"
    require_contains "$style_file" '^\[3:4, 1K\]' "prompt skeleton parameter tag"
    require_not_contains "$style_file" '16:9|2K|PPTX|HTML|thumbnail|zip|deck|PPT' "production or slide workflow term"
  fi
done

while IFS='|' read -r fixture expected_pages style article; do
  [[ -z "$fixture" ]] && continue

  article_file="$ARTICLES_DIR/$article"
  cards_file="$EXPECTED_DIR/$fixture/cards.md"
  prompts_file="$EXPECTED_DIR/$fixture/prompts.md"

  require_file "$article_file"
  require_file "$cards_file"
  require_file "$prompts_file"

  if [[ -f "$cards_file" ]]; then
    require_contains "$cards_file" '^# 图文笔记内容$' "cards title"
    require_contains "$cards_file" '^## 页面结构$' "page structure section"
    require_contains "$cards_file" '^### 封面页$' "cover page"
    require_contains "$cards_file" '^## 发布配文$' "publish caption"
    require_not_contains "$cards_file" "$production_terms" "production workflow term"
  fi

  if [[ -f "$prompts_file" ]]; then
    require_contains "$prompts_file" '^# 文生图提示词$' "prompts title"
    require_contains "$prompts_file" '^## 使用风格$' "style section"
    require_contains "$prompts_file" "$style" "selected style"
    require_contains "$prompts_file" '^## Style Lock$' "Style Lock section"
    require_contains "$prompts_file" '^## 提示词$' "prompts section"
    require_not_contains "$prompts_file" "$production_terms" "production workflow term"
    require_not_contains "$prompts_file" '3:4比例|suitability|self-check|visual system' "old output wording"

    actual_pages="$(count_matches "$prompts_file" '^\[3:4, 1K\]')"
    if [[ "$actual_pages" != "$expected_pages" ]]; then
      fail "$fixture expected $expected_pages prompt tags, found $actual_pages"
    fi

    for field in '画面气质' '排版' '内容层级' '视觉锚点' '色彩' '避免'; do
      field_count="$(count_matches "$prompts_file" "^${field}：")"
      if [[ "$field_count" != "$expected_pages" ]]; then
        fail "$fixture expected $expected_pages ${field} fields, found $field_count"
      fi
    done
  fi
done <<'EOF'
workflow-concept|3|xhs-tech-knowledge|workflow-concept.md
agent-debug-terminal|4|xhs-terminal-tech-magazine|agent-debug-terminal.md
ai-project-decision-report|4|xhs-impact-grid-editorial|ai-project-decision-report.md
capsule-wardrobe-commerce|4|xhs-french-editorial-commerce|capsule-wardrobe-commerce.md
structured-ai-knowledge-base|3|xhs-tech-knowledge|structured-ai-knowledge-base.md
unstructured-ai-knowledge-base|4|xhs-tech-knowledge|unstructured-ai-knowledge-base.md
EOF

workflow_cards="$EXPECTED_DIR/workflow-concept/cards.md"
workflow_prompts="$EXPECTED_DIR/workflow-concept/prompts.md"
if [[ -f "$workflow_cards" && -f "$workflow_prompts" ]]; then
  require_contains "$workflow_cards" 'Workflow 流程骨架.*Skill 能力积木' "Workflow-to-Skill semantic mapping"
  require_contains "$workflow_cards" '微服务.*不进入.*主视觉' "microservice excluded from main visual"
  require_contains "$workflow_prompts" '微服务.*不进入视觉锚点' "microservice excluded from visual anchor"
  require_contains "$workflow_prompts" '不要出现云端服务模块' "microservice cloud-module avoid clause"
  require_not_contains "$workflow_prompts" '微服务：管部署' "microservice as normal visual bullet"
fi

if (( ${#errors[@]} > 0 )); then
  echo "MoreImg fixture check failed:"
  printf -- '- %s\n' "${errors[@]}"
  exit 1
fi

echo "MoreImg fixture check passed"
