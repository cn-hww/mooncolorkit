///|
pub(all) struct SemanticTheme {
  name : String
  background : Rgb
  surface : Rgb
  text : Rgb
  muted_text : Rgb
  accent : Rgb
  on_accent : Rgb
} derive(Debug)

///|
pub fn SemanticTheme::build(
  name : String,
  background : Rgb,
  surface : Rgb,
  accent : Rgb,
) -> SemanticTheme {
  let text = readable_text_on(background)
  let muted_seed = text.mix(background, 450)
  let muted_fix = suggest_accessible_foreground(
    muted_seed,
    background,
    target_ratio_x100=450,
  )
  {
    name,
    background,
    surface,
    text,
    muted_text: muted_fix.suggested,
    accent,
    on_accent: readable_text_on(accent),
  }
}

///|
pub fn SemanticTheme::audit(self : SemanticTheme) -> AuditReport {
  audit_roles([
    ColorRole::new("text/background", self.text, self.background),
    ColorRole::new("muted/background", self.muted_text, self.background),
    ColorRole::new("text/surface", self.text, self.surface),
    ColorRole::new("on-accent/accent", self.on_accent, self.accent),
  ])
}

///|
pub fn SemanticTheme::to_design_tokens_json(self : SemanticTheme) -> String {
  "{\"$schema\":\"https://tr.designtokens.org/format/\",\"name\":\"\{self.name}\",\"color\":{\"background\":\{self.background.to_design_token_json()},\"surface\":\{self.surface.to_design_token_json()},\"text\":\{self.text.to_design_token_json()},\"mutedText\":\{self.muted_text.to_design_token_json()},\"accent\":\{self.accent.to_design_token_json()},\"onAccent\":\{self.on_accent.to_design_token_json()}}}"
}

///|
pub fn Rgb::to_design_token_json(self : Rgb) -> String {
  let r = self.r.to_double() / 255.0
  let g = self.g.to_double() / 255.0
  let b = self.b.to_double() / 255.0
  "{\"$type\":\"color\",\"$value\":{\"colorSpace\":\"srgb\",\"components\":[\{r},\{g},\{b}],\"alpha\":1,\"hex\":\"\{self.to_hex()}\"}}"
}

///|
pub fn SemanticTheme::to_css_vars(
  self : SemanticTheme,
  selector? : String = ":root",
) -> String {
  "\{selector} {\n  --color-background: \{self.background.to_hex()};\n  --color-surface: \{self.surface.to_hex()};\n  --color-text: \{self.text.to_hex()};\n  --color-muted-text: \{self.muted_text.to_hex()};\n  --color-accent: \{self.accent.to_hex()};\n  --color-on-accent: \{self.on_accent.to_hex()};\n}"
}
