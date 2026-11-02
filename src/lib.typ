// ERBE Azubi-Aufgabenliste - task list for apprentices at ERBE Elektromedizin.
// Derived from the HSRTReport Typst template (fonts, typography, footer).

#import "config/fonts.typ": *
#import "config/colors.typ": *

#let _logo = "assets/images/logos/ERBE.png"

// Default columns of the task table: (header, width).
#let default-columns = (
  ([Nr.], auto),
  ([Aufgabe], 2fr),
  ([Beschreibung], 3fr),
  ([Ausbilder:in], 1.2fr),
  ([Erteilt am], 1fr),
  ([Fällig am], 1fr),
  ([Status], 1fr),
  ([Erledigt am], 1fr),
  ([Bemerkung], 2fr),
)

#let _header(title, logo-height) = grid(
  columns: (1fr, auto),
  align: (left + bottom, right + bottom),
  blender(size: sizes.LARGE, weight: "bold", title),
  image(_logo, height: logo-height),
)

#let _footer(author) = context {
  let current = counter(page).get().first()
  let total = counter(page).final().first()
  text(font: heading-font, size: sizes.normal, fill: head-foot-color, grid(
    columns: (1fr, auto, 1fr),
    align: (left, center, right),
    author,
    [Seite~#current~von~#total],
    [],
  ))
}

// The task table. `tasks` is an array of rows, each an array with one cell
// per column. `blank-rows` adds empty rows of `blank-height` to fill in by hand.
#let task-table(
  tasks: (),
  columns: default-columns,
  blank-rows: 0,
  blank-height: 0.9cm,
) = {
  let n = columns.len()
  let rows = tasks.map(row => row + ([],) * (n - row.len()))
  rows += (([],) * n,) * blank-rows
  table(
    columns: columns.map(c => c.at(1)),
    rows: (auto,) * (1 + tasks.len()) + (blank-height,) * blank-rows,
    stroke: 0.5pt + luma(60%),
    inset: (x: 5pt, y: 6pt),
    fill: (_, y) => if y == 0 { erbe-blue } else if calc.even(y) { row-tint },
    align: left + horizon,
    table.header(
      ..columns.map(c => text(
        font: heading-font,
        weight: "bold",
        fill: white,
        c.at(0),
      )),
    ),
    ..rows.flatten(),
  )
}

#let tasklist(
  title: [Aufgabenliste Auszubildende],
  author: "",
  paper: "a4",
  flipped: true,
  margin: (x: 1.5cm, top: 3cm, bottom: 2cm),
  logo-height: 0.9cm,
  font-size: sizes.small,
  lang: "de",
  body,
) = {
  set document(title: title, author: author)
  set text(font: body-font, size: font-size, lang: lang, hyphenate: true)
  set par(justify: false, leading: 0.55em)
  set page(
    paper: paper,
    flipped: flipped,
    margin: margin,
    header-ascent: 30%,
    header: _header(title, logo-height),
    footer: _footer(author),
  )
  body
}
