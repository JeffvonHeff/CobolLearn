## Dokumentation for Opgave10.cob

### Formaal
- Udskrive kontoudtog per kunde baseret paa transaktionsfilen og bankoplysninger. Hver kunde faar en blok med staminfo, transaktionslinjer (DKK-konverteret) samt summeret indbetaling, udbetaling og slut-saldo.

### Input og output
- Inputfiler: `Banker.txt` (bankdata) og `Transaktioner.txt` (transaktioner), begge line sequential.
- Copybooks: `BANKS.cpy` og `TRANSACTIONS.cpy` definerer felter i hhv. bank- og transaktionsrecord.
- Outputfil: `Kontoudskrifter.txt`, tekstlinjer med kundeinfo, transaktioner og totals.
- Decimalpunkt er komma via `DECIMAL-POINT IS COMMA`.

### Centrale datadefinitioner
- `BANKER.BANK-ARRAY` (occurs 100, copybook via REPLACING 02→10) indeholder banker fra `Banker.txt` til opslag paa reg.nr.
- `TRANSAKTIONER-REKORD` fra `TRANSACTIONS.cpy` beskriver felter som CPR, NAVN, ADRESSE, REG-NR, KONTO-ID, BELOB, VALUTA, TRANSAKTIONSTYPE, BUTIK, TIDSPUNKT.
- `TRANSAKTIONER-RAW REDEFINES ... PIC X(211)` giver ra adgang til hele inputlinjen som tekst; bruges til substring-udtraek af beloebsfeltet uden at aendre copybooken.
- Arbejdsfelter: summer (`TOTAL-POS`, `TOTAL-NEG`), saldo (`SALDO`) og tilhoerende displayfelter, navne-trackere (`CURRENTNAVN`, `PREVIOUSNAVN`), flag for fundet transaktion (`TRANS-FUNDET`).
- Kunde-tracking: `CURRENTNAVN` og `PREVIOUSNAVN` styrer kundeskift, `IX-KONTI` bruges til at slaa op i bankarrayet.

### Overordnet kontrolflow
1. Saetter markeringsfelter og navne-guards (`PREVIOUSNAVN` = "Previous").
2. Laeser alle banker ind i `BANK-ARRAY` til opslag paa reg.nr., lukker bankfil.
3. Aabner transaktions- og outputfil.
4. Itererer transaktioner:
   - Ved nyt kundenavn: udskriver totals for forrige kunde (hvis ikke foerste) og kalder `MATCH-NAME-AND-BANK` for at skrive kunde- og bankstamdata samt nulstille summer/saldo.
   - Behandler transaktionen via `ONLYTRANSAKTION`, som kalder modulet `Transaktion10Modul` (valutaomregning via `ValutaModul`, opdaterer saldo/summer og formatterer transaktionslinje hvis bank-match).
   - Opdaterer `PREVIOUSNAVN` og skriver en blank linje.
5. Efter EOF: skriver totals for sidste kunde hvis nogen, lukker filer.

### Detaljeret behandling
- **Valutahaandtering**: Ligger i `ValutaModul`, der anvendes af `Transaktion10Modul` (kurser DKK=1, USD=6,7; EUR=7,5; andre = DKK).
- **Beloebsudtraek og konvertering**: `Transaktion10Modul` tager substring `TRANSAKTIONER-RAW(127:16)`, kalder `ValutaModul` og returnerer beloeb i DKK.
- **Summering**: I `Transaktion10Modul`; positive beloeb til `TOTAL-POS`, negative til `TOTAL-NEG`, begge med bevaret fortegn; `SALDO` opdateres pr. transaktion; startsaldo 50.000.
- **Udskrift af transaktion**: `Transaktion10Modul` formaterer beloeb (minus haandteres for pæn visning) og bygger linjen med dato, transaktionstype, beloeb (DKK) og butik; returneres til hovedprogrammet, som skriver linjen hvis bank-match (`TRANS-FUNDET` = "Y").
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
