///|
fn main {
  let accent = @color.Rgb::from_hex("#2F80ED")
  let theme = @color.Theme::new(@color.Rgb::new(255, 255, 255), accent)
  println(theme.to_json())
  println(theme.palette.to_css_vars(prefix="brand"))
  println(
    "contrast=\{@color.contrast_ratio_x100(theme.foreground, theme.background)}",
  )
}
