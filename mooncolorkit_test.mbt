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

///|
test "rgb parses hex strings" {
  let color = @mooncolorkit.Rgb::from_hex("#0FA0FF")
  assert_eq(color.r, 15)
  assert_eq(color.g, 160)
  assert_eq(color.b, 255)
}

///|
test "rgb parses hex without hash and falls back on short input" {
  assert_eq(@mooncolorkit.Rgb::from_hex("FF0000").to_hex(), "#FF0000")
  assert_eq(@mooncolorkit.Rgb::from_hex("#12").to_hex(), "#000000")
}
