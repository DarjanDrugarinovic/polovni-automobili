# MPI vs GDI — vrste ubrizgavanja benzina

Obe su načini **ubrizgavanja benzina**; razlika je **gde** se gorivo ubrizgava.

| | **MPI** (višetačkasto, *indirektno*) | **GDI** (direktno) |
|---|---|---|
| Skraćenica | Multi-Point Injection | Gasoline Direct Injection |
| Gde ubrizgava | u usisnu granu, ispred ventila | direktno u cilindar, pod visokim pritiskom |
| Složenost | jednostavno, niži pritisak | visokopritisna pumpa + dizne (skupo) |
| **Usisni ventili** | gorivo „pere" ventile → ostaju čisti | nema pranja → **kokс (naslage)** na ventilima |
| Održavanje | jeftino, bezbrižno | povremeno čišćenje kokса, skuplji delovi |
| Plin (TNG) | odlično podnosi | rizičnije |
| Snaga / potrošnja | malo slabije | malo bolje (efikasnije, jače) |

## Suština (za niske troškove + jednostavnost)

- **MPI = jednostavnije i jeftinije za održavanje** → naš prioritet. Zato prednost MPI.
- **GDI** nije loše (efikasnije i jače), ali dodaje **kokс na ventilima** i skuplje komponente
  → „atmo, ali sa zvezdicom".

## Šta GDI daje (benefit) u odnosu na MPI

GDI nije nastao bez razloga — direktno ubrizgavanje (gorivo pod visokim pritiskom pravo
u cilindar, preciznije dozirano) donosi konkretne prednosti:

| Benefit | Objašnjenje | Koliko |
|---|---|---|
| **Manja potrošnja** | preciznije doziranje + bolje hlađenje smeše → veći stepen kompresije | ~**5–10%** niža od MPI ekvivalenta |
| **Više snage/momenta** | iz iste zapremine vadi više | npr. 1.6 GDI **135 KS** vs 1.6 MPI ~**124 KS** |
| **Bolji odziv i hladan start** | precizno ubrizgavanje po taktovima | „življi" gas, čistije paljenje |
| **Niži CO₂** | posledica manje potrošnje | bitno proizvođaču (regulativa), kupcu simbolično |

**Suština benefita:** GDI je **efikasniji i jači**. Cena toga je kокс na usisnim ventilima
i skuplje komponente (vidi tabelu troškova ispod).

➡️ **Za malu/gradsku kilometražu** prednost GDI-ja (ušteda goriva) je **mala u apsolutnom
iznosu** — jer se i tako vozi malo — pa MPI ostaje malo logičniji. Ali pošto je doplata na
održavanju skromna (~30–60 €/god), **GDI je punopravna opcija, ne „sa zvezdicom"**.

## Kako prepoznati u oglasu

- **GDI oznake:** `GDI`, `FSI`, `VTi`, `Skyactiv-G`, `THP` (THP je i **turbo**).
- **„Čist" MPI atmo:** obično `MPI`, `16V`, `Dual VVT`, bez gornjih oznaka.
- ‼️ Oznaka nije dokaz — uvek potvrdi **kubikažom + menjačem** preko `paVerify` (vidi `CLAUDE.md`).

## Primeri sa liste kandidata (`car-results/car-results.md`)

- ✅ **MPI atmo** (preporuka): Hyundai ix35 **2.0**, Nissan Qashqai 1.6, Hyundai i30 1.4.
- ⚠️ **GDI atmo** (srednji tier): Hyundai ix35 **1.6 GDI**, Kia Sportage **1.6 GDI**.

## Koliko GDI realno košta više od MPI (procena za ovog kupca)

Razlika je **umerena — reda ~30–60 €/god**, NE kao turbo/dizel (stotine). GDI je i dalje
atmo (bez turbine/DPF-a, lanac), pa „skuplje" dolazi samo od direktnog ubrizgavanja:

| Stavka | MPI | GDI | Razlika |
|---|---|---|---|
| **Kокс na usisnim ventilima** | nema (gorivo pere ventil) | taloži se → čišćenje (walnut blasting) | **~100–250 €** svakih ~80–100k km |
| **Visokopritisna pumpa goriva** | nema je (samo pumpa u rezervoaru ~50–100 €) | ima je; otkaz ~**200–400 €** | retko, ali skuplje |
| **Brizgaljke (injektori)** | ~30–50 €/kom | ~**80–150 €/kom** | retko otkazuju |
| **Svećice / gorivo** | standardno | malo skuplje + osetljiviji na kvalitet goriva | zanemarljivo |

### ‼️ Glavna kvaka baš za malu/gradsku kilometražu
GDI najgore podnosi **kratke gradske relacije i „hladnu" vožnju** (motor ne dođe na temp.
da spali naslage) — a to je tačno profil ovog kupca (250 km grad, kratke relacije). Znači
da bi se kокс kod njega **taložio brže od proseka**. To je pravi razlog zašto su MPI motori
bolji za ovaj način vožnje — ne sama cena dela.

**Zaključak:** dodatni trošak GDI-ja ≈ **30–60 €/god** + povremeno čišćenje ventila
(~150–250 € po intervenciji, na 6.000 km/god dolazi na red tek svakih 5–6+ god). Daleko
jeftinije od turba/dizela. Ako se GDI ipak uzme — voziti ga povremeno i na duže/otvoreni
put i koristiti kvalitetno gorivo → kокс ostaje pod kontrolom, razlika prema MPI postaje
gotovo nebitna.

## Da li ušteda u gorivu (GDI) prebija doplatu održavanja?

Pošto GDI troši ~5–9% manje, postavlja se pitanje vraća li ta ušteda doplatu na održavanju.
**Pretpostavke:** 1.6 SUV, MPI ~8,5 L/100 vs GDI ~8,0 L/100 → razlika **~0,4–0,8 L/100km**;
benzin ~190 din/L ≈ **1,7 €/L**.

| Godišnje km | Ušteda goriva (GDI) | Doplata održavanja (GDI) | Neto |
|---|---|---|---|
| **6.000 (ovaj kupac)** | ~**40–80 €/god** | ~30–60 €/god | **≈ nula** (poništava se) |
| 15.000 | ~100–200 €/god | ~30–60 €/god | GDI u plusu ~70–140 € |
| 25.000 | ~170–340 €/god | ~30–60 €/god | GDI jasno u plusu |

**Zašto:** ušteda goriva **raste sa kilometražom**, a doplata održavanja je manje-više
**fiksna/po vremenu** (kокс se taloži po godinama/km, kod kratkih gradskih relacija čak brže).
Zato na **maloj km** ušteda jedva pokrije doplatu → **finansijski je svejedno**; na **velikoj
km** GDI pobeđuje.

➡️ **Praktična pouka:** na 6.000 km/god GDI vs MPI **ne biraj po gorivu** (neto je nula) —
biraj po konkretnom autu (cena, stanje, oprema) i po nefinansijskom: **MPI = manje brige**
(grad/kratke relacije), **GDI = više snage + širi izbor** (cela Hyundai/Kia 1.6 GDI generacija,
često jeftiniji primerak).
