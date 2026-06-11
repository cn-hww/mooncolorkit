# MoonColorKit

MoonColorKit 是一个面向 MoonBit 的颜色空间与可访问性调色基础库，重点提供颜色表示、格式转换、对比度评估、调色板生成和主题导出能力。

项目不绑定浏览器、Canvas 或任何特定渲染后端，核心包只处理纯算法与可序列化数据，适合在设计工具、数据可视化、WebAssembly UI、CLI 主题生成器和教学示例中复用。

## 当前能力

- RGB 颜色模型，带通道裁剪和 HEX / JSON / CSS RGB 导出。
- HEX 字符串解析，支持带 `#` 和不带 `#` 的六位颜色。
- HSL 表示与 RGB 到 HSL 的基础转换。
- 相对亮度、对比度和 AA 正文字号可读性判断。
- 颜色混合、线性渐变、互补色、单色调色板和强调色调色板。
- 自动选择黑色或白色文本色，生成背景 / 前景配对。
- `Theme` 组合模型，可一次导出背景色、文字色、强调色和调色板。
- CLI 演示，可直接输出主题 JSON、CSS 变量和对比度结果。

## 快速示例

```moonbit nocheck
let accent = @mooncolorkit.Rgb::from_hex("#2F80ED")
let theme = @mooncolorkit.Theme::new(
  @mooncolorkit.Rgb::new(255, 255, 255),
  accent,
)

println(theme.to_json())
println(theme.palette.to_css_vars(prefix="brand"))
```

运行演示：

```bash
moon run cmd/main
```

运行测试：

```bash
moon test
```

## 设计原则

MoonColorKit 的定位是 MoonBit 基础算法生态库，而不是某个前端框架的封装层。项目在 API 设计上遵循三点：

1. 保持数据结构直接、可检查、易序列化。
2. 保持核心算法后端中立，不引入 IO、浏览器或平台依赖。
3. 用确定性测试覆盖每个公开能力，便于后续持续扩展。

## 仓库

- GitHub: <https://github.com/cn-hww/mooncolorkit>
- GitLink: 待从 GitHub 导入后填写
