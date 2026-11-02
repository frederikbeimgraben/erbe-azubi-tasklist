// Aufgabenliste für Auszubildende, built on the HSRTReport template.

#import "src/lib.typ": *

#show: hsrtreport.with(
  title: [Azubi Raspberry-Pi],
  author: "",
  variant: "erbe",
  show-titlepage: false,
  show-toc: false,
  skyline: false,
)

#let res(url, body) = [#body: #link(url)]

= Raspberry Pi 5 einrichten

#unnumbered(level: 3)[Ziel]

Eine microSD-Karte unter Windows mit dem Raspberry Pi Imager mit Raspberry Pi
OS Lite (headless, ohne Desktop) beschreiben. Der Pi bekommt eine statische
IP-Adresse und ist danach direkt über ein Netzwerkkabel erreichbar, das am
Windows-PC an einem USB-Ethernet-Adapter steckt.

#unnumbered(level: 3)[Vorgehen]

+ Raspberry Pi Imager (Version 2.0 oder neuer) unter Windows installieren und
  starten.
+ Als Gerät _Raspberry Pi 5_ wählen, als Betriebssystem
  _Raspberry Pi OS (other) → Raspberry Pi OS Lite (64-bit)_ und als Ziel die
  microSD-Karte.
+ Im Anpassungsschritt festlegen:
  - Hostname, z.~B. `azubi-pi`
  - Benutzername und Passwort
  - Zeitzone und Tastaturlayout (`Europe/Berlin`, `de`)
  - SSH aktivieren (Anmeldung mit Passwort genügt für den Anfang)
  - WLAN leer lassen
+ Karte schreiben lassen. Danach die Karte nicht sofort einsetzen, sondern
  neu in den PC stecken: Windows zeigt die Boot-Partition `bootfs` als
  Laufwerk.
+ In `bootfs` die Datei `network-config` mit einem Texteditor öffnen und für
  die Ethernet-Schnittstelle des Pi eine feste Adresse eintragen:
  ```yaml
  network:
    version: 2
    renderer: NetworkManager
    ethernets:
      eth0:
        dhcp4: false
        addresses:
          - 192.168.50.2/24
        optional: true
  ```
+ Am Windows-PC dem USB-Ethernet-Adapter eine feste Adresse im selben Netz
  geben: _Einstellungen → Netzwerk und Internet → Ethernet (Adapter) →
  IP-Zuweisung → Bearbeiten → Manuell_, IPv4 `192.168.50.1`, Subnetzmaske
  `255.255.255.0`, kein Gateway.

#unnumbered(level: 3)[Hinweise]

- Seit dem Raspberry Pi OS auf Basis von Debian Trixie (November 2025)
  übernimmt cloud-init die Ersteinrichtung. Die Dateien `user-data` und
  `network-config` in `bootfs` werden nur beim *ersten* Start gelesen. Wer
  sich vertippt hat, flasht die Karte am einfachsten neu.
- YAML ist empfindlich gegenüber Einrückungen: nur Leerzeichen, keine Tabs.
- Die Onboard-Ethernet-Buchse des Pi 5 heißt `eth0`. Der USB-Adapter steckt
  am PC, nicht am Pi.

#unnumbered(level: 3)[Ressourcen]

- #res("https://www.raspberrypi.com/software/")[Raspberry Pi Imager]
- #res("https://www.raspberrypi.com/documentation/computers/getting-started.html")[Raspberry Pi Doku: Getting started]
- #res("https://www.raspberrypi.com/news/cloud-init-on-raspberry-pi-os/")[Raspberry Pi News: cloud-init on Raspberry Pi OS]
- #res("https://netplan.readthedocs.io/en/stable/netplan-yaml/")[Netplan: YAML-Referenz]

= SSH-Zugriff

#unnumbered(level: 3)[Ziel]

Den Pi starten und sich vom Windows-PC aus per SSH anmelden, erst mit
Passwort, dann mit einem SSH-Schlüssel.

#unnumbered(level: 3)[Vorgehen]

