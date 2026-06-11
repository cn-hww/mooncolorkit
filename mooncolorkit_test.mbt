///|
test "rgb clamps channels" {
  let color = @mooncolorkit.Rgb::new(-1, 128, 300)
  assert_eq(color.r, 0)
  assert_eq(color.g, 128)
  assert_eq(color.b, 255)
}

///|
test "rgb exports hex and json" {
  let color = @mooncolorkit.Rgb::new(15, 160, 255)
  assert_eq(color.to_hex(), "#0FA0FF")
  assert_true(color.to_json().contains("\"hex\":\"#0FA0FF\""))
}
