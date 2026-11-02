// 40-pin GPIO header of the Raspberry Pi 5, drawn as a table.

#import "../src/lib.typ": *

#let erbe-blue = rgb(0, 175, 241)

#let _pins = (
  "3V3", "5V",
  "GPIO2 (SDA)", "5V",
  "GPIO3 (SCL)", "GND",
  "GPIO4", "GPIO14 (TXD)",
  "GND", "GPIO15 (RXD)",
  "GPIO17", "GPIO18 (PWM0)",
  "GPIO27", "GND",
  "GPIO22", "GPIO23",
  "3V3", "GPIO24",
  "GPIO10 (MOSI)", "GND",
  "GPIO9 (MISO)", "GPIO25",
  "GPIO11 (SCLK)", "GPIO8 (CE0)",
  "GND", "GPIO7 (CE1)",
  "GPIO0 (ID_SD)", "GPIO1 (ID_SC)",
  "GPIO5", "GND",
  "GPIO6", "GPIO12 (PWM0)",
  "GPIO13 (PWM1)", "GND",
  "GPIO19 (PWM1)", "GPIO16",
  "GPIO26", "GPIO20",
  "GND", "GPIO21",
)

#let _color(label) = if label == "3V3" {
  rgb("#f39c12")
} else if label == "5V" {
  rgb("#e74c3c")
} else if label == "GND" {
  luma(25%)
} else if label.ends-with(")") {
  rgb("#8e44ad")
} else {
  rgb("#27ae60")
}

#let _pin(number, label, highlight) = box(
  width: 0.5cm,
  height: 0.5cm,
  radius: if number == 1 { 0pt } else { 50% },
  fill: _color(label),
  stroke: if highlight { 2pt + erbe-blue } else { none },
  align(center + horizon, text(fill: white, size: sizes.script, weight: "bold", str(number))),
)

#let _label(label, highlight) = text(
  size: sizes.footnote,
  weight: if highlight { "bold" } else { "regular" },
  fill: if highlight { erbe-blue } else { black },
  label,
)

// `highlight`: pin numbers to mark.
#let pinout(highlight: ()) = {
  let cells = ()
  for row in range(20) {
    let odd = row * 2 + 1
    let even = odd + 1
    let left = _pins.at(odd - 1)
    let right = _pins.at(even - 1)
    cells += (
      _label(left, odd in highlight),
      _pin(odd, left, odd in highlight),
      _pin(even, right, even in highlight),
      _label(right, even in highlight),
    )
  }
  grid(
    columns: (1fr, auto, auto, 1fr),
    column-gutter: 4pt,
    row-gutter: 2pt,
    align: (right + horizon, center, center, left + horizon),
    ..cells,
  )
}

#let pinout-legend = {
  let item(color, body) = box[#box(width: 0.3cm, height: 0.3cm, radius: 50%, fill: color, baseline: 15%) #body]
  set text(size: sizes.footnote)
  item(rgb("#f39c12"))[3,3~V]
  h(1em)
  item(rgb("#e74c3c"))[5~V]
  h(1em)
  item(luma(25%))[GND]
  h(1em)
  item(rgb("#27ae60"))[GPIO]
  h(1em)
  item(rgb("#8e44ad"))[GPIO mit Sonderfunktion]
}
