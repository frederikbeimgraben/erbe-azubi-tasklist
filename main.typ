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
  align: (center + top, left + top, center + top, center + top),
  table.header(
    [*Nr.*], [*Aufgabe*], [*Datum*], [*Status*],
  ),
  [1], [Raspberry Pi 5 einrichten: SD-Karte unter Windows mit dem Raspberry Pi Imager mit Raspberry Pi OS Lite (headless) flashen und eine statische IP-Konfiguration setzen, sodass der Pi über einen USB-Ethernet-Adapter erreichbar ist], [], [],
  [2], [Pi booten und SSH-Zugriff herstellen], [], [],
  [3], [VS Code starten und eine Remote-Entwicklungsumgebung (Remote-SSH) auf dem Pi öffnen], [], [],
  [4], [Python-Workspace einrichten: Programm mit einer `pyproject.toml` paketieren, mit einer Funktion `main()`, einem Block #box(`if __name__ == "__main__":`) und einem Skript "main", das auf `main()` zeigt; Programm zum Laufen bringen], [], [],
  [5], [Eine LED aus dem Programm über GPIO blinken lassen], [], [],
  [6], [Die Helligkeit der LED per PWM steuern], [], [],
  [7], [Ein 4-Pin-Mikrofonmodul (A0, G, +, D0) anschließen und die Lautstärke auslesen], [], [],
  [8], [Die Helligkeit der LED abhängig von der Lautstärke steuern], [], [],
)
