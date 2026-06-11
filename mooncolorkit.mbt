///|
pub(all) struct Rgb {
  r : Int
  g : Int
  b : Int
} derive(Debug, Eq)

///|
pub(all) struct Hsl {
  h : Int
  s : Int
  l : Int
} derive(Debug, Eq)

///|
pub(all) struct Palette {
  colors : Array[Rgb]
} derive(Debug)

///|
pub fn Rgb::new(r : Int, g : Int, b : Int) -> Rgb {
  { r: clamp_channel(r), g: clamp_channel(g), b: clamp_channel(b) }
}

///|
pub fn Hsl::new(h : Int, s : Int, l : Int) -> Hsl {
  { h: normalize_hue(h), s: clamp_percent(s), l: clamp_percent(l) }
}

///|
pub fn Palette::new(colors : Array[Rgb]) -> Palette {
  { colors, }
}

///|
fn clamp_channel(value : Int) -> Int {
  if value < 0 {
    0
  } else if value > 255 {
    255
  } else {
    value
  }
}

///|
fn clamp_percent(value : Int) -> Int {
  if value < 0 {
    0
  } else if value > 100 {
    100
  } else {
    value
  }
}

///|
fn normalize_hue(value : Int) -> Int {
  let mut hue = value % 360
  if hue < 0 {
    hue = hue + 360
  }
  hue
}

///|
fn max_int(a : Int, b : Int) -> Int {
  if a > b {
    a
  } else {
    b
  }
}

///|
fn min_int(a : Int, b : Int) -> Int {
  if a < b {
    a
  } else {
    b
  }
}

///|
fn hex_digit(value : Int) -> String {
  match value {
    0 => "0"
    1 => "1"
    2 => "2"
    3 => "3"
    4 => "4"
    5 => "5"
    6 => "6"
    7 => "7"
    8 => "8"
    9 => "9"
    10 => "A"
    11 => "B"
    12 => "C"
    13 => "D"
    14 => "E"
    _ => "F"
  }
}

///|
fn byte_to_hex(value : Int) -> String {
  hex_digit(value / 16) + hex_digit(value % 16)
}

///|
pub fn Rgb::to_hex(self : Rgb) -> String {
  "#" + byte_to_hex(self.r) + byte_to_hex(self.g) + byte_to_hex(self.b)
}

///|
pub fn Rgb::to_json(self : Rgb) -> String {
  "{\"r\":\{self.r},\"g\":\{self.g},\"b\":\{self.b},\"hex\":\"\{self.to_hex()}\"}"
}

///|
fn hex_value(ch : Char) -> Int {
  match ch {
    '0' => 0
    '1' => 1
    '2' => 2
    '3' => 3
    '4' => 4
    '5' => 5
    '6' => 6
    '7' => 7
    '8' => 8
    '9' => 9
    'a' | 'A' => 10
    'b' | 'B' => 11
    'c' | 'C' => 12
    'd' | 'D' => 13
    'e' | 'E' => 14
    'f' | 'F' => 15
    _ => -1
  }
}

///|
fn parse_hex_byte(high : Char, low : Char) -> Int {
  let a = hex_value(high)
  let b = hex_value(low)
  if a < 0 || b < 0 {
    0
  } else {
    a * 16 + b
  }
}

///|
pub fn Rgb::from_hex(value : String) -> Rgb {
  let start = if value.length() == 7 && value.get_char(0) == Some('#') {
    1
  } else {
    0
  }
  if value.length() - start < 6 {
    return Rgb::new(0, 0, 0)
  }
  match
    (
      value.get_char(start),
      value.get_char(start + 1),
      value.get_char(start + 2),
      value.get_char(start + 3),
      value.get_char(start + 4),
      value.get_char(start + 5),
    ) {
    (Some(r1), Some(r2), Some(g1), Some(g2), Some(b1), Some(b2)) =>
      Rgb::new(
        parse_hex_byte(r1, r2),
        parse_hex_byte(g1, g2),
        parse_hex_byte(b1, b2),
      )
    _ => Rgb::new(0, 0, 0)
  }
}

