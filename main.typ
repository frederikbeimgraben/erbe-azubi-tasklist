// Aufgabenliste für Auszubildende, built on the HSRTReport template.

#import "src/lib.typ": *

#show: hsrtreport.with(
  title: [Aufgabenliste Auszubildende],
  author: "",
  variant: "erbe",
  show-titlepage: false,
  show-toc: false,
  skyline: false,
)

#heading(numbering: none)[Aufgabenliste]

#table(
  columns: (auto, 1fr, auto, auto),
  align: (center, left, center, center),
  table.header(
    [*Nr.*], [*Aufgabe*], [*Datum*], [*Status*],
  ),
  // [1], [...], [01.11.2026], [offen],
)
