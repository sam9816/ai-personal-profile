# Projects 看板搭建说明

> **重要边界**：GitHub Projects（新版）是**账户 / 组织级对象**，不是仓库文件，无法通过提交 `.github/` 里的配置自动生成；Issues 与标签可以由仓库文件和 API 直接开启。因此看板需要一次性手工或脚本创建，本文件给出可直接照抄的配置。

## 一、创建看板

方式 A（推荐，命令行）：

```bash
gh project create --owner @me --title "AI 个人档案 · 待办看板"
```

方式 B（网页端）：GitHub 头像 → **Your projects** → **New project** → 选 **Board** 模板 → 命名 `AI 个人档案 · 待办看板`。

创建后把本仓库的 Issues 加入看板：网页端看板内 `+ Add item` → 选择本仓库的 Issue；或用 `gh project item-add <编号> --owner @me --url <issue-url>`。

## 二、建议字段

| 字段名 | 类型 | 选项 / 说明 |
| --- | --- | --- |
| Status | Single select | `Backlog` / `In Progress` / `Review` / `Done` |
| 章节 | Single select | `1 简介` `2 习惯` `3 沟通` `4 工具` `5 项目` `6 目标` `工具链` |
| 优先级 | Single select | `High` / `Medium` / `Low` |
| 目标版本 | Text | 计划落在哪个 tag，如 `v0.2.0` |
| 隐私复核 | Checkbox / Single select | `待复核` / `已通过` |

## 三、建议视图

| 视图 | 布局 | 分组 / 过滤 |
| --- | --- | --- |
| 看板总览 | Board | 按 `Status` 分组 |
| 按章节填充 | Table | 按 `章节` 分组，过滤 `label:profile/fill` |
| 本版本待办 | Table | 过滤 `目标版本 = v0.2.0`、`Status != Done` |
| 季度复审 | Table | 过滤 `label:profile/review,profile/expired,area/privacy` |

## 四、状态流转约定

```
Backlog → In Progress → Review → Done
              ↓            ↓
           （补充内容）  （隐私复核 + CHANGELOG 已记录）
```

关闭 Issue 前必须满足：`README.md` 已更新、`CHANGELOG.md` 已记录、已打 tag（若为档案内容变更）。

## 五、与版本记录的联动

- 每个 `目标版本` 对应一个语义化 tag，例：`v0.2.0`。
- tag 创建后，在看板中把该版本下所有 Issue 批量改为 `Done`，形成「版本 ↔ 待办」的可追溯对应关系。
- 需要回退时，按 [版本管理约定](../docs/版本管理约定.md) 操作，并在对应 Issue 中记录回退原因，不要静默改档。
