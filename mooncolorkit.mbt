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
