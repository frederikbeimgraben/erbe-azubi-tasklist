# ERBE Azubi-Aufgabenliste

Typst template for an apprentice (Azubi) task list at ERBE Elektromedizin:
A4 landscape, ERBE logo in the header, one task table, no title page.
Derived from [hsrtreport-typst](https://github.com/frederikbeimgraben/hsrtreport-typst)
(fonts and typography).

## Build

```sh
typst compile --font-path src/assets/fonts main.typ build/main.pdf
```

## Use

`main.typ` holds the document. Add tasks as rows, one entry per column:

```typ
#task-table(
  tasks: (
    ([1], [Lötübung], [SMD-Bauteile löten], [M. Muster], [03.11.2026], [07.11.2026], [offen], [], []),
  ),
  blank-rows: 10,
)
```

| Option | Default | Function |
| --- | --- | --- |
| `title` | `[Aufgabenliste Auszubildende]` | Header text and PDF title |
| `author` | `""` | Footer left and PDF author |
| `flipped` | `true` | Landscape page |
| `logo-height` | `0.9cm` | Height of the ERBE logo |
| `columns` (of `task-table`) | Nr., Aufgabe, Beschreibung, Ausbilder:in, Erteilt am, Fällig am, Status, Erledigt am, Bemerkung | `(header, width)` pairs |
| `blank-rows`, `blank-height` | `0`, `0.9cm` | Empty rows to fill in by hand |

## Logo

`src/assets/images/logos/ERBE.png` is the ERBE word mark, cut out of the
wallpaper in `erbe-nix-image` and recolored to ERBE blue. Replace it with the
official vector file when you have one.

## License

Code under MIT-0, design derived from HSRTReport under CC BY-SA 4.0. The ERBE
logo is a trademark of Erbe Elektromedizin GmbH and is not covered by these
licenses.