+ microSD-Karte einsetzen, Netzwerkkabel zwischen Pi und USB-Ethernet-Adapter
  stecken, Pi mit dem Netzteil (5~V, 5~A, USB-C) starten. Der erste Start
  dauert etwas länger.
+ In PowerShell prüfen, ob der Pi antwortet: `ping 192.168.50.2`
+ Anmelden: `ssh <benutzer>@192.168.50.2` und den Fingerprint beim ersten
  Mal mit `yes` bestätigen.
+ System aktualisieren: `sudo apt update && sudo apt full-upgrade -y`
+ Schlüsselpaar unter Windows erzeugen: `ssh-keygen -t ed25519`
+ Öffentlichen Schlüssel auf den Pi kopieren (Windows hat kein
  `ssh-copy-id`):
  ```powershell
  type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh <benutzer>@192.168.50.2 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
  ```
+ Einen Eintrag in `%USERPROFILE%\.ssh\config` anlegen, damit `ssh azubi-pi`
  genügt:
  ```
  Host azubi-pi
      HostName 192.168.50.2
      User <benutzer>
  ```

#unnumbered(level: 3)[Hinweise]

- Antwortet der Pi nicht: Adapter-IP unter Windows prüfen (`ipconfig`), die
  LEDs an der Netzwerkbuchse beobachten und `network-config` auf Tippfehler
  prüfen.
- Ohne statische IP hilft oft der Hostname: `ssh <benutzer>@azubi-pi.local`.

#unnumbered(level: 3)[Ressourcen]

- #res("https://www.raspberrypi.com/documentation/computers/remote-access.html")[Raspberry Pi Doku: Remote access]
- #res("https://learn.microsoft.com/de-de/windows-server/administration/openssh/openssh_install_firstuse")[Microsoft: OpenSSH unter Windows]
- #res("https://learn.microsoft.com/de-de/windows-server/administration/openssh/openssh_keymanagement")[Microsoft: Schlüsselverwaltung für OpenSSH]

= Remote-Entwicklung mit VS Code

#unnumbered(level: 3)[Ziel]

Mit VS Code unter Windows direkt auf dem Pi arbeiten: Dateien bearbeiten,
Terminal nutzen und Programme ausführen, alles über SSH.

#unnumbered(level: 3)[Vorgehen]

+ VS Code unter Windows installieren.
+ Die Erweiterung _Remote - SSH_ (`ms-vscode-remote.remote-ssh`) installieren.
+ Befehlspalette öffnen (`F1`) → _Remote-SSH: Connect to Host…_ →
  `azubi-pi` wählen. Als Plattform _Linux_ angeben. VS Code installiert beim
  ersten Verbinden seinen Server auf dem Pi.
+ Unten links zeigt VS Code jetzt _SSH: azubi-pi_. Über _File → Open Folder_
  einen Ordner im Home-Verzeichnis des Pi öffnen, z.~B. `~/projekte`.
+ Im verbundenen Fenster die Erweiterung _Python_ (`ms-python.python`)
  installieren. Sie läuft auf dem Pi, nicht unter Windows.
+ Ein Terminal öffnen (`Strg+ö`) und prüfen, dass es auf dem Pi läuft:
  `hostname`

#unnumbered(level: 3)[Hinweise]

- Remote-SSH nutzt den Eintrag aus `~/.ssh/config` aus dem vorigen Kapitel.
- Der VS-Code-Server braucht ein 64-Bit-System, daher Raspberry Pi OS 64-bit.

#unnumbered(level: 3)[Ressourcen]

- #res("https://code.visualstudio.com/")[VS Code]
- #res("https://code.visualstudio.com/docs/remote/ssh")[VS Code Doku: Remote Development using SSH]
- #res("https://code.visualstudio.com/docs/remote/ssh-tutorial")[VS Code Tutorial: Remote via SSH]

= Python-Workspace

#unnumbered(level: 3)[Ziel]

Ein Python-Projekt anlegen, das mit einer `pyproject.toml` paketiert ist und
über den Befehl `main` gestartet wird. Das Programm hat eine Funktion
`main()` und einen Block #box(`if __name__ == "__main__":`).

#unnumbered(level: 3)[Vorgehen]

