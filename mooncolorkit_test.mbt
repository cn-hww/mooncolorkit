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

///|
test "hsl normalizes hue and percent values" {
  let hsl = @mooncolorkit.Hsl::new(420, -1, 120)
  assert_eq(hsl.h, 60)
  assert_eq(hsl.s, 0)
  assert_eq(hsl.l, 100)
}

///|
test "rgb converts primary and gray colors to hsl" {
  let red = @mooncolorkit.Rgb::new(255, 0, 0).to_hsl()
  let gray = @mooncolorkit.Rgb::new(128, 128, 128).to_hsl()
  assert_eq(red.h, 0)
  assert_eq(red.s, 100)
  assert_eq(red.l, 50)
  assert_eq(gray.s, 0)
}
