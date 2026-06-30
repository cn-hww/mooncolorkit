///|
fn main {
  let white = @color.Rgb::from_hex("#FFFFFF")
  let weak_text = @color.Rgb::from_hex("#9A9A9A")
  let repair = @color.suggest_accessible_foreground(weak_text, white)
  let theme = @color.SemanticTheme::build(
    "MoonColorKit demo",
    white,
    @color.Rgb::from_hex("#F4F7FA"),
    @color.Rgb::from_hex("#2F6FED"),
  )
  let report = @color.audit_roles([
    @color.ColorRole::new("body", theme.text, theme.background),
    @color.ColorRole::new("muted", weak_text, theme.background),
    @color.ColorRole::new("on-accent", theme.on_accent, theme.accent),
  ])
  println("== WCAG audit ==")
  println(report.to_json())
  println("== Suggested repair ==")
  println(repair.to_json())
  println("== DTCG design tokens ==")
  println(theme.to_design_tokens_json())
  println("== CSS variables ==")
  println(theme.to_css_vars())
}
