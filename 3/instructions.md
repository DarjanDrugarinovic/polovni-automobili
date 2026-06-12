Pomozi mi da odaberem polovan auto za kupovinu. Odgovori na srpskom.

## Kontekst (važno — pridrži se ovoga pri oceni)

_Kriterijumi za ocenu i rangiranje, tim redom:_

- (1) pouzdanost — što manje toga da se kvari,
- (2) niski troškovi održavanja — jeftini i dostupni delovi, servis bez skupih popravki,
- (3) prostran/porodičan auto,
- (4) stanje (km/godište),
- (5) odnos cene i vrednosti.

> **Napomena za agenta (kako povući oglase):** Pre rangiranja obavezno preuzzmi **svaki** oglas sa sajta polovniautomobili.com koji odgovara zadatim filterima:

 https://www.polovniautomobili.com/auto-oglasi/pretraga?brand=&brand2=&price_from=&price_to=8000&year_from=2011&year_to=&chassis%5B%5D=277&chassis%5B%5D=278&chassis%5B%5D=2632&fuel%5B%5D=45&flywheel=&atest=&region%5B%5D=2563&door_num=&submit_1=&without_price=1&date_limit=&showOldNew=all&modeltxt=&engine_volume_from=&engine_volume_to=&power_from=&power_to=&mileage_from=&mileage_to=&emission_class=&seat_num=&wheel_side=&registration=&country=&country_origin=&city=&registration_price=&page=&sort=

 Na sajtu trenutno ima 60 aktivnih oglasa za ove filtere.

Povuci stvarne podatke (cena, godište, kilometraža, motor/snaga, gorivo, menjač, oprema, lokacija, opis/stanje). `WebFetch` je blokiran (HTTP 403) na polovniautomobili.com, zato koristi **chrome-devtools MCP server** i otvaraj linkove direktno kroz browser (`navigate_page` → `take_snapshot`/`evaluate_script` za izvlačenje sadržaja).
>
> **Snimanje na disk:** Za svaki povučen oglas sačuvaj podatke na disk u folder `data/` (jedan fajl po automobilu, npr. `data/<naziv-oglasa>.md` ili zajednički `data/oglasi.json`), kako bismo iste podatke mogli da koristimo i za kasnija poređenja bez ponovnog otvaranja sajta. Sačuvaj i URL oglasa, ID oglasa i datum povlačenja podataka.
>
> **Dodatne informacije:** Ako u oglasu ima korisnih informacija koje nisu deo zvaničnih kriterijuma (1)–(5) — npr. servisna istorija, broj vlasnika, registracija, uvoz, gepek/zapremina, dodatna oprema, mane navedene u opisu — svakako ih sačuvaj uz ostale podatke; mogu biti korisne kasnije.

> Tek kad su podaci za sve oglase prikupljeni i snimljeni, uradi rangiranje po kriterijumima (1)–(5).
