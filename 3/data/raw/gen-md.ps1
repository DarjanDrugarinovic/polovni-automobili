# Generise data/<id>-<slug>.md iz data/raw/batch*.json
$root = "c:\Users\Home\Desktop\polovni-automobili"
$all = @()
Get-ChildItem "$root\data\raw\batch*.json" | ForEach-Object {
    $all += Get-Content $_.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
}
$today = "2026-06-11"
$made = 0
foreach ($e in $all) {
    if ($e.error) { continue }
    if ($e.title -notmatch 'godi') { continue }  # preskoci mrtve linkove
    $slug = ($e.url -split '/')[-1]
    $file = "$root\data\$($e.id)-$slug.md"

    $get = { param($obj, $key) $p = $obj.PSObject.Properties[$key]; if ($p) { $p.Value } else { "" } }
    $o = $e.opste; $d = $e.dodatne

    $naslov = ($e.title -replace '\s*\d{4}\. godište\s*$', '').Trim()
    $god = & $get $o 'Godište'
    $km = & $get $o 'Kilometraža'

    $fm = @()
    $fm += "---"
    $fm += "id: $($e.id)"
    $fm += "naslov: $naslov"
    $fm += "url: $($e.url)"
    $fm += "datum_povlacenja: $today"
    $fm += "cena: $($e.price)"
    $fm += "godiste: $god"
    $fm += "kilometraza: $km"
    $fm += "gorivo: $(& $get $o 'Gorivo')"
    $fm += "kubikaza: $(& $get $o 'Kubikaža')"
    $fm += "snaga: $(& $get $o 'Snaga motora')"
    $fm += "karoserija: $(& $get $o 'Karoserija')"
    $fm += "menjac: $(& $get $d 'Menjač')"
    $fm += "pogon: $(& $get $d 'Pogon')"
    $fm += "emisiona_klasa: $(& $get $d 'Emisiona klasa')"
    $fm += "klima: $(& $get $d 'Klima')"
    $fm += "boja: $(& $get $d 'Boja')"
    $fm += "registrovan_do: $(& $get $d 'Registrovan do')"
    $fm += "poreklo: $(& $get $d 'Poreklo vozila')"
    $fm += "ostecenje: $(& $get $d 'Oštećenje')"
    $fm += "zamena: $(& $get $o 'Zamena')"
    $fm += "fiksna_cena: $(& $get $o 'Fiksna cena')"
    $fm += "---"

    $body = @()
    $body += ""
    $body += "# $naslov — $($e.price)"
    $body += ""
    $body += "## Opšte informacije"
    foreach ($p in $e.opste.PSObject.Properties) { $body += "- **$($p.Name):** $($p.Value)" }
    $body += ""
    $body += "## Dodatne informacije"
    foreach ($p in $e.dodatne.PSObject.Properties) { $body += "- **$($p.Name):** $($p.Value)" }
    if ($e.stanje -and @($e.stanje.PSObject.Properties).Count -gt 0) {
        $body += ""
        $body += "## Stanje"
        foreach ($p in $e.stanje.PSObject.Properties) {
            if ($p.Value) { $body += "- **$($p.Name):** $($p.Value)" } else { $body += "- $($p.Name)" }
        }
    }
    if ($e.sigurnost) {
        $body += ""
        $body += "## Sigurnost"
        $body += "- " + ($e.sigurnost -join ", ")
    }
    if ($e.oprema) {
        $body += ""
        $body += "## Oprema"
        $body += "- " + ($e.oprema -join ", ")
    }
    if ($e.opis) {
        $body += ""
        $body += "## Opis"
        $body += $e.opis
    }
    if ($e.seller) {
        $body += ""
        $body += "## Prodavac"
        $body += $e.seller
    }
    $body += ""

    ($fm + $body) -join "`r`n" | Out-File -FilePath $file -Encoding utf8
    $made++
}
Write-Output "generisano: $made fajlova"
