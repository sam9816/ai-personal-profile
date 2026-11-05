#!/usr/bin/env bash
# 创建 / 更新本仓库的待办跟踪标签（幂等，可重复执行）
# 前置：已安装并登录 gh CLI，且当前目录已关联 GitHub 远程仓库
set -euo pipefail

if ! command -v gh >/dev/null 2>&1; then
  echo "未找到 gh CLI，请先安装：https://cli.github.com/" >&2
  exit 1
fi
if ! gh auth status >/dev/null 2>&1; then
  echo "gh 未登录，请先运行：gh auth login" >&2
  exit 1
fi

# 格式：名称|颜色(不含 #)|描述
LABELS=(
  "profile/fill|0E8A16|待补充或待修订的档案条目"
  "profile/review|FBCA04|需复审核对准确性的条目"
  "profile/expired|D93F0B|已过期待删除的条目"
  "ai/sync|1D76DB|跨 AI 客户端接入与版本校验"
  "area/readme|5319E7|README 档案正文"
  "area/tooling|C5DEF5|模板脚本与自动化工具链"
  "area/privacy|B60205|隐私与合规检查"
  "area/versioning|CCCCCC|版本记录 tag 与回退"
  "priority/high|E99695|高优先级"
  "priority/low|C2E0C6|低优先级"
  "status/blocked|333333|被外部条件阻塞"
)

for entry in "${LABELS[@]}"; do
  IFS='|' read -r name color desc <<< "$entry"
  if gh label create "$name" --color "$color" --description "$desc" --force >/dev/null 2>&1; then
    echo "已就绪: $name"
  else
    echo "跳过: $name（请确认仓库已关联远程且账号有写入权限）" >&2
  fi
done

echo "标签同步完成。清单说明见 .github/labels.md"
