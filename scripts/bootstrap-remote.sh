#!/usr/bin/env bash
# 一键：创建 GitHub 公开仓库 → 启用 Issues/Projects → 推送 → 标签 → 种子 Issue
# 用法（在本仓库根目录、Git Bash 中执行）：
#   bash scripts/bootstrap-remote.sh
# 可选：ENABLE_BRANCH_PROTECTION=1 bash scripts/bootstrap-remote.sh
#
# 前置条件：已安装 GitHub CLI（https://cli.github.com/）并运行过 gh auth login
set -euo pipefail

REPO_NAME="ai-personal-profile"
REPO_DESC="跨 AI 工具共享的个人上下文档案（可版本化、可追溯）"

# ---------- 0. 前置检查 ----------
# Windows 安装包常把 gh.exe 放在 Program Files，却不一定写入 Git Bash 的 PATH
if ! command -v gh >/dev/null 2>&1; then
  for candidate in "/c/Program Files/GitHub CLI/gh.exe" \
                   "/c/Users/${USER:-Dell}/AppData/Local/Programs/GitHub CLI/gh.exe"; do
    if [ -x "$candidate" ]; then
      export PATH="$(dirname "$candidate"):$PATH"
      echo "· 已从 $(dirname "$candidate") 载入 gh"
      break
    fi
  done
fi
if ! command -v gh >/dev/null 2>&1; then
  echo "× 未找到 gh CLI。请先安装 GitHub CLI：https://cli.github.com/" >&2
  exit 1
fi
if ! gh auth status >/dev/null 2>&1; then
  echo "× gh 尚未登录。请先执行：gh auth login" >&2
  exit 1
fi
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "× 当前目录不是 Git 仓库，请先在本仓库根目录执行。" >&2
  exit 1
fi
cd "$(git rev-parse --show-toplevel)"

OWNER="$(gh api user -q .login)"
echo "GitHub 账户: $OWNER"

if [ -z "$(git config user.email || true)" ]; then
  echo "⚠ 本机尚未配置 Git 身份，提交可能不关联到你的账号。建议先执行："
  echo "    git config user.name \"$OWNER\""
  echo "    git config user.email \"$OWNER@users.noreply.github.com\""
  echo "    git commit --amend --reset-author --no-edit"
fi

# ---------- 1. 把文档里的 <OWNER> 占位替换成真实用户名 ----------
mapfile -t OWNER_FILES < <(grep -rl '<OWNER>' --include='*.md' . || true)
if [ "${#OWNER_FILES[@]}" -gt 0 ]; then
  for f in "${OWNER_FILES[@]}"; do
    sed -i "s|<OWNER>|$OWNER|g" "$f"
  done
  git add "${OWNER_FILES[@]}"
  git commit --amend --no-edit >/dev/null
  git tag -fa v0.1.0 -m "初始版本：仓库骨架与六章节档案结构" >/dev/null 2>&1 || true
  echo "✓ 已将 ${#OWNER_FILES[@]} 个文件中的 <OWNER> 替换为 $OWNER"
fi

# ---------- 1.5 保证 v0.1.0 指向当前提交 ----------
# 若用户已 --amend 修正过作者，标签会停留在旧提交上，需同步后再推送
if git rev-parse -q --verify "refs/tags/v0.1.0" >/dev/null 2>&1; then
  if [ "$(git rev-list -n 1 v0.1.0)" != "$(git rev-parse HEAD)" ]; then
    git -c user.name="$(git config user.name || echo 'Profile Maintainer')" \
        -c user.email="$(git config user.email || echo 'profile@localhost')" \
        tag -fa v0.1.0 -m "初始版本：仓库骨架与六章节档案结构" >/dev/null
    echo "✓ 已将 v0.1.0 标签同步到当前提交"
  fi
fi

# ---------- 2. 创建远程仓库并推送 ----------
BRANCH="$(git branch --show-current)"
if gh repo view "$OWNER/$REPO_NAME" >/dev/null 2>&1; then
  echo "✓ 仓库已存在，跳过创建，改为同步远程"
  if git remote get-url origin >/dev/null 2>&1; then
    git remote set-url origin "https://github.com/$OWNER/$REPO_NAME.git"
  else
    git remote add origin "https://github.com/$OWNER/$REPO_NAME.git"
  fi
  git push -u origin "$BRANCH"
else
  gh repo create "$REPO_NAME" \
    --public \
    --description "$REPO_DESC" \
    --source=. \
    --remote=origin \
    --push
  echo "✓ 公开仓库已创建并推送"
fi
git push origin --tags

