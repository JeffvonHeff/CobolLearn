## Forskel paa COBOL og Python (med enkle kodeeksempler)

### 1. Samling og rens af navn
**COBOL** (uddrag fra `Færdige opgaver/Opgave3.cob`)
```cobol
WORKING-STORAGE SECTION.
01 Fornavn      PIC X(20) VALUE SPACES.
01 Efternavn    PIC X(20) VALUE SPACES.
01 SamletNavn   PIC X(40) VALUE SPACES.
01 CleanName    PIC X(40) VALUE SPACES.
01 IX           PIC 9(7) VALUE 1.
01 IX2          PIC 9(7) VALUE 1.
01 CURRENT-CHAR PIC X(1) VALUE SPACE.
01 PREVIOUS-CHAR PIC X(1) VALUE SPACE.

PROCEDURE DIVISION.
    MOVE "Lars" TO Fornavn
    MOVE "Hansen" TO Efternavn
    STRING Fornavn DELIMITED BY SIZE " "
           DELIMITED BY SIZE Efternavn
           DELIMITED BY SIZE INTO SamletNavn

    PERFORM VARYING IX FROM 1 BY 1 UNTIL IX > LENGTH OF SamletNavn
        MOVE SamletNavn(IX:1) TO CURRENT-CHAR
        IF CURRENT-CHAR NOT = SPACE OR PREVIOUS-CHAR NOT = SPACE
            MOVE CURRENT-CHAR TO CleanName(IX2:1)
            MOVE CURRENT-CHAR TO PREVIOUS-CHAR
            ADD 1 TO IX2
        END-IF
    END-PERFORM

    DISPLAY "Navn (renset)      : " CleanName.
    STOP RUN.
```

**Python**
```python
def clean_name(fornavn, efternavn):
    samlet = f"{fornavn} {efternavn}"
    clean_chars = []
    prev_space = False
    for ch in samlet:
        if ch == " " and prev_space:
            continue
        clean_chars.append(ch)
        prev_space = ch == " "
    return "".join(clean_chars)

def main():
    fornavn = "Lars"
    efternavn = "Hansen"
    print("Navn (renset)      :", clean_name(fornavn, efternavn))

if __name__ == "__main__":
    main()
```

*Forskellen*: COBOL styrer faste felter og går tegn for tegn med indeks og `MOVE`; Python bruger dynamiske strenge og lister til at filtrere dobbelte mellemrum med et simpelt loop.

### 3. COBOL som “historiefortælling”
COBOL koder ofte som lange, beskrivende sætninger: divisioner, sektioner og verb (“MOVE”, “DISPLAY”, “ADD”) i rene ord, så programmet læses som en forretningshistorie. Man navngiver felter med domæneord (`KUNDE-ID`, `SALDO`) og beskriver handlingen næsten i prosa. Python er mere symboltungt (`:`, `{}`, `[]`, `lambda`, operatorer) og kompakt. Derfor føles COBOL som at skrive en detaljeret rapport, hvor hvert felt og hvert skridt skal nævnes eksplicit, mens Python minder om et notat med mange genveje og symboler.

### 2. Strukturerede data (kundeoplysninger)
**COBOL** (uddrag fra `Færdige opgaver/Opgave4.cob`)
```cobol
DATA DIVISION.
WORKING-STORAGE SECTION.
01 KUNDEOPL.
   02 KUNDE-ID    PIC X(10)   VALUE SPACES.
   02 FORNAVN     PIC X(20)   VALUE SPACES.
   02 EFTERNAVN   PIC X(20)   VALUE SPACES.
   02 KONTOINFO.
      03 KONTONUMMER PIC X(20)   VALUE SPACES.
      03 BALANCE     PIC 9(7)V9(2) VALUE ZEROS.
      03 VALUTAKODE  PIC X(3)    VALUE SPACES.

PROCEDURE DIVISION.
    MOVE "K123456789"   TO KUNDE-ID
    MOVE "Lars"         TO FORNAVN
    MOVE "Hansen"       TO EFTERNAVN
    MOVE "DKK1234567890" TO KONTONUMMER
    MOVE "15000.75"     TO BALANCE
    MOVE "DKK"          TO VALUTAKODE
    DISPLAY KUNDEOPL
    STOP RUN.
```

**Python** (samme struktur)
```python
def main():
    kunde = {
        "IDENTITET": {
            "kunde_id": "K123456789",
            "fornavn": "Lars",
            "efternavn": "Hansen",
        },
        "kontoinfo": {
            "kontonummer": "DKK1234567890",
            "balance": 15000.75,
            "valutakode": "DKK",
        },
    }
    print(kunde)

if __name__ == "__main__":
    main()
```

*Forskellen*: COBOL beskriver faste felter med længder og numeriske formater (`PIC`), og `DISPLAY KUNDEOPL` udskriver hele strukturen. Python bruger simple dicts og native typer (str/float) uden faste længder og udskriver eksplicit med `print`.
