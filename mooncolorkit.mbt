///|
pub(all) struct Rgb {
  r : Int
  g : Int
  b : Int
} derive(Debug, Eq)

///|
pub fn Rgb::new(r : Int, g : Int, b : Int) -> Rgb {
  { r: clamp_channel(r), g: clamp_channel(g), b: clamp_channel(b) }
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
