# CLAUDE.md

Ovaj fajl daje budućim agent sesijama kontekst o projektu. Održavaj ga ažurnim kako projekat raste.

## KRITERIJUMI KUPCA (ažurirano 2026-06)

Tri cilja:
**(1) pouzdanost, (2) prostran/porodičan auto, (3) niski troškovi održavanja.**
Tip goriva i motora biraju se kao posledica tih ciljeva.

- **Budžet:** 4.000–8.000 € (vidi `price_from`/`price_to` u skripti).
- **Kilometraža kupca:** ~6.000 km/god (≈250 km grad + 250 km put mesečno), kratke relacije.
  → **DIZEL OTPADA**: DPF se na maloj/gradskoj kilometraži ne regeneriše (zapušavanje,
  EGR, dvomaseni — skupo). Dizel ima smisla tek na 20.000+ km/god autoputa.
  → **CILJ: atmo benzin (samo benzin, BEZ TNG)** — maksimalan prostor i jednostavnost.
    Prednost **MPI** nad GDI (GDI = direktno ubrizgavanje → kokс, više održavanja).
- **Karoserija = „veliki / porodičan", NE samo karavan.** Prihvatljivo:
  - **Karavan** (Astra ST, Octavia Combi, Passat Combi) — najveći prtljažnik, najjeftinije.
  - **Krosover / kompaktni SUV** (Qashqai…) — visoka, prostrana kabina, lak ulazak s decom.
  - **MPV / monovolumen** (Zafira, C4 Picasso, C-Max) — najpraktičniji (5–7 mesta, klizna vrata).
- **Niski troškovi = pravila pri izboru motora:** razvod **lancem**, **bez turbo**, bez DPF/dvomasenog,
  jeftini i dostupni delovi. (Ovo je razlog zašto KORAK 2 verifikacija postoji.)

⚙️ Skripta ispod podržava `opts.fuels` i `opts.chassis` (kodovi potvrđeni sa sajta 2026-06):
- **Gorivo:** 45=Benzin (jedino što tražimo) · _(ostalo: 2309=Dizel, 2308=Hibrid, 2312=Električni)_
- **Karoserija:** 278=Karavan · 2632=Džip/SUV · 2636=Monovolumen · 277=Limuzina · 2631=Hečbek · 2633=Kupe · 2634=Kabriolet · 2635=Pickup

Default za ovog kupca: `fuels:['45']` (samo benzin) i
`chassis:['278','2632','2636']` (karavan + SUV + monovolumen).

## Tooling

- **MCP serveri** (`.mcp.json`):
  - `chrome-devtools` — automatizacija/debug browsera preko `chrome-devtools-mcp`.
    Omogućen u `.claude/settings.local.json`. Koristi se za upravljanje browserom i
    pokretanje `fetch()` ka polovniautomobili.com iz `evaluate_script`.

---

## TEHNIČKI RECEPT (ažurirano 2026-06)

‼️ NE VEZUJ SE ZA CSS SELEKTORE — sajt ih menja (npr. stari
`.classified.ordinaryClassified` je nestao). Skripta dole je
SELEKTOR-NEZAVISNA: oglase pronalazi preko linkova /auto-oglasi/<id>/
i penje se do najbližeg pretka koji sadrži cenu (€), pa preživljava redizajn.
Ako i to jednom pukne, tek onda ručno pregledaj strukturu strane.

**KORAK 0 — same-origin:** PRVO `navigate_page` na bilo koji URL polovniautomobili.com,
tek onda `fetch()` iz `evaluate_script` (isti domen → nema CORS). NE koristi
`take_snapshot` na rezultatima (prevelik je). Za velike izlaze koristi `filePath`
argument `evaluate_script`-a (snimi JSON na disk).

**KORAK 1 — GOTOVA SKRIPTA** (nalepi celu u `evaluate_script`, menjaj samo poslednji red):

