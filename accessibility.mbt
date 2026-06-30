///|
pub(all) enum WcagLevel {
  Fail
  AA
  AAA
} derive(Debug, Eq)

///|
pub(all) struct ColorRole {
  name : String
  foreground : Rgb
  background : Rgb
  large_text : Bool
} derive(Debug)

///|
pub(all) struct ContrastAudit {
  name : String
  foreground : Rgb
  background : Rgb
  ratio_x100 : Int
  level : WcagLevel
  large_text : Bool
} derive(Debug)

///|
pub(all) struct AuditReport {
  audits : Array[ContrastAudit]
  passed_aa : Int
  passed_aaa : Int
  failed : Int
} derive(Debug)

///|
pub(all) struct RepairSuggestion {
  original : Rgb
  suggested : Rgb
  target_ratio_x100 : Int
  achieved_ratio_x100 : Int
  mix_weight_per_mille : Int
  achieved : Bool
} derive(Debug)

///|
pub fn ColorRole::new(
  name : String,
  foreground : Rgb,
  background : Rgb,
  large_text? : Bool = false,
) -> ColorRole {
  { name, foreground, background, large_text }
}

///|
pub fn classify_text_contrast(
  foreground : Rgb,
  background : Rgb,
  large_text? : Bool = false,
) -> WcagLevel {
  let ratio = contrast_ratio(foreground, background)
  if ratio >= 7.0 || (large_text && ratio >= 4.5) {
    WcagLevel::AAA
  } else if ratio >= 4.5 || (large_text && ratio >= 3.0) {
    WcagLevel::AA
  } else {
    WcagLevel::Fail
  }
}

///|
pub fn audit_role(role : ColorRole) -> ContrastAudit {
  {
    name: role.name,
    foreground: role.foreground,
    background: role.background,
    ratio_x100: contrast_ratio_x100(role.foreground, role.background),
    level: classify_text_contrast(
      role.foreground,
      role.background,
      large_text=role.large_text,
    ),
    large_text: role.large_text,
  }
}

///|
pub fn audit_roles(roles : Array[ColorRole]) -> AuditReport {
  let audits : Array[ContrastAudit] = []
  let mut passed_aa = 0
  let mut passed_aaa = 0
  let mut failed = 0
  for role in roles {
    let audit = audit_role(role)
    match audit.level {
      WcagLevel::AAA => {
        passed_aa = passed_aa + 1
        passed_aaa = passed_aaa + 1
      }
      WcagLevel::AA => passed_aa = passed_aa + 1
      WcagLevel::Fail => failed = failed + 1
    }
    audits.push(audit)
  }
  { audits, passed_aa, passed_aaa, failed }
}

///|
fn level_name(level : WcagLevel) -> String {
  match level {
    WcagLevel::Fail => "FAIL"
    WcagLevel::AA => "AA"
    WcagLevel::AAA => "AAA"
  }
}

///|
pub fn ContrastAudit::to_json(self : ContrastAudit) -> String {
  "{\"name\":\"\{self.name}\",\"foreground\":\"\{self.foreground.to_hex()}\",\"background\":\"\{self.background.to_hex()}\",\"ratio_x100\":\{self.ratio_x100},\"level\":\"\{level_name(self.level)}\",\"large_text\":\{self.large_text}}"
}

///|
pub fn AuditReport::to_json(self : AuditReport) -> String {
  let buf = StringBuilder()
  buf.write_string(
    "{\"summary\":{\"total\":\{self.audits.length()},\"passed_aa\":\{self.passed_aa},\"passed_aaa\":\{self.passed_aaa},\"failed\":\{self.failed}},\"audits\":[",
  )
  for i = 0; i < self.audits.length(); i = i + 1 {
    if i > 0 {
      buf.write_char(',')
    }
    buf.write_string(self.audits[i].to_json())
  }
  buf.write_string("]}")
  buf.to_string()
}

///|
fn first_passing_mix(
  foreground : Rgb,
  background : Rgb,
  target : Rgb,
  target_ratio_x100 : Int,
) -> RepairSuggestion {
  let target_ratio = target_ratio_x100.to_double() / 100.0
  let mut weight = 0
  let mut candidate = foreground
  let mut ratio = contrast_ratio(candidate, background)
  while weight < 1000 && ratio < target_ratio {
    weight = weight + 10
    candidate = foreground.mix(target, weight)
    ratio = contrast_ratio(candidate, background)
  }
  {
    original: foreground,
    suggested: candidate,
    target_ratio_x100,
    achieved_ratio_x100: (ratio * 100.0).round().to_int(),
    mix_weight_per_mille: weight,
    achieved: ratio >= target_ratio,
  }
}

///|
pub fn suggest_accessible_foreground(
  foreground : Rgb,
  background : Rgb,
  target_ratio_x100? : Int = 450,
) -> RepairSuggestion {
  let current = contrast_ratio(foreground, background)
  if current >= target_ratio_x100.to_double() / 100.0 {
    return {
      original: foreground,
      suggested: foreground,
      target_ratio_x100,
      achieved_ratio_x100: (current * 100.0).round().to_int(),
      mix_weight_per_mille: 0,
      achieved: true,
    }
  }
  let toward_black = first_passing_mix(
    foreground,
    background,
    Rgb::new(0, 0, 0),
    target_ratio_x100,
  )
  let toward_white = first_passing_mix(
    foreground,
    background,
    Rgb::new(255, 255, 255),
    target_ratio_x100,
  )
  if toward_black.achieved &&
    (
      !toward_white.achieved ||
      toward_black.mix_weight_per_mille <= toward_white.mix_weight_per_mille
    ) {
    toward_black
  } else {
    toward_white
  }
}

///|
pub fn RepairSuggestion::to_json(self : RepairSuggestion) -> String {
  "{\"original\":\"\{self.original.to_hex()}\",\"suggested\":\"\{self.suggested.to_hex()}\",\"target_ratio_x100\":\{self.target_ratio_x100},\"achieved_ratio_x100\":\{self.achieved_ratio_x100},\"mix_weight_per_mille\":\{self.mix_weight_per_mille},\"achieved\":\{self.achieved}}"
}
