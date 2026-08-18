# Polovni automobili — pretraga i rangiranje pomoću Claude Code

Ovo je **skup vođenih pretraga polovnih automobila** sa sajta
[polovniautomobili.com](https://www.polovniautomobili.com), gde oglase povlači i rangira
Claude Code (AI agent u terminalu), a rezultat je statična HTML stranica koju otvoriš u
browseru.

U repozitorijumu su tri gotove pretrage (folderi `1/`, `2/`, `3/`) — one služe i kao
rezultat i kao **primer** kako da napraviš svoju, četvrtu pretragu po sopstvenim
kriterijumima.

> Ako nikad nisi koristio Claude Code, kreni redom od sekcije **1. Instalacija**.

---

## 1. Instalacija Claude CLI

Claude Code je alat koji se pokreće iz terminala. Potrebno ti je:

- **Node.js 18+** — [nodejs.org](https://nodejs.org) (time dobijaš i `npx`, koji je neophodan za MCP server ispod)
- **Claude nalog** (Pro/Max pretplata ili Anthropic API kredit)

Instalacija:

```bash
npm install -g @anthropic-ai/claude-code
```

Provera i prvo pokretanje:

```bash
claude --version
cd "putanja/do/polovni-automobili"
claude
```

Pri prvom pokretanju otvoriće se prijava kroz browser. Kad vidiš prompt (`>`), Claude je
spreman i **radi u folderu iz koga si ga pokrenuo** — zato je važno da prvo uđeš u folder
ovog projekta.

Korisne komande unutar Claude sesije:

| Komanda | Šta radi |
|---|---|
| `/mcp` | prikazuje status MCP servera (da li je `chrome-devtools` povezan) |
| `/clear` | briše kontekst i počinje razgovor iz početka |
| `/help` | spisak svih komandi |
| `Esc` | prekida Claude-a usred rada |

---

## 2. Šta je `.mcp.json` i zašto je ovde

**MCP (Model Context Protocol)** je standard kojim Claude dobija dodatne „alate" —
programe koji rade ono što sam model ne može (npr. da upravljaju browserom).
Fajl `.mcp.json` u korenu projekta govori Claude Code-u koje MCP servere da pokrene kad
se otvori sesija u ovom folderu:

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest"]
    }
  }
}
```

Znači: „pokreni server pod imenom `chrome-devtools` komandom `npx -y chrome-devtools-mcp@latest`".
`npx -y` sam skida paket pri prvom pokretanju, pa nema ručne instalacije.

**Zašto baš browser server?** Sajt polovniautomobili.com blokira obično preuzimanje
stranica (`WebFetch` vraća HTTP 403). Preko `chrome-devtools` MCP-a Claude otvara pravi
Chrome, navigira na sajt i čita sadržaj isto kao čovek — pa filteri, oglasi i detalji
postaju dostupni.

Šta taj alat omogućava (najkorišćenije):

- `navigate_page` — otvori URL
- `evaluate_script` — pokreni JavaScript na otvorenoj stranici (ovako se masovno povlače oglasi)
- `take_snapshot` — pročitaj sadržaj stranice
- `take_screenshot` — slika stranice
- `list_pages` / `new_page` — rad sa više tabova

**Prvo pokretanje:** kad prvi put uđeš u sesiju, Claude Code će pitati da li dozvoljavaš
MCP server iz ovog projekta — potvrdi sa **Yes**. Status proveri komandom `/mcp`
(treba da piše da je `chrome-devtools` povezan). Chrome mora biti instaliran na računaru.

---

## 3. Kako da kažeš Claude-u da koristi ovaj MCP

Claude neće uvek sam pogoditi da mu treba browser — **reci mu izričito**. Primeri
promptova koje možeš da nalepiš:

**Otvaranje jednog oglasa:**

```
Koristi chrome-devtools MCP: navigate_page na
https://www.polovniautomobili.com/auto-oglasi/29362524/hyundai-ix35-20-dohc
pa mi preko take_snapshot izvuci cenu, godište, kilometražu, kubikažu, snagu,
gorivo, menjač i opis. WebFetch ne radi na ovom sajtu (403).
```

**Masovno povlačenje sa filtera:**

```
Koristi chrome-devtools MCP. Prvo navigate_page na polovniautomobili.com (zbog
same-origin pravila), pa iz evaluate_script pusti fetch() ka URL-u pretrage i
isparsiraj sve oglase. Ne koristi take_snapshot na listi rezultata — prevelika je;
veliki JSON snimi na disk preko filePath argumenta evaluate_script-a.
```

**Provera da li je motor turbo ili atmosferski:**

```
Za svaki oglas iz liste otvori stranicu oglasa kroz chrome-devtools MCP i pročitaj
KUBIKAŽU i broj brzina — naslov oglasa ne razlikuje atmo od turba.
```

Dva pravila koja se najviše isplate (naučena kroz ove pretrage):

1. **`navigate_page` na polovniautomobili.com PRE `fetch()`** — inače CORS blokira zahtev.
2. **Ne oslanjaj se na CSS klase** — sajt ih menja. Gotova, selektor-nezavisna skripta za
   povlačenje oglasa je u [1/instructions.md](1/instructions.md) — samo je nalepi u
   `evaluate_script`.

---

## 4. Šta je u kom folderu

Svaki broj je jedna **završena pretraga**: kriterijumi kupca + povučeni oglasi + rangiranje
+ HTML prikaz.

### [index.html](index.html) — početna strana
Raskrsnica ka sve tri pretrage: kratak opis svake, budžet, filteri, datum ažuriranja i broj
rangiranih oglasa. Ima i prekidač za svetlu/tamnu temu. **Odavde počni** — otvori je duplim
klikom u browseru.

### [1/](1/) — atmosferski benzin, porodični auto (4.000–8.000 €)
Pretraga za kupca sa malom kilometražom (~6.000 km/god), gde dizel otpada zbog DPF-a.
Traži se karavan / SUV / monovolumen, isključivo benzin, po mogućstvu bez turba i sa lancem.

- [1/index.html](1/index.html) — rang-lista sa obrazloženjima
- [1/instructions.md](1/instructions.md) — **tehnički recept**: kriterijumi, kodovi filtera
  sajta (gorivo, karoserija, region) i gotova JS skripta za `evaluate_script` sa funkcijama
  `paBatch` (masovna pretraga) i `paVerify` (provera motora po kubikaži i specifičnoj snazi)
- [1/car-results/car-results.md](1/car-results/car-results.md) — jedinstvena tabela svih kandidata, od najboljeg ka najgorem
- [1/teorija/](1/teorija/) — objašnjenja za laike (`.md` + `.html`): atmo vs turbo, MPI vs GDI,
  lanac vs kais, godišnja kilometraža, potrošnja goriva

### [2/](2/) — dizel ravnopravan sa benzinom (do ~9.000 €)
Kupac prelazi ~9.000 km/god (6k put + 3k grad), pa dizel nije unapred odbačen — ali samo
dokazani motori bez problematičnog DPF/EGR/dvomasenog zamajca.

- [2/index.html](2/index.html) — rangiranje, uključujući lokacije prodavaca na Google mapama
- [2/cars.md](2/cars.md) — originalni prompt/kriterijumi koje je kupac zadao
- [2/data/](2/data/) — po jedan `.md` fajl za svaki povučen oglas (33 fajla), sa URL-om, ID-em i datumom povlačenja

### [3/](3/) — svih 60 oglasa sa jednog filtera (benzin, do 8.000 €, 2011+)
Najsistematičnija pretraga: umesto biranja modela unapred, povučen je **svaki aktivni oglas**
koji zadovoljava filter (limuzina/karavan/SUV, region Niš), pa je tek onda rangirano.

- [3/index.html](3/index.html) — kompletan pregled svih 60 oglasa
- [3/instructions.md](3/instructions.md) — zadatak za agenta: kriterijumi, tačan URL filtera, obaveza da se svaki oglas snimi na disk
- [3/rangiranje.md](3/rangiranje.md) — TOP 5 sa detaljnim obrazloženjem, pa ostatak liste
- [3/data/](3/data/) — jedan fajl po autu (62 fajla) + `data/raw/` sa sirovim JSON-om iz browsera

---

## 5. Kako da napraviš svoju pretragu

1. **Otvori terminal u folderu projekta** i pokreni `claude`.
2. **Napravi svoj folder**, npr. `4/`, i u njemu `instructions.md` sa svojim kriterijumima.
   Najlakše je da kopiraš [3/instructions.md](3/instructions.md) i izmeniš: budžet,
   kilometražu koju prelaziš godišnje, tip karoserije, region i redosled prioriteta.
3. **Nađi svoj filter na sajtu** — otvori polovniautomobili.com, ručno podesi pretragu
   (cena, godište, gorivo, karoserija, region) i **kopiraj URL iz adresne linije** u svoj
   `instructions.md`. Tako Claude traži tačno ono što ti hoćeš.
4. **Daj Claude-u zadatak:**

```
Pročitaj 4/instructions.md i uradi šta piše. Koristi chrome-devtools MCP server
(WebFetch je 403 na ovom sajtu). Za svaki oglas snimi podatke u 4/data/ kao
poseban .md fajl. Tek kad su svi oglasi povučeni, uradi rangiranje po mojim
kriterijumima i napravi 4/index.html u istom stilu kao 3/index.html.
```

5. **Otvori rezultat** — `4/index.html` u browseru. Ako hoćeš da se vidi i sa početne
   strane, reci: „dodaj karticu za pretragu #4 u index.html".

Saveti:

- Povlačenje 50–60 oglasa traje nekoliko minuta i Claude će usput tražiti dozvole za alate
  — potvrdi ih.
- Podaci se snimaju u `data/` **namerno**: sledeći put možeš da tražiš novo rangiranje bez
  ponovnog otvaranja sajta („rangiraj ponovo iz 4/data/, ali mi prostranost stavi na prvo mesto").
- Ako ne razumeš neki termin iz rangiranja (turbo, DPF, dvomaseni zamajac), pitaj Claude-a
  ili pogledaj [1/teorija/](1/teorija/).
- Cene i oglasi zastarevaju — datum povlačenja piše u svakom `data/` fajlu i na karticama
  na početnoj strani.

---

## 6. Ako nešto ne radi

| Problem | Rešenje |
|---|---|
| `/mcp` ne prikazuje `chrome-devtools` | Izađi iz sesije i pokreni `claude` ponovo iz korena projekta; potvrdi dozvolu za MCP iz `.mcp.json` |
| Chrome se ne otvara | Instaliraj Google Chrome; proveri da `npx -y chrome-devtools-mcp@latest` prolazi u terminalu |
| „403" ili prazna stranica | Claude je pokušao `WebFetch` — podseti ga da mora preko chrome-devtools MCP-a |
| Skripta vraća 0 oglasa | Sajt je promenio strukturu — koristi selektor-nezavisnu skriptu iz [1/instructions.md](1/instructions.md) |
| Claude „zaboravi" kriterijume | Reci mu da ponovo pročita tvoj `instructions.md`; za dug razgovor koristi `/clear` pa počni ispočetka |
