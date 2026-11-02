// Color code of resistors with four bands, with an example.

#import "../src/lib.typ": *

#let _colors = (
  // name, fill, digit, multiplier, tolerance
  ("Schwarz", rgb("#000000"), "0", [×1], []),
  ("Braun", rgb("#7b3f00"), "1", [×10], [±1~%]),
  ("Rot", rgb("#d62828"), "2", [×100], [±2~%]),
  ("Orange", rgb("#f77f00"), "3", [×1~k], []),
  ("Gelb", rgb("#fcd116"), "4", [×10~k], []),
  ("Grün", rgb("#2a9d38"), "5", [×100~k], [±0,5~%]),
  ("Blau", rgb("#1d4ed8"), "6", [×1~M], [±0,25~%]),
  ("Violett", rgb("#7e22ce"), "7", [×10~M], [±0,1~%]),
  ("Grau", rgb("#8d8d8d"), "8", [], [±0,05~%]),
  ("Weiß", rgb("#ffffff"), "9", [], []),
  ("Gold", rgb("#c9a227"), "–", [×0,1], [±5~%]),
  ("Silber", rgb("#c0c0c0"), "–", [×0,01], [±10~%]),
)

#let _fill(name) = _colors.find(c => c.at(0) == name).at(1)

// A resistor drawn with the given band colors (names from the table).
#let resistor(bands, width: 6cm) = {
  let body = width * 0.6
  let band-w = body / 12
  let lead = (width - body) / 2
  box(width: width, height: 1.4cm, {
    place(left + horizon, line(length: width, stroke: 1.5pt + luma(55%)))
    place(left + horizon, dx: lead, rect(
      width: body,
      height: 1.1cm,
      radius: 0.35cm,
      fill: rgb("#e9d8b4"),
      stroke: 0.5pt + luma(50%),
    ))
    // Three bands close together, the tolerance band set apart.
    let xs = (2, 4, 6, 9.5)
    for (i, name) in bands.enumerate() {
      place(left + horizon, dx: lead + band-w * xs.at(i), rect(
        width: band-w,
        height: 1.1cm,
        fill: _fill(name),
        stroke: 0.3pt + luma(40%),
      ))
    }
  })
}

#let _swatch(color) = box(
  width: 0.45cm,
  height: 0.3cm,
  fill: color,
  stroke: 0.3pt + luma(40%),
  baseline: 10%,
)

#let color-table = {
  set text(size: sizes.footnote)
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, left, center, center, center),
    inset: (x: 5pt, y: 3pt),
    table.header([], [*Farbe*], [*1./2. Ring \ Ziffer*], [*3. Ring \ Multiplikator*], [*4. Ring \ Toleranz*]),
    ..for (name, color, digit, mult, tol) in _colors {
      (_swatch(color), [#name], [#digit], mult, tol)
    },
  )
}

#let resistor-example = {
  set text(size: sizes.footnote)
  align(center, resistor(("Orange", "Orange", "Braun", "Gold")))
  v(0.3em)
  align(center, grid(
    columns: 4,
    column-gutter: 0.8em,
    [Orange: *3*], [Orange: *3*], [Braun: *×10*], [Gold: *±5~%*],
  ))
  v(0.3em)
  align(center)[33 × 10 = *330~Ω* ±5~%]
}