```js
async () => {
  /* ===== HELPERI — ne diraj (selektor-nezavisni) ===== */
  const BASE = "https://www.polovniautomobili.com";
  const NOW = new Date().getFullYear();
  async function paFetch(url) {
    const r = await fetch(url, {
      headers: { "X-Requested-With": "XMLHttpRequest" },
    });
    return new DOMParser().parseFromString(await r.text(), "text/html");
  }
  const paText = (el) =>
    (el ? el.innerText : "")
      .replace(/ /g, " ")
      .split("\n")
      .map((s) => s.trim())
      .filter(Boolean)
      .join(" | ");
  function paNoResults(doc) {
    return /nema rezultata|nije prona|nismo prona|0 rezultata/i.test(
      doc.body.innerText,
    );
  }
  // Parsiranje liste BEZ oslanjanja na klase: nađi anchore /auto-oglasi/<id>/,
  // popni se do kontejnera sa cenom, zadrži najtešnji po oglasu.
  function paParseList(doc) {
    const byId = new Map();
    doc.querySelectorAll('a[href*="/auto-oglasi/"]').forEach((a) => {
      const href = (a.getAttribute("href") || "").split("?")[0];
      const m = href.match(/\/auto-oglasi\/(\d+)\//);
      if (!m) return;
      const id = m[1];
      let node = a,
        box = null;
      for (let i = 0; i < 12 && node; i++) {
        node = node.parentElement;
        if (
          node &&
          /€/.test(node.innerText || "") &&
          /(\bkm\b|\b20[0-2]\d\b)/i.test(node.innerText || "")
        ) {
          box = node;
          break;
        }
      }
      const t = paText(box || a);
      if (byId.has(id) && byId.get(id)._len <= t.length) return;
      const years = (t.match(/\b20[0-2]\d\b/g) || [])
        .map(Number)
        .filter((y) => y >= 2005 && y <= NOW);
      byId.set(id, {
        id,
        slug: href.split("/").pop(),
        title: (a.getAttribute("title") || a.textContent || "")
          .replace(/\s+/g, " ")
          .trim()
          .slice(0, 70),
        price: (t.match(/([\d.]+)\s*€/) || [])[1] || null,
        year: years[0] || null,
        km: (t.match(/([\d.]+)\s*km/i) || [])[1] || null,
        link: BASE + href,
        _len: t.length,
      });
    });
    return [...byId.values()].map(({ _len, ...o }) => o);
  }
  // Jedna pretraga
  async function paSearch(url) {
    const d = await paFetch(url);
    return { noResults: paNoResults(d), ads: paParseList(d) };
  }
  // BATCH: queries = [[ime,"brand=...&model%5B0%5D=..."],...]
  // opts={ fuels:['45'], chassis:[], regions:['2563'], price_from, price_to, year_from, limit }
  //   fuels   — gorivo: 45=Benzin (default i jedino što tražimo); ostalo: 2309=Dizel, 2308=Hibrid
  //   chassis — karoserija (prazno = sve): 278=Karavan, 2632=Džip/SUV, 2636=Monovolumen,
  //             277=Limuzina, 2631=Hečbek, 2633=Kupe, 2634=Kabriolet, 2635=Pickup
  async function paBatch(queries, opts = {}) {
    const idx = (key, arr) =>
      (arr || []).map((v, i) => "&" + key + "%5B" + i + "%5D=" + v).join("");
    const base =
      BASE +
      "/auto-oglasi/pretraga?price_from=" +
      (opts.price_from || 4000) +
      "&price_to=" +
      (opts.price_to || 8000) +
      "&year_from=" +
      (opts.year_from || 2010) +
      "&sort=price%20asc" +
      idx("fuel", opts.fuels || ["45"]) +
      idx("chassis", opts.chassis) +
      idx("region", opts.regions || ["2563"]);
    const out = {};
    for (const [name, q] of queries) {
      try {
        const r = await paSearch(base + "&" + q);
        out[name] = {
          count: r.ads.length,
          noResults: r.noResults,
          ads: r.ads.slice(0, opts.limit || 6),
        };
      } catch (e) {
        out[name] = { error: String(e) };
      }
    }
    return out;
  }
  // VERIFIKACIJA oglasa (atmo/turbo, ubrizgavanje, menjač) — čita Srpske labele, bez selektora
  async function paVerify(idOrUrl) {
    const url = /^https?:/.test(idOrUrl)
      ? idOrUrl
      : BASE + "/auto-oglasi/" + idOrUrl;
    const doc = await paFetch(url);
    const txt = doc.body.innerText.replace(/\s+/g, " ");
    const g = (re) => {
      const m = txt.match(re);
      return m ? m[1].trim() : null;
    };
    const cc = g(/Kubikaža\s*([\d.]+)\s*cm/i);
    // specifična snaga (KS/l) — atmo ≈ 50–84, turbo ≈ 85+. PRAG < 85 (ne < 78!):
    // moderan atmo 2.0 (Theta II 2.0 MPI, Ecotec 1.8) ide do ~80–83 KS/l i NE sme da ispadne.
    const ks = (txt.match(/\((\d{2,3})\s*KS\)/i) || txt.match(/(\d{2,3})\s*KS/i) || [])[1];
    const ccNum = cc ? parseFloat(cc.replace(/\./g, "")) : null;
    const spec = ks && ccNum ? +(parseInt(ks) / (ccNum / 1000)).toFixed(0) : null;
    return {
      title: doc.title.split("|")[0].trim().slice(0, 70),
      cena: (txt.match(/([\d.]+)\s*€/) || [])[1] || null,
      godiste: g(/Godište\s*(\d{4})/i),
      km: g(/Kilometraža\s*([\d.]+\s*km)/i),
      kubikaza: cc,
      snaga: g(
        /Snaga motora\s*([^|]{3,22}?)(?:Fiksna|Emis|Pogon|Menjač|Klima|$)/i,
      ),
      gorivo: g(/Gorivo\s*([A-Za-zšđčćž ]{3,15}?)(?:Kubik|Snaga|$)/i),
      menjac: g(
        /Menjač\s*([^|]*?(?:Manuelni|Automatski|Poluautom)[^|]{0,14})/i,
      ),
      karoserija: g(
        /Karoserija\s*([A-Za-zšđčćž ]{3,18}?)(?:Boja|Broj|Pogon|$)/i,
      ),
      vlasnik:
        g(/Broj vlasnika\s*(\d+)/i) || (/Prvi vlasnik/i.test(txt) ? "1" : null),
      specificna_snaga: spec, // KS/l — < 85 = verovatno atmo, 85+ = verovatno turbo
      atmo_po_specifici: spec != null ? spec < 85 : null,
      // hintovi (orijentir, ne dokaz): potvrdi kubikažom + znanjem o motoru
      turbo_hint:
        /\b(tsi|tfsi|tce|t-?gdi|ecoboost|turbo|tdi|hdi|dci|crdi|cdti|d-?4d)\b/i.test(
          txt,
        ),
      direktno_hint: /\b(tsi|tfsi|fsi|gdi|t-?gdi|skyactiv)\b/i.test(txt),
    };
  }

  /* ===== ŠTA POKREĆEŠ — menjaj SAMO ovo ===== */
  return await paBatch(
    [
      ["Opel Astra", "brand=opel&model%5B0%5D=astra"],
      ["Hyundai i30", "brand=hyundai&model%5B0%5D=i30"],
      ["Nissan Qashqai", "brand=nissan&model%5B0%5D=qashqai"],
    ],
    {
      fuels: ["45"], // samo benzin (bez TNG, bez dizela) — prostor + jednostavnost
      chassis: ["278", "2632", "2636"], // porodično: karavan + Džip/SUV + monovolumen
      regions: ["2563"], // sva 4 okruga: ['2563','2564','2565','2566']
      limit: 6,
    },
  );
  // Verifikacija konkretnog oglasa:
  // return await paVerify('29228134/opel-astra-j-14-enjoy');
};
```

