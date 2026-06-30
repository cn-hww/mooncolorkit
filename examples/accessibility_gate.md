# 配色审计门禁示例

一个组件库准备发布新主题时，可以把实际相邻的颜色组合整理成语义角色：

```moonbit
let report = @mooncolorkit.audit_roles([
  @mooncolorkit.ColorRole::new(
    "body/background",
    @mooncolorkit.Rgb::from_hex("#323842"),
    @mooncolorkit.Rgb::from_hex("#FFFFFF"),
  ),
  @mooncolorkit.ColorRole::new(
    "hint/background",
    @mooncolorkit.Rgb::from_hex("#AAAAAA"),
    @mooncolorkit.Rgb::from_hex("#FFFFFF"),
  ),
])
```

`report.failed` 大于零时，构建脚本可以终止主题发布；同时对失败角色调用：

```moonbit
let repair = @mooncolorkit.suggest_accessible_foreground(
  @mooncolorkit.Rgb::from_hex("#AAAAAA"),
  @mooncolorkit.Rgb::from_hex("#FFFFFF"),
)
```

修复结果包含原色、建议色、目标比率、实际比率和混合权重，可以进入代码评审记录，而不是只给出“通过/失败”的黑盒结论。
