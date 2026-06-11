# Theme Palette Example

目标：从一个强调色生成可读主题，并导出给前端或设计工具使用的 CSS 变量。

```moonbit
let accent = @mooncolorkit.Rgb::from_hex("#2F80ED")
let theme = @mooncolorkit.Theme::new(
  @mooncolorkit.Rgb::new(255, 255, 255),
  accent,
)

println(theme.to_json())
println(theme.palette.to_css_vars(prefix="brand"))
```

示例输出：

```text
{"background":"#FFFFFF","foreground":"#000000","accent":"#2F80ED","palette":{"colors":["#B6D2F8","#77ACF3","#2F80ED","#2059A5","#15396A"]}}
--brand-0: #B6D2F8;
--brand-1: #77ACF3;
--brand-2: #2F80ED;
--brand-3: #2059A5;
--brand-4: #15396A;
```
