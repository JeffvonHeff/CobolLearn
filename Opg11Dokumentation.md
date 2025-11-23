## Dokumentation for Opgave11.cob

### Formaal
- Programmet laeser en transaktionsfil og udregner en DKK-saldo pr. kunde (CPR).
- De tre kunder med hoejeste saldo gemmes i tekstfilen `RichKunder.txt`.

### Input og output
- Inputfil: `Transaktioner.txt` (line sequential). Struktur defineret i `TRANSACTIONS.cpy`.
- Outputfil: `RichKunder.txt` med en linje pr. kunde i top-3.
- Decimalpunkt er sat til komma via `DECIMAL-POINT IS COMMA`.

### Datadefinitioner (uddrag)
- `TRANSAKTIONER-REKORD` bruger copybooken `TRANSACTIONS.cpy` (CPR, NAVN, ADRESSE, FODSELSDATO, KONTO-ID, REG-NR, BELOB, VALUTA, TRANSAKTIONSTYPE, BUTIK, TIDSPUNKT).
- `TRANSAKTIONER-RAW` redefinerer hele recorden som tekst for at udlaese beloebsfeltet som substring (position 127:16).
- `KUNDE-TABEL` (maks 10.000) holder CPR, navn og beregnet saldo i DKK.
- `TOP-POSITION(1-3)` gemmer indeks til de tre stoerste saldi.

#### Note om `TRANSAKTIONER-RAW REDEFINES TRANSAKTIONER-REKORD`
- `REDEFINES` laader samme hukommelse deles mellem en struktureret record (`TRANSAKTIONER-REKORD`) og en ren tekststreng (`TRANSAKTIONER-RAW` med laengde 211). Det giver direkte adgang til hele inputlinjen som tekst, saa et bestemt felt (beloeb) kan laeses via substring uden at aendre copybooken.

#### Note om `MOVE TRANSAKTIONER-RAW(127:16) TO BELOB-RAW`
- Udtraekker beloebsfeltet som tekst via substring: start position 127, laengde 16. Dette matcher feltplaceringen i inputlinjen (i copybookens layout). Tekstfeltet flyttes til `BELOB-RAW` for efterfoelgende trim/konvertering til numerisk beloeb.

### Overordnet kontrolflow
1. Aabner input- og outputfiler.
2. Laeser hver transaktion indtil EOF og kalder `BEHANDL-TRANSAKTION`.
3. Efter alle laesninger: finder top-3 kunder (`FIND-TOP-3`) og skriver dem til output (`SKRIV-TOP-3`).
4. Lukker filer og stopper.

### Behandling af transaktion
- Udtraekker beloebsfeltet som tekst (substring) og sender det sammen med valuta til `ValutaModul`, der returnerer beloeb i DKK.
- Finder eksisterende kunde i `KUNDE-TABEL`; hvis ingen, opretter ny post (op til 10.000).
- Laegger transaktionsbeloeb til kundens saldo (positiv eller negativ).

### Note om `NUMVAL-C`
- `NUMVAL-C` er en COBOL-funktion, der konverterer tekst til et numerisk tal under hensyntagen til lokal decimal- og tusindtals-separator (her bruges komma som decimal separator). Den ignorerer ledende/trailende blanks og tillader fortegn; anvendt for at oversaette beloebsfeltet til numerisk vaerdi, inden valutafaktor anvendes.

### ValutaModul (ekstern funktion)
- Rolle: Omregner et beloeb fra valuta til DKK baseret paa valuta-kode og beloebstekst.
- Kald i `BEHANDL-TRANSAKTION`:  
  1) `MOVE TRANSAKTIONER-RAW(127:16) TO BELOB-RAW` (udtraek beloeb som tekst).  
  2) `CALL "ValutaModul" USING BY CONTENT VALUTA OF TRANSAKTIONER-REKORD, BY CONTENT BELOB-RAW, BY REFERENCE BELOB-DKK`.
- Interface: `BY CONTENT` valuta (PIC X(4)), `BY CONTENT` beloeb-raw (PIC X(16)), `BY REFERENCE` output beloeb i DKK (S9(13)V99).
- Intern logik: saetter kurs DKK=1, USD=6, EUR=7; trim/normaliserer beloebstekst, konverterer punktum→komma og bruger `NUMVAL-C` til tal; multiplicerer med kurs og returnerer resultat i det reference-ud-felt.

### Finder top-3 kunder
- Nulstiller `TOP-POSITION`.
- Tre iterationer: scannet hele `KUNDE-TABEL` og vaelger stoerste saldo, der ikke allerede er valgt tidligere.
- Resultat: indeks til de tre hoejeste saldi (hvis faerre kunder, efterlades overskydende med 0).

### Skriver top-3 output
- For hvert valgt indeks:
  - Formaterer saldo i `SALDO-OUT` med tusindseparatorer; haandterer minus separat for ren formatering.
  - Bygger streng: `Kunde: <navn> (CPR: <cpr>) Saldo (DKK): <saldo>`.
  - Skriver linjen til `RichKunder.txt`.

### Antagelser og begrasninger
- Transaktionsfilen bruger faste positioner som i `TRANSACTIONS.cpy`; beloeb antages at ligge fra position 127 med laengde 16.
- Kun USD og EUR konverteres; oevrige valutaer behandles som DKK.
- Maks 10.000 kunder; overskydende ignoreres.
- Ingen sortering af output udover top-3; resten af kunderne skrives ikke.

### Praktisk koeersel
- Koer programmet med adgang til `Transaktioner.txt` i samme mappe; resultat skrives til `RichKunder.txt`.
