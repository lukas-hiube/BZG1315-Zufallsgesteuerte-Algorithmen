# Projekt-Hinweise

## PDFs / Dokumentation erzeugen

Immer `make` im Projekt-Root verwenden, nie `latexmk` oder `pdflatex` direkt in den Vorlesungsordnern.
Das Makefile schreibt PDFs nach `out/<lecture>/<kind>.pdf` und alle Hilfsdateien (aux, log, nav, ...) nach `out/<lecture>/build/<kind>/`.
Direkte Aufrufe verschmutzen `lectures/` mit Build-Artefakten.

```
make                                         # alles bauen
make lattice_problems_and_lwe                # Handout + Präsentation einer Vorlesung
make lattice_problems_and_lwe/presentation   # einzelnes Dokument
make clean                                   # out/ leeren
```

Fehler stehen im Log unter `out/<lecture>/build/<kind>/<kind>.log`.

## Struktur

- `lectures/<lecture>/{handout,presentation}/<kind>.tex` mit Inhalten in `content/*.tex`
- `docs/` enthält HTML-Tools zur Veranschaulichung (`lattice_tool.html`, `lwe_tool.html`) und wird als GitHub Pages (Deploy from branch, `/docs`) ausgeliefert
- Folien und Notizen sind auf Deutsch. Begriffe wie SVP, CVP, LWE und deren englische Langform bleiben englisch.
