# 架构说明

MoonColorKit 分为三层，依赖方向保持单向。

## 颜色数学层

`mooncolorkit.mbt` 提供 RGB/HSL、解析、序列化、混色和 WCAG 计算所需的 sRGB 数学。该层不理解“正文”“按钮”等业务语义。

## 审计层

`accessibility.mbt` 把颜色组合建模为 `ColorRole`，输出 `ContrastAudit` 与 `AuditReport`。修复器只依赖确定性颜色计算，相同输入在不同后端得到相同决策。

## 交付层

`tokens.mbt` 将通过审计的颜色组织为 `SemanticTheme`，输出 DTCG JSON 和 CSS 变量。它不直接写文件，调用方可自由选择 Web、CLI、IDE 或构建脚本作为宿主。

## 数据流

```text
HEX/RGB
  -> ColorRole[]
  -> WCAG audit
  -> repair suggestion
  -> SemanticTheme
  -> DTCG JSON / CSS variables / audit JSON
```

核心包不包含网络、时钟、随机数和平台 IO，测试不依赖外部环境。