+ Benötigte Pakete installieren:
  `sudo apt install -y python3-venv python3-gpiozero python3-lgpio`
+ Projektordner mit dieser Struktur anlegen:
  ```
  ~/projekte/blinky/
  ├── pyproject.toml
  └── src/
      └── blinky/
          ├── __init__.py
          └── main.py
  ```
+ `pyproject.toml` schreiben:
  ```toml
  [build-system]
  requires = ["setuptools>=61"]
  build-backend = "setuptools.build_meta"

  [project]
  name = "blinky"
  version = "0.1.0"
  requires-python = ">=3.11"
  dependencies = ["gpiozero"]

  [project.scripts]
  main = "blinky.main:main"
  ```
+ `src/blinky/main.py` schreiben:
  ```python
  def main() -> None:
      print("Hallo vom Raspberry Pi!")


  if __name__ == "__main__":
      main()
  ```
+ Virtuelle Umgebung anlegen und das Projekt editierbar installieren:
  ```sh
  cd ~/projekte/blinky
  python3 -m venv --system-site-packages .venv
  source .venv/bin/activate
  pip install -e .
  ```
+ Das Programm auf zwei Wegen starten: `main` (über das Skript aus der
  `pyproject.toml`) und `python -m blinky.main` (über den `__main__`-Block).
+ In VS Code unten rechts den Interpreter `.venv` auswählen.

#unnumbered(level: 3)[Hinweise]

- Raspberry Pi OS erlaubt `pip install` nicht systemweit (PEP 668). Deshalb
  die virtuelle Umgebung.
- `--system-site-packages` macht die per `apt` installierten Pakete
  `gpiozero` und `lgpio` in der Umgebung sichtbar.
- Mit `pip install -e .` wirken Änderungen am Code sofort, ohne neue
  Installation.

#unnumbered(level: 3)[Ressourcen]

- #res("https://packaging.python.org/en/latest/guides/writing-pyproject-toml/")[Python Packaging: Writing your pyproject.toml]
- #res("https://packaging.python.org/en/latest/guides/writing-pyproject-toml/#creating-executable-scripts")[Python Packaging: Executable scripts]
- #res("https://docs.python.org/3/library/__main__.html")[Python Doku: `__main__`]
- #res("https://docs.python.org/3/library/venv.html")[Python Doku: `venv`]
- #res("https://peps.python.org/pep-0668/")[PEP 668]

= LED blinken lassen

#unnumbered(level: 3)[Ziel]

Eine LED an einem GPIO-Pin aus dem Python-Programm im Sekundentakt blinken
lassen.

#unnumbered(level: 3)[Vorgehen]

+ Pi ausschalten, bevor etwas verkabelt wird.
+ Auf dem Steckbrett verkabeln: GPIO17 (Pin 11) → Vorwiderstand 330~Ω →
  Anode der LED (langes Bein); Kathode (kurzes Bein) → GND (Pin 9).
+ In `main()` die LED mit `gpiozero.LED(17)` ansteuern: einmal mit einer
  eigenen Schleife aus `on()`, `off()` und `time.sleep()`, einmal mit
  `blink()`.
+ Programm mit `main` starten und mit `Strg+C` sauber beenden. Den
  `KeyboardInterrupt` abfangen, damit keine Fehlermeldung erscheint.

#unnumbered(level: 3)[Hinweise]

- Die GPIO-Pins arbeiten mit 3,3~V und vertragen keine 5~V.
- Der Vorwiderstand ist Pflicht. Ohne ihn können LED und GPIO-Pin kaputtgehen.
- Ältere Anleitungen nutzen `RPi.GPIO`. Diese Bibliothek funktioniert auf dem
  Pi 5 nicht, weil die GPIOs dort am RP1-Chip hängen. `gpiozero` nutzt
  automatisch `lgpio`.
- Pinbelegung auf dem Pi anzeigen: `pinout`

#unnumbered(level: 3)[Ressourcen]

- #res("https://gpiozero.readthedocs.io/en/stable/recipes.html")[gpiozero: Basic recipes]
- #res("https://gpiozero.readthedocs.io/en/stable/api_output.html")[gpiozero: Output devices]
- #res("https://pinout.xyz/")[Pinout-Übersicht]
- #res("https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#gpio")[Raspberry Pi Doku: GPIO]

