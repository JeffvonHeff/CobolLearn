## Moduloversigt

### ValutaModul
- Formål: Konverterer et beløb i tekst til numerisk DKK ud fra valutakode (kurser: DKK=1, USD=6,7; EUR=7,5).
- Interface: `USING P-VALUTA, P-BELOB-RAW (X(16)), P-BELOB-DKK (S9(13)V99)`. Decimalpunkt er komma, punktum konverteres før `NUMVAL-C`.
- Bruges af: `TransaktionModul` (Opgave11) og `Transaktion10Modul` (Opgave10).

### TransaktionModul (Opgave11)
- Formål: Behandler en transaktion: trækker beløb ud, kalder ValutaModul, finder/opretter kunde og opdaterer saldo.
- Interface: `USING TRANSAKTION-REKORD, TRANSAKTION-RAW, KUNDER (tabel), KUNDE-COUNT, MAX-KUNDER` (alle BY REFERENCE).
- Effekt: Opdaterer kundetabellen og kundeoptælling; ignorerer, hvis maks. kunder er nået.

### Top3Modul (Opgave11)
- Formål: Finder indeks til de tre højeste kundesaldi.
- Interface: `USING KUNDER (tabel), KUNDE-COUNT, TOP-IDX` (BY REFERENCE).
- Effekt: Sætter `TOP-POSITION(1-3)` i den modtagne struktur.

### Top3FormatModul (Opgave11)
- Formål: Formatterer en outputlinje for en topkunde med navn, CPR og saldo (DKK).
- Interface: `USING KUNDE-NAVN, KUNDE-CPR, KUNDE-SALDO, OUTPUT-TEXT` (BY REFERENCE).
- Effekt: Returnerer færdigbyggede tekstlinje klar til WRITE.

### Transaktion10Modul (Opgave10)
- Formål: Matcher transaktion til bank (REG-NR), konverterer beløb til DKK via ValutaModul, opdaterer totaler/saldo og formatterer transaktionslinje.
- Interface: `USING TRANSAKTION-REKORD, TRANSAKTION-RAW, BANKER (tabel), BANK-COUNT, TOTAL-POS, TOTAL-NEG, SALDO, OUTPUT-TEXT, FOUND` (BY REFERENCE).
- Effekt: Opdaterer summer/saldo; sætter `FOUND`="Y" og returnerer formateret linje, hvis bank-match; ellers ingen ændring/udskrift.
