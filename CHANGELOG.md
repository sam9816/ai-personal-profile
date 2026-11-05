# 变更记录

本文件记录档案的每一次有意义变更。格式参照 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，版本号遵循语义化版本：

| 位 | 何时递增 | 例子 |
| --- | --- | --- |
| 主版本 `v1.0.0` | 档案结构不兼容调整 | 删除 / 重排章节 |
| 次版本 `v0.2.0` | 新增章节、条目、工具链 | 填满沟通风格章节 |
| 修订号 `v0.1.1` | 措辞、格式、错别字修正 | 修正某条示例 |

> **硬性约定**：只要修改 `README.md`，就必须同步在本文件留一条记录；每次发布打一个 tag。
> 模板：`.github/workflows/changelog-check.yml` 会在 PR 中提醒。

---

## [Unreleased]

_暂无待发布变更。_

## [v0.1.0] - 2026-11-05

初始版本：仓库骨架落地，档案结构为占位示例，尚未填入真实个人内容。

### 新增

- `README.md`：档案入口，建立六章节结构（个人简介与背景 / 工作与学习习惯 / 沟通风格偏好 / 常用工具与技术栈 / 项目经验与成果 / 长期目标），每章配 3 条简短示例条目
- `.github/ISSUE_TEMPLATE/`：档案条目补充、跨 AI 同步校验两类结构化 Issue 模板与 `config.yml`
- `.github/labels.md` + `scripts/setup-labels.sh`：11 个待办跟踪标签定义
- `.github/PROJECT_SETUP.md`：Projects 看板字段、视图与状态流转约定
- `.github/workflows/changelog-check.yml`：PR 修改档案时提醒同步更新变更记录
- `docs/版本管理约定.md`：提交规范、tag、diff、回退操作手册
- `docs/隐私与合规提示.md`：公开仓库风险清单与误提交处置流程
- `CONTRIBUTING.md`：填充规范、提交规范、发版流程
- `.gitignore`：忽略本地私密与临时文件
- `.gitattributes`：固定 `.sh` / `.yml` / `.md` 使用 LF 行尾，避免 Windows CRLF 导致脚本解析失败
- `scripts/bootstrap-remote.sh`：远程创建与初始化一键脚本（含 Windows 下 `gh.exe` 路径自动探测、标签与 HEAD 自动同步）

### 待办

- 填充六章节真实内容（见种子 Issue #1）
- 在至少 3 个 AI 客户端接入 RAW 地址并验证（见种子 Issue #2）
- 创建 Projects 看板并关联 Issues
- 修正初始提交的作者身份为本人 GitHub 账号

---

[v0.1.0]: https://github.com/sam9816/ai-personal-profile/releases/tag/v0.1.0
