# 与社区项目的边界

## 对照对象

报名初审指出 Mooncakes 上已有 `bobzhang/colors@0.8.1`。该项目公开文档展示的核心职责是颜色值表示和常用颜色运算，并被 `bobzhang/vg` 用作渲染层的颜色类型。MoonColorKit 接受这一事实，不再把“RGB/HSL/混色”作为申报主体。

## 功能边界

| 维度 | `bobzhang/colors` | MoonColorKit |
| --- | --- | --- |
| 主要职责 | 通用颜色值、预定义颜色、HSV、混合与插值 | 语义配色关系的合规审计、修复和交付 |
| 典型输入 | 单个颜色值 | 带名称、用途和字号类别的前景/背景角色 |
| 核心计算 | 颜色构造与变换 | sRGB 线性化、WCAG 对比度、AA/AAA 分类 |
| 批处理 | 颜色集合运算 | 多角色审计、通过率和失败清单 |
| 失败处理 | 返回颜色结果 | 给出目标阈值、建议颜色、改动比例和达成证据 |
| 工程输出 | 供绘图或应用代码使用的颜色 | 审计 JSON、DTCG 颜色 Token、CSS 变量 |
| CI 场景 | 作为依赖参与构建 | 作为主题质量门禁产生确定性结果 |

## 关系

两个项目不是同类替代关系。`colors` 可以作为图形或应用内部的颜色表示层，MoonColorKit 位于设计系统流水线中，负责检查哪些颜色可以共同使用、怎样修复不合格组合、怎样把结果交给前端或其他目标平台。后续可增加适配包，在不复制其实现的前提下接收社区颜色类型。

## 本次重构的可核验证据

1. `Rgb::relative_luminance` 对每个 sRGB 通道先做分段线性化，再应用 0.2126/0.7152/0.0722 权重。
2. `classify_text_contrast` 使用未舍入的 `Double` 比率判断 3.0、4.5 和 7.0 阈值。
3. `audit_roles` 对语义角色批量生成通过数、AAA 数和失败数。
4. `suggest_accessible_foreground` 分别向黑、白方向搜索，选择采样改动较小且达到目标的候选。
5. `SemanticTheme::to_design_tokens_json` 输出 DTCG 2025.10 规定的 sRGB 颜色对象。
6. 测试包含 `#777777`/白色约 4.48:1 的临界失败用例，证明判断没有被显示值舍入影响。

## 参考

- Mooncakes: <https://mooncakes.io/docs/bobzhang/colors@0.8.1>
- WCAG 2.1 Understanding 1.4.3: <https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum>
- Design Tokens Color Module 2025.10: <https://www.w3.org/community/reports/design-tokens/CG-FINAL-color-20251028/>
- Design Tokens Format Module 2025.10: <https://www.w3.org/community/reports/design-tokens/CG-FINAL-format-20251028/>
