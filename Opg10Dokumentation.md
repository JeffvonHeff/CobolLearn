## Dokumentation for Opgave10.cob

### Formaal
- Udskrive kontoudtog per kunde baseret paa transaktionsfilen og bankoplysninger. Hver kunde faar en blok med staminfo, transaktionslinjer (DKK-konverteret) samt summeret indbetaling, udbetaling og slut-saldo.

### Input og output
- Inputfiler: `Banker.txt` (bankdata) og `Transaktioner.txt` (transaktioner), begge line sequential.
- Copybooks: `BANKS.cpy` og `TRANSACTIONS.cpy` definerer felter i hhv. bank- og transaktionsrecord.
- Outputfil: `Kontoudskrifter.txt`, tekstlinjer med kundeinfo, transaktioner og totals.
- Decimalpunkt er komma via `DECIMAL-POINT IS COMMA`.

### Centrale datadefinitioner
- `BANK-ARRAY` (occurs 100) indeholder alle banker fra `Banker.txt` for opslag paa reg.nr.
- `TRANSAKTIONER-REKORD` fra `TRANSACTIONS.cpy` beskriver felter som CPR, NAVN, ADRESSE, REG-NR, KONTO-ID, BELOB, VALUTA, TRANSAKTIONSTYPE, BUTIK, TIDSPUNKT.
- `TRANSAKTIONER-RAW REDEFINES ... PIC X(211)` giver ra adgang til hele inputlinjen som tekst; bruges til substring-udtraek af beloebsfeltet uden at aendre copybooken.
- Arbejdsfelter: valuta-rate (`VALUTA-RATE`), beloeb som tekst (`BELOB-RAW`, `BELOB-TEXT-NORM`), beloeb i DKK (`BELOB-DKK` + displayfelter), summer (`TOTAL-POS`, `TOTAL-NEG`), saldo (`SALDO`) og tilhoerende displayfelter.
- Kunde-tracking: `CURRENTNAVN` og `PREVIOUSNAVN` styrer kundeskift, `IX-KONTI` bruges til at slaa op i bankarrayet.

### Overordnet kontrolflow
1. Saetter markeringsfelter og navne-guards (`PREVIOUSNAVN` = "Previous").
2. Laeser alle banker ind i `BANK-ARRAY` til opslag paa reg.nr., lukker bankfil.
3. Aabner transaktions- og outputfil.
4. Itererer transaktioner:
   - Ved nyt kundenavn: udskriver totals for forrige kunde (hvis ikke foerste) og kalder `MATCH-NAME-AND-BANK` for at skrive kunde- og bankstamdata samt nulstille summer/saldo.
   - Behandler transaktionen via `ONLYTRANSAKTION` (valutakurs, beloeb, saldo/summer, transaktionslinje).
   - Opdaterer `PREVIOUSNAVN` og skriver en blank linje.
5. Efter EOF: skriver totals for sidste kunde hvis nogen, lukker filer.

### Detaljeret behandling
- **Valutahaandtering**: Delegere til `ValutaModul`, som bruger kurser DKK=1, USD=6, EUR=7; andre valutaer behandles som DKK.
- **Beloebsudtraek og konvertering**: substring `TRANSAKTIONER-RAW(127:16)` -> `BELOB-RAW`; sendes til `ValutaModul`, der trim/normaliserer tekst og bruger `NUMVAL-C` samt kurs til at returnere DKK-beloeb.
- **Summering**: Positive beloeb laegges i `TOTAL-POS`, negative i `TOTAL-NEG`, begge saelv samme fortegn som beloebene. `SALDO` starter paa 50.000 og opdateres med hvert beloeb.
- **Udskrift af transaktion**: Formaterer beloeb (haandterer minus separat for pæn visning) og skriver linje med dato, transaktionstype, beloeb (DKK) og butik.
- **Udskrift ved kundeskift (`MATCH-NAME-AND-BANK`)**: Finder bank via REG-NR-match. Skriver kundeinfo (navn, adresse), registreringsnummer, banknavn, bankadresse, telefon, e-mail, kontonummer. Nulstiller summer og saldo til startvaerdi.
- **Totals (`PRINT-TOTALS`)**: Formaterer samlet indbetaling, udbetaling og saldo (inkl. minus-haandtering) og skriver afsluttende separatorlinjer og blanke linjer.

### Antagelser og begrasninger
- Transaktionsfilen er sorteret saa transaktioner for samme kunde (NAVN) staar samlet; kundeskift registreres kun paa navn, ikke CPR.
- Bankopslag sker kun paa REG-NR; hvis ingen match findes, udskrives ingen stamoplysninger for den transaktion.
- Maks 100 banker i array; yderligere banker ignoreres.
- Maksimal laengde 211 tegn for transaktionslinje antages tilstrakkelig for substring-af beloeb (start 127, laengde 16).
- Startsaldo fast 50.000 pr. kunde; ingen konto-specifik saldo init.

### Praktisk koeersel og kontrol
- Placer `Banker.txt` og `Transaktioner.txt` i samme mappe; koer programmet; resultat findes i `Kontoudskrifter.txt`.
- Verificer saerlige cases: USD/EUR konvertering, negative beloeb, kundeskift og manglende REG-NR-match. 
