# 维护约定

本文件说明如何填充档案、如何提交、如何发版。目标只有一句话：**每次修改都留得下痕迹、找得到原因、退得回旧版。**

---

## 一、填充档案的规则

1. **一句话一条**：每条只表达一个事实或偏好，方便 AI 逐条引用，也方便 `git blame` 定位。
2. **可验证**：写明适用范围与生效日期，避免「最近」「通常」这类模糊表述。
3. **替换而非堆叠**：改条目就改原行，不要在同一章节追加一条互相矛盾的新内容。
4. **过期即删**：删除时在 `CHANGELOG.md` 写明删除原因，历史仍在 Git 中，不必担心丢失。
5. **公开优先**：默认按「可能被任何人、任何 AI 读到」的标准写，任何犹豫都放到私有仓库。

## 二、提交信息规范（Conventional Commits）

```
<type>(<scope>): <简短说明>

[可选正文：改了什么、为什么改]
```

| type | 用于 |
| --- | --- |
| `docs` | README 档案内容、docs 文档 |
| `feat` | 新增章节、模板、脚本能力 |
| `fix` | 修正错误条目或脚本缺陷 |
| `chore` | 标签、仓库设置、依赖维护 |
| `revert` | 回退既有提交 |

`scope` 建议用章节号或模块名：`profile/1`、`profile/3`、`tooling`、`versioning`。

示例：

```bash
git commit -m "docs(profile/3): 明确输出需附来源与风险提示"
git commit -m "feat(tooling): 新增季度复审 Issue 模板"
git commit -m "revert: 撤回 v0.2.0 中过期的工具条目"
```

## 三、一次完整修改的标准流程

```bash
# 1. 修改前先确认当前版本
git log --oneline -5
git tag --list

# 2. 编辑 README.md，并同步在 CHANGELOG.md 的 [Unreleased] 下记一条

# 3. 提交
git add README.md CHANGELOG.md
git commit -m "docs(profile/2): 补充任务拆解习惯"

# 4. 达到一个可用阶段时打 tag
git tag -a v0.2.0 -m "填充工作习惯与沟通风格章节"
git push origin main --tags

# 5. 在 Projects 看板把该版本下的 Issue 批量置为 Done
```

## 四、发版检查清单

- [ ] `README.md` 头部「当前版本 / 最后更新」已更新
- [ ] `CHANGELOG.md` 的 `[Unreleased]` 已归并到新版本段落
- [ ] tag 已创建并推送
- [ ] 隐私自查通过（见 `docs/隐私与合规提示.md`）
- [ ] 各 AI 客户端已重新拉取 RAW 地址的新版本

## 五、Issues 与标签

- 待补充、待核实、待同步一律开 Issue，选对应模板，别用空白 Issue。
- 标签规则见 [`.github/labels.md`](.github/labels.md)；一条待办最多 3 个标签。
- 关闭 Issue 前确认：档案已更新、CHANGELOG 已记录、tag 已打。

## 六、远程操作

创建公开仓库、启用 Issues/Projects、建标签与种子 Issue：`scripts/bootstrap-remote.sh`。
标签补建：`scripts/setup-labels.sh`。
