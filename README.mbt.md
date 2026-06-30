# MoonColorKit

MoonColorKit 是一个面向 MoonBit 的可访问性配色审计与 Design Token 编译库。它接收带有语义名称的前景色、背景色和文本用途，按照 WCAG 规则计算对比度、给出 AA/AAA 结论，并为不合格颜色生成可复现的修复建议；审计通过的主题可继续导出为 DTCG 2025.10 颜色对象和 CSS 变量。

核心包不依赖浏览器、Canvas、文件系统或特定渲染后端，可用于 WebAssembly UI、组件库、数据可视化、设计系统和 CI 质量门禁。

## 为什么不是另一个 colors

MoonBit 生态已有 `bobzhang/colors` 等颜色基础组件，负责 RGBA/HSV 表示、预定义颜色、混合和插值。MoonColorKit 不以替代这些类型为目标，项目关注的是更上一层的工程问题：

- 用“正文/背景”“按钮文字/按钮底色”等语义角色描述待审计关系；
- 按 WCAG 2.x 的 sRGB 线性化公式计算相对亮度和对比度；
- 区分普通文本与大号文本的 AA、AAA 阈值，阈值判断不使用四舍五入值；
- 批量生成机器可读审计报告，便于在 CI 中阻止不合格主题进入发布；
- 搜索改动幅度较小的黑/白混合方向，给出满足目标对比度的修复色；
- 把审计后的语义主题导出为 DTCG 2025.10 颜色对象和 CSS Custom Properties。

完整边界和逐项对照见 [docs/RELATED_WORK.md](docs/RELATED_WORK.md)。

## 核心 API

```moonbit nocheck
let report = @mooncolorkit.audit_roles([
  @mooncolorkit.ColorRole::new(
    "body/background",
    @mooncolorkit.Rgb::from_hex("#777777"),
    @mooncolorkit.Rgb::from_hex("#FFFFFF"),
  ),
])

let repair = @mooncolorkit.suggest_accessible_foreground(
  @mooncolorkit.Rgb::from_hex("#AAAAAA"),
  @mooncolorkit.Rgb::from_hex("#FFFFFF"),
)

let theme = @mooncolorkit.SemanticTheme::build(
  "product-light",
  @mooncolorkit.Rgb::from_hex("#FFFFFF"),
  @mooncolorkit.Rgb::from_hex("#F4F7FA"),
  @mooncolorkit.Rgb::from_hex("#2F6FED"),
)

println(report.to_json())
println(repair.to_json())
println(theme.to_design_tokens_json())
println(theme.to_css_vars())
```

## 当前交付

- `Rgb`、`Hsl`、HEX、混色、渐变和调色板等兼容基础层；
- 标准 sRGB 线性化、相对亮度与 1:1 至 21:1 对比度计算；
- 普通文本/大号文本的 AA、AAA 分级；
- `ColorRole`、`ContrastAudit`、`AuditReport` 批量审计模型；
- 最小采样改色建议及修复前后证据；
- `SemanticTheme` 语义主题生成和自审计；
- DTCG 2025.10 `colorSpace/components/alpha/hex` 颜色对象；
- CSS 变量、JSON 报告和 CLI 端到端演示；
- 22 项确定性测试，覆盖边界阈值和跨模块流程。

## 验证

```bash
moon fmt --check
moon check
moon test
moon run cmd/main
```

## 仓库

- GitHub: <https://github.com/cn-hww/mooncolorkit>
- GitLink: <https://www.gitlink.org.cn/cn-hww/mooncolorkit>
