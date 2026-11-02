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

= Raspberry Pi 5 einrichten

SD-Karte unter Windows mit dem Raspberry Pi Imager mit Raspberry Pi OS Lite
(headless) flashen und eine statische IP-Konfiguration setzen, sodass der Pi
über einen USB-Ethernet-Adapter erreichbar ist.

= SSH-Zugriff

Pi booten und SSH-Zugriff herstellen.

= Remote-Entwicklung mit VS Code

VS Code starten und eine Remote-Entwicklungsumgebung (Remote-SSH) auf dem Pi
öffnen.

= Python-Workspace

Ein Programm mit einer `pyproject.toml` paketieren und zum Laufen bringen.
Das Programm hat eine Funktion `main()` und einen Block
#box(`if __name__ == "__main__":`). Die `pyproject.toml` definiert ein Skript
"main", das auf `main()` zeigt.

= LED blinken lassen

Eine LED aus dem Programm über GPIO blinken lassen.

= LED-Helligkeit per PWM

Die Helligkeit der LED per PWM steuern.

= Mikrofon auslesen

Ein 4-Pin-Mikrofonmodul (A0, G, +, D0) anschließen und die Lautstärke auslesen.

= LED-Helligkeit nach Lautstärke

Die Helligkeit der LED abhängig von der Lautstärke steuern.
