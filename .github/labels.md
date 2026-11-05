# 标签清单

三组标签，分别回答「**是什么类型**」「**动哪块**」「**多紧急 / 什么状态**」。
实际创建由 [`scripts/setup-labels.sh`](../scripts/setup-labels.sh) 执行，该文件为唯一执行源；如需调整，请同步修改两处。

## 一、条目类型 `profile/*` `ai/*`

| 标签 | 颜色 | 含义 |
| --- | --- | --- |
| `profile/fill` | 绿 | 待补充 / 待修订的档案条目 |
| `profile/review` | 黄 | 需复审、核对准确性的条目 |
| `profile/expired` | 橙红 | 已过期、待删除的条目 |
| `ai/sync` | 蓝 | 跨 AI 客户端接入与版本校验 |

## 二、影响范围 `area/*`

| 标签 | 颜色 | 含义 |
| --- | --- | --- |
| `area/readme` | 紫 | README 档案正文 |
| `area/tooling` | 浅蓝 | 模板、脚本、Actions 等工具链 |
| `area/privacy` | 深红 | 隐私与合规检查 |
| `area/versioning` | 灰 | 版本记录、tag、回退相关 |

## 三、优先级与状态

| 标签 | 颜色 | 含义 |
| --- | --- | --- |
| `priority/high` | 浅红 | 优先处理 |
| `priority/low` | 浅绿 | 有空再做 |
| `status/blocked` | 黑 | 被外部条件阻塞 |

## 建议用法

- 一条待办只打 **1 个类型 + 1 个范围 + 0~1 个优先级/状态**，避免标签泛滥。
- `profile/expired` 与 `area/privacy` 的 Issue 关闭时，务必在 CHANGELOG 写明删除原因。
- 季度复审时按 `profile/review` 过滤，集中处理。