**KORAK 2 — OBAVEZNA verifikacija motora (najvažnija lekcija!):**
Slug/naslov NE razlikuju atmo od turbo. Pusti `paVerify(id)` i gledaj KUBIKAŽU + MENJAČ.
Provereni primeri zašto je nužno:

- **Opel Astra J 1.4:** 1398 cm³ + 5 brz = NA (A14XER, 100 KS, OK);
  1364 cm³ + 6 brz = 1.4 TURBO (A14NET, 140 KS, IZBEGNI).
  → "essentia" 5.499€ je po slugu delovao ok, a bio je turbo (1364cc)!
- **Škoda Octavia** "jeftina" ≈ uvek 1197 cm³ = 1.2 TSI (turbo); 1.6 MPI (1595) nema u budžetu.
- **Renault:** 1198 cm³ = 1.2 TCe (turbo); samo 1.4/1.6 16v su atmo.

  **Pravilo:** turbo često = manja kubikaža + 6/7 brz ili DSG; atmo MPI ≈ "okrugla"
  kubikaža (1398/1591/1598) + 5/6 manuelni. `turbo_hint`/`direktno_hint` su samo orijentir.

**Specifična snaga (KS/l) — brzo odsejavanje, ali PAZI na prag:**
`paVerify` vraća `specificna_snaga` (KS/l) i `atmo_po_specifici`. Heuristika:
- **< 85 KS/l → verovatno ATMO**, **85+ → verovatno turbo.**
- ‼️ **PRAG JE < 85, NE < 78.** Raniji prag od 78 je GREŠKOM izbacivao legitimne
  atmo motore veće kubikaže. Provereni promašaji koje prag 78 odseca, a 85 ispravno zadržava:
  - **Hyundai ix35 2.0 DOHC** (Theta II **G4KD**, MPI, lanac): 1998 cm³ / 165 KS = **83 KS/l** → ATMO ✅
  - **Chevrolet Orlando 1.8** (Ecotec **F18D4**, MPI, lanac, 7 sedišta): 1796 cm³ / 141 KS = **79 KS/l** → ATMO ✅
- KS/l je SAMO brzi orijentir — uvek potvrdi **kubikažom + ubrizgavanjem (MPI vs GDI) + lancem**.
  Pravi GDI (npr. ix35/Sportage/Ceed **1.6 GDI**, 135 KS) ostaje izbačen jer je direktno ubrizgavanje,
  bez obzira na KS/l.