///|
pub fn Rgb::to_hsl(self : Rgb) -> Hsl {
  let max = max_int(self.r, max_int(self.g, self.b))
  let min = min_int(self.r, min_int(self.g, self.b))
  let delta = max - min
  let lightness = (max + min) * 100 / 510
  if delta == 0 {
    return Hsl::new(0, 0, lightness)
  }
  let saturation = if lightness <= 50 {
    delta * 100 / (max + min)
  } else {
    delta * 100 / (510 - max - min)
  }
  let mut hue = if max == self.r {
    60 * (self.g - self.b) / delta
  } else if max == self.g {
    120 + 60 * (self.b - self.r) / delta
  } else {
    240 + 60 * (self.r - self.g) / delta
  }
  if hue < 0 {
    hue = hue + 360
  }
  Hsl::new(hue, saturation, lightness)
}

///|
pub fn Hsl::to_json(self : Hsl) -> String {
  "{\"h\":\{self.h},\"s\":\{self.s},\"l\":\{self.l}}"
}

///|
pub fn Rgb::relative_luminance_per_mille(self : Rgb) -> Int {
  // Integer approximation of WCAG relative luminance on 0..1000 scale.
  (self.r * 2126 + self.g * 7152 + self.b * 722) / 2550
}

///|
pub fn contrast_ratio_x100(a : Rgb, b : Rgb) -> Int {
  let la = a.relative_luminance_per_mille()
  let lb = b.relative_luminance_per_mille()
  let lighter = max_int(la, lb) + 50
  let darker = min_int(la, lb) + 50
  lighter * 100 / darker
}

///|
pub fn passes_aa_text(foreground : Rgb, background : Rgb) -> Bool {
  contrast_ratio_x100(foreground, background) >= 450
}

///|
pub fn Rgb::mix(self : Rgb, other : Rgb, weight_per_mille : Int) -> Rgb {
  let weight = clamp_per_mille(weight_per_mille)
  let inverse = 1000 - weight
  Rgb::new(
    (self.r * inverse + other.r * weight) / 1000,
    (self.g * inverse + other.g * weight) / 1000,
    (self.b * inverse + other.b * weight) / 1000,
  )
}

///|
pub fn gradient(start : Rgb, end : Rgb, steps : Int) -> Array[Rgb] {
  let count = if steps <= 1 { 1 } else { steps }
  let colors : Array[Rgb] = []
  if count == 1 {
    colors.push(start)
    return colors
  }
  for i = 0; i < count; i = i + 1 {
    colors.push(start.mix(end, i * 1000 / (count - 1)))
  }
  colors
}

///|
fn clamp_per_mille(value : Int) -> Int {
  if value < 0 {
    0
  } else if value > 1000 {
    1000
  } else {
    value
  }
}

///|
pub fn complementary(color : Rgb) -> Rgb {
  Rgb::new(255 - color.r, 255 - color.g, 255 - color.b)
}

///|
pub fn monochrome_palette(base : Rgb) -> Palette {
  Palette::new([
    base.mix(Rgb::new(255, 255, 255), 650),
    base.mix(Rgb::new(255, 255, 255), 350),
    base,
    base.mix(Rgb::new(0, 0, 0), 300),
    base.mix(Rgb::new(0, 0, 0), 550),
  ])
}

///|
pub fn accent_palette(base : Rgb) -> Palette {
  Palette::new([base, complementary(base), base.mix(complementary(base), 500)])
}

///|
pub fn Palette::length(self : Palette) -> Int {
  self.colors.length()
}

///|
pub fn Palette::to_json(self : Palette) -> String {
  let buf = StringBuilder()
  buf.write_string("{\"colors\":[")
  for i = 0; i < self.colors.length(); i = i + 1 {
    if i > 0 {
      buf.write_char(',')
    }
    buf.write_string("\"" + self.colors[i].to_hex() + "\"")
  }
  buf.write_string("]}")
  buf.to_string()
}
