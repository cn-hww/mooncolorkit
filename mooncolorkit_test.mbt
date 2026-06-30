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

///|
test "relative luminance and contrast use stable integer scale" {
  let black = @mooncolorkit.Rgb::new(0, 0, 0)
  let white = @mooncolorkit.Rgb::new(255, 255, 255)
  assert_eq(black.relative_luminance_per_mille(), 0)
  assert_eq(white.relative_luminance_per_mille(), 1000)
  assert_eq(@mooncolorkit.contrast_ratio_x100(black, white), 2100)
  assert_true(@mooncolorkit.passes_aa_text(black, white))
}

///|
test "wcag contrast linearizes srgb before applying weights" {
  let gray = @mooncolorkit.Rgb::from_hex("#777777")
  let white = @mooncolorkit.Rgb::from_hex("#FFFFFF")
  assert_eq(gray.relative_luminance_per_mille(), 184)
  assert_eq(@mooncolorkit.contrast_ratio_x100(gray, white), 448)
  assert_false(@mooncolorkit.passes_aa_text(gray, white))
}

///|
test "wcag thresholds are evaluated before display rounding" {
  let almost = @mooncolorkit.Rgb::from_hex("#777777")
  let passing = @mooncolorkit.Rgb::from_hex("#767676")
  let white = @mooncolorkit.Rgb::from_hex("#FFFFFF")
  assert_true(
    @mooncolorkit.classify_text_contrast(almost, white) ==
    @mooncolorkit.WcagLevel::Fail,
  )
  assert_true(
    @mooncolorkit.classify_text_contrast(passing, white) ==
    @mooncolorkit.WcagLevel::AA,
  )
}

///|
test "wcag classification distinguishes large text" {
  let foreground = @mooncolorkit.Rgb::from_hex("#949494")
  let background = @mooncolorkit.Rgb::from_hex("#FFFFFF")
  assert_true(
    @mooncolorkit.classify_text_contrast(foreground, background) ==
    @mooncolorkit.WcagLevel::Fail,
  )
  assert_true(
    @mooncolorkit.classify_text_contrast(
      foreground,
      background,
      large_text=true,
    ) ==
    @mooncolorkit.WcagLevel::AA,
  )
}

///|
test "audit report summarizes semantic color roles" {
  let report = @mooncolorkit.audit_roles([
    @mooncolorkit.ColorRole::new(
      "body",
      @mooncolorkit.Rgb::from_hex("#000000"),
      @mooncolorkit.Rgb::from_hex("#FFFFFF"),
    ),
    @mooncolorkit.ColorRole::new(
      "hint",
      @mooncolorkit.Rgb::from_hex("#AAAAAA"),
      @mooncolorkit.Rgb::from_hex("#FFFFFF"),
    ),
  ])
  assert_eq(report.audits.length(), 2)
  assert_eq(report.passed_aaa, 1)
  assert_eq(report.failed, 1)
  assert_true(report.to_json().contains("\"failed\":1"))
}

///|
test "accessible repair finds the smallest sampled passing mix" {
  let foreground = @mooncolorkit.Rgb::from_hex("#AAAAAA")
  let background = @mooncolorkit.Rgb::from_hex("#FFFFFF")
  let repair = @mooncolorkit.suggest_accessible_foreground(
    foreground, background,
  )
  assert_true(repair.achieved)
  assert_true(@mooncolorkit.contrast_ratio(repair.suggested, background) >= 4.5)
  assert_true(repair.mix_weight_per_mille > 0)
  assert_true(repair.to_json().contains("\"achieved\":true"))
}

///|
test "rgb mix blends channels by per mille weight" {
  let red = @mooncolorkit.Rgb::new(255, 0, 0)
  let blue = @mooncolorkit.Rgb::new(0, 0, 255)
  assert_eq(red.mix(blue, 500).to_hex(), "#7F007F")
}

///|
test "gradient includes start and end colors" {
  let colors = @mooncolorkit.gradient(
    @mooncolorkit.Rgb::new(0, 0, 0),
    @mooncolorkit.Rgb::new(255, 255, 255),
    3,
  )
  assert_eq(colors.length(), 3)
  assert_eq(colors[0].to_hex(), "#000000")
  assert_eq(colors[2].to_hex(), "#FFFFFF")
}

///|
test "complementary color inverts channels" {
  assert_eq(
    @mooncolorkit.complementary(@mooncolorkit.Rgb::new(255, 128, 0)).to_hex(),
    "#007FFF",
  )
}

///|
test "palettes expose color counts and json" {
  let mono = @mooncolorkit.monochrome_palette(
    @mooncolorkit.Rgb::new(40, 120, 200),
  )
  let accents = @mooncolorkit.accent_palette(@mooncolorkit.Rgb::new(10, 20, 30))
  assert_eq(mono.length(), 5)
  assert_eq(accents.length(), 3)
  assert_true(mono.to_json().contains("\"colors\""))
}

///|
test "readable text chooses black or white by contrast" {
  assert_eq(
    @mooncolorkit.readable_text_on(@mooncolorkit.Rgb::new(255, 255, 255)).to_hex(),
    "#000000",
  )
  assert_eq(
    @mooncolorkit.readable_text_on(@mooncolorkit.Rgb::new(0, 0, 0)).to_hex(),
    "#FFFFFF",
  )
}

///|
test "text pair contains background and readable foreground" {
  let pair = @mooncolorkit.ensure_text_pair(@mooncolorkit.Rgb::new(20, 20, 20))
  assert_eq(pair.length(), 2)
  assert_eq(pair.colors[1].to_hex(), "#FFFFFF")
}

///|
test "colors export css rgb and variables" {
  let color = @mooncolorkit.Rgb::new(1, 2, 3)
  let palette = @mooncolorkit.Palette::new([
    color,
    @mooncolorkit.Rgb::new(4, 5, 6),
  ])
  assert_eq(color.to_css_rgb(), "rgb(1, 2, 3)")
  assert_true(
    palette.to_css_vars(prefix="brand").contains("--brand-1: #040506;"),
  )
}

///|
test "theme chooses readable foreground and palette" {
  let theme = @mooncolorkit.Theme::new(
    @mooncolorkit.Rgb::new(0, 0, 0),
    @mooncolorkit.Rgb::new(40, 120, 200),
  )
  assert_eq(theme.foreground.to_hex(), "#FFFFFF")
  assert_eq(theme.palette.length(), 5)
  assert_true(theme.to_json().contains("\"accent\":\"#2878C8\""))
}

///|
test "semantic theme emits audited css variables" {
  let theme = @mooncolorkit.SemanticTheme::build(
    "ocean",
    @mooncolorkit.Rgb::from_hex("#FFFFFF"),
    @mooncolorkit.Rgb::from_hex("#F4F7FA"),
    @mooncolorkit.Rgb::from_hex("#1261A0"),
  )
  let audit = theme.audit()
  assert_eq(audit.failed, 0)
  assert_true(theme.to_css_vars().contains("--color-on-accent:"))
}

///|
test "design token output follows dtcg color object format" {
  let theme = @mooncolorkit.SemanticTheme::build(
    "night",
    @mooncolorkit.Rgb::from_hex("#101820"),
    @mooncolorkit.Rgb::from_hex("#17232E"),
    @mooncolorkit.Rgb::from_hex("#FFD166"),
  )
  let json = theme.to_design_tokens_json()
  assert_true(json.contains("\"$type\":\"color\""))
  assert_true(json.contains("\"colorSpace\":\"srgb\""))
  assert_true(json.contains("\"components\":["))
  assert_true(json.contains("\"hex\":\"#FFD166\""))
}