= LED-Helligkeit per PWM

#unnumbered(level: 3)[Ziel]

Die Helligkeit der LED stufenlos über Pulsweitenmodulation (PWM) steuern und
die LED langsam auf- und abblenden lassen.

#unnumbered(level: 3)[Vorgehen]

+ Verkabelung aus dem vorigen Kapitel beibehalten.
+ Statt `LED` die Klasse `gpiozero.PWMLED(17)` nutzen. Die Eigenschaft
  `value` setzt die Helligkeit von `0.0` (aus) bis `1.0` (voll).
+ In einer Schleife die Helligkeit in kleinen Schritten von 0 auf 1 und
  zurück ändern.
+ Danach dasselbe mit `pulse()` lösen und die Ergebnisse vergleichen.
+ Erklären können: Was ist der Tastgrad (Duty Cycle), und warum flackert die
  LED bei einer ausreichend hohen Frequenz nicht sichtbar?

#unnumbered(level: 3)[Hinweise]

- `PWMLED` nutzt Software-PWM mit 100~Hz. Das reicht für eine LED.
- Das Auge empfindet Helligkeit nicht linear. Eine quadratische Kurve
  (`value = x ** 2`) wirkt gleichmäßiger.

#unnumbered(level: 3)[Ressourcen]

- #res("https://gpiozero.readthedocs.io/en/stable/api_output.html#pwmled")[gpiozero: `PWMLED`]
- #res("https://de.wikipedia.org/wiki/Pulsdauermodulation")[Wikipedia: Pulsdauermodulation]

= Mikrofon digital auslesen

#unnumbered(level: 3)[Ziel]

Das 4-Pin-Mikrofonmodul (A0, G, +, D0) anschließen und über den digitalen
Ausgang D0 erkennen, ob es laut (1) oder leise (0) ist. Die Schaltschwelle wird
am Potentiometer des Moduls eingestellt.

#unnumbered(level: 3)[Vorgehen]

+ Pi ausschalten, bevor etwas verkabelt wird.
+ Modul verkabeln: `+` → 3,3~V (Pin 17), `G` → GND (Pin 14), `D0` → GPIO27
  (Pin 13). `A0` bleibt frei.
+ Pi starten und `D0` mit `gpiozero.DigitalInputDevice(27)` lesen. Den Wert
  `value` in einer Schleife ausgeben.
+ Schwelle einstellen: In Ruhe das Potentiometer mit einem kleinen
  Schraubendreher drehen, bis die Signal-LED auf dem Modul gerade eben
  ausgeht und das Programm dauerhaft 0 liest. Dann klatschen: Der Wert muss
  kurz auf 1 springen.
+ Statt ständig abzufragen, mit `when_activated` eine Funktion aufrufen
  lassen, die jedes Klatschen zählt und ausgibt.
+ Erweiterung: Die LED aus Kapitel 5 bei jedem Klatschen umschalten.

#unnumbered(level: 3)[Hinweise]

- Das Modul mit 3,3~V betreiben, nicht mit 5~V. Sonst liegen am GPIO-Pin
  5~V an, und der Pin kann kaputtgehen.
- Je nach Modul ist `D0` bei Lärm 1 oder 0. Mit `active_state` bzw.
  `pull_up` lässt sich das in gpiozero anpassen.
- `D0` liefert nur „laut“ oder „leise“, keinen Pegel. Für einen echten
  Lautstärkewert folgt das nächste Kapitel.

#unnumbered(level: 3)[Ressourcen]

- #res("https://gpiozero.readthedocs.io/en/stable/api_input.html")[gpiozero: Input devices]
- #res("https://pinout.xyz/")[Pinout-Übersicht]

= USB-Mikrofon analog auslesen

#unnumbered(level: 3)[Ziel]

Mit einem USB-Mikrofon die Lautstärke als Zahl messen, laufend und mit
Werten zwischen leise und laut.

#unnumbered(level: 3)[Vorgehen]