# ---------- 3. 开启 Issues / Projects ----------
if gh api -X PATCH "repos/$OWNER/$REPO_NAME" \
  -F has_issues=true -F has_projects=true -F has_wiki=false >/dev/null 2>&1; then
  echo "✓ Issues 已开启、Projects 已启用（Wiki 已关闭）"
else
  echo "· 仓库设置中部分字段不可用（classic Projects 下线属正常），Issues 默认开启；继续后续步骤"
fi

# ---------- 4. 标签 ----------
bash scripts/setup-labels.sh

# ---------- 5. 种子 Issue（幂等：同名已存在则跳过） ----------
create_issue() {
  local title="$1"; shift
  if gh issue list --state all --search "\"$title\" in:title" --json title -q '.[].title' 2>/dev/null | grep -Fxq "$title"; then
    echo "  跳过（已存在）: $title"
    return
  fi
  gh issue create --title "$title" "$@" >/dev/null
  echo "  已创建: $title"
}

echo "创建种子待办..."
create_issue "填充六章节真实内容" \
  --label "profile/fill" --label "priority/high" --label "area/readme" \
  --body "$(cat <<'EOF'
逐章替换 README.md 中的 `[示例]` 占位条目，删除标记，并在 CHANGELOG.md 记录本次填充。

参考模板：`.github/ISSUE_TEMPLATE/01-profile-item.md`

**完成标准**
- [ ] 六个章节均已填入真实内容
- [ ] 隐私自查通过（见 docs/隐私与合规提示.md）
- [ ] CHANGELOG.md 已记录、已打新 tag
EOF
)"

create_issue "在 3 个 AI 客户端中接入 RAW 地址并验证" \
  --label "ai/sync" --label "priority/high" \
  --body "$(cat <<'EOF'
把 README.md 的 RAW 地址接入至少 3 个 AI 客户端 / Agent，验证其行为符合档案中的偏好。

**完成标准**
- [ ] 每个工具能复述「沟通风格偏好」中至少 2 条
- [ ] 输出形式符合档案写明的结构化要求
- [ ] 各端读取的版本号与 CHANGELOG / tag 一致
EOF
)"

create_issue "季度复审：删除过期条目" \
  --label "profile/review" --label "priority/low" --label "area/readme" \
  --body "$(cat <<'EOF'
每季度复审一次档案，删除或修正过期条目，并在 CHANGELOG.md 写明原因。

**检查项**
- [ ] 工具与技术栈是否仍在使用
- [ ] 项目成果与目标是否需要更新
- [ ] 是否存在不该公开的内容
- [ ] 是否已打新 tag 并同步各 AI 端
EOF
)"

# ---------- 6. Projects 看板（需 project 权限，失败不阻断） ----------
if gh project create --owner "$OWNER" --title "AI 个人档案 · 待办看板" >/dev/null 2>&1; then
  echo "✓ Projects 看板已创建；字段与视图请按 .github/PROJECT_SETUP.md 配置"
else
  echo "· Projects 看板未自动创建（多为 gh 缺少 project 权限），请按 .github/PROJECT_SETUP.md 网页端创建"
fi

# ---------- 7. 分支保护（默认关闭，显式开启才执行） ----------
if [ "${ENABLE_BRANCH_PROTECTION:-0}" = "1" ]; then
  PAYLOAD='{"required_status_checks":null,"enforce_admins":false,"required_pull_request_reviews":{"required_approving_review_count":0},"restrictions":null}'
  if gh api -X PUT "repos/$OWNER/$REPO_NAME/branches/$BRANCH/protection" --input - <<< "$PAYLOAD" >/dev/null 2>&1; then
    echo "✓ 已为 $BRANCH 开启分支保护（需通过 PR 合并）"
  else
    echo "· 分支保护未设置成功，请在 Settings → Branches 手工配置"
  fi
fi

# ---------- 8. 输出 ----------
REPO_URL="$(gh repo view --json url -q .url)"
echo ""
echo "================ 完成 ================"
echo "仓库地址 : $REPO_URL"
echo "Issues   : $REPO_URL/issues"
echo "RAW 地址 : https://raw.githubusercontent.com/$OWNER/$REPO_NAME/$BRANCH/README.md"
echo "变更记录 : $REPO_URL/blob/$BRANCH/CHANGELOG.md"
echo ""
echo "下一步："
echo "  1. 按 README 六章节填充真实内容（注意公开仓库隐私边界）"
echo "  2. 每次修改提交并同步 CHANGELOG.md，阶段性打 tag：git tag -a v0.2.0 -m \"...\""
echo "  3. 按 .github/PROJECT_SETUP.md 完善看板字段与视图"
echo "======================================"
