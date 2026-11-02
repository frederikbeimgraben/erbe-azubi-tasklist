# ERBE Aufgabenliste für Auszubildende

Task list for apprentices, built on the
[HSRTReport Typst template](https://github.com/frederikbeimgraben/hsrtreport-typst).
`src/` is the template; `main.typ` is the document.

Changes to the template:

- `variant: "erbe"` puts the ERBE logo (`src/assets/images/logos/ERBE.png`) in the footer.
- `show-titlepage: false` leaves out the title page.
- `skyline: false` leaves out the skyline.

## Build

```sh
typst compile --font-path src/assets/fonts main.typ build/main.pdf
```

The ERBE logo is cut from the wallpaper in `erbe-nix-image`. Replace it with the
official vector file when you have one. The logo is a trademark of Erbe
Elektromedizin GmbH and is not covered by the licenses of this repository.