+ USB-Mikrofon anstecken und prüfen, ob der Pi es erkennt: `arecord -l`.
  Die Ausgabe nennt Karte und Gerät, z.~B. `card 2, device 0`.
+ Eine Testaufnahme machen und unter Windows anhören (in VS Code
  herunterladen):
  ```sh
  arecord -D plughw:2,0 -f S16_LE -r 44100 -c 1 -d 5 test.wav
  ```
+ Bei Bedarf die Verstärkung mit `alsamixer` anpassen (`F6` → Mikrofon
  wählen).
+ Benötigte Pakete installieren:
  `sudo apt install -y python3-numpy libportaudio2`, danach in der `.venv`:
  `pip install sounddevice`. `sounddevice` und `numpy` auch unter
  `dependencies` in die `pyproject.toml` eintragen.
+ Mit `sounddevice.query_devices()` das Mikrofon in der Geräteliste finden.
+ Mit `sounddevice.InputStream` kurze Blöcke (z.~B. 1024 Samples) aufnehmen
  und pro Block den Effektivwert berechnen:
  ```python
  rms = numpy.sqrt(numpy.mean(block ** 2))
  ```
+ Den Wert laufend ausgeben, zusätzlich in Dezibel relativ zum Vollausschlag:
  `20 * numpy.log10(rms)`. Ruhe, Sprechen und Klatschen vergleichen und die
  Werte notieren.

#unnumbered(level: 3)[Hinweise]

- `sounddevice` liefert die Samples als `numpy`-Array mit Werten zwischen
  −1 und 1.
- In der Callback-Funktion des Streams nur rechnen und den Wert ablegen,
  nichts Langsames wie `print()` in jedem Durchlauf.
- Bei `log10(0)` gibt es einen Fehler. Einen kleinen Wert addieren, z.~B.
  `rms + 1e-9`.

#unnumbered(level: 3)[Ressourcen]

- #res("https://python-sounddevice.readthedocs.io/")[python-sounddevice: Doku]
- #res("https://manpages.debian.org/arecord")[Manpage: `arecord`]
- #res("https://numpy.org/doc/stable/user/absolute_beginners.html")[NumPy: Einstieg]
- #res("https://de.wikipedia.org/wiki/Effektivwert")[Wikipedia: Effektivwert]

= LED-Helligkeit nach Lautstärke

#unnumbered(level: 3)[Ziel]

Die Helligkeit der LED folgt der Lautstärke vom USB-Mikrofon: leise →
dunkel, laut → hell.

#unnumbered(level: 3)[Vorgehen]

+ Die LED aus Kapitel 6 (`PWMLED`) und das USB-Mikrofon aus Kapitel 8
  zusammen verwenden.
+ Die Lautstärkemessung in eine eigene Funktion auslagern, die einen Wert
  zurückgibt.
+ Den Wertebereich kalibrieren: Messwert in Ruhe und bei lautem Geräusch
  notieren und als Minimum und Maximum festlegen.
+ Den Messwert auf 0 bis 1 abbilden und begrenzen:
  `max(0.0, min(1.0, (x - minimum) / (maximum - minimum)))`
+ Den Wert an `PWMLED.value` übergeben und das in einer Schleife wiederholen.
+ Den Wert glätten, damit die LED nicht flackert, z.~B. mit
  `neu = 0.8 * alt + 0.2 * messung`.
+ Erweiterung: Die Abbildung über die Dezibel-Werte statt über den
  Effektivwert machen und vergleichen, was sich natürlicher anfühlt.

#unnumbered(level: 3)[Hinweise]

- Den Code in Funktionen aufteilen (Messen, Abbilden, Glätten, Ausgeben). Das
  macht ihn testbar und lesbar.
- Minimum und Maximum als Konstanten oben im Modul ablegen, damit sie leicht
  anzupassen sind.

#unnumbered(level: 3)[Ressourcen]

- #res("https://gpiozero.readthedocs.io/en/stable/api_output.html#pwmled")[gpiozero: `PWMLED`]
- #res("https://de.wikipedia.org/wiki/Exponentielle_Glättung")[Wikipedia: Exponentielle Glättung]
