Jeg har løst opgaven ved at bruge to loops med IF-styring i hovedprogrammet. Først læser jeg alle banker ind fra `Banker.txt` til et array og stopper ved EOF:
```cobol
PERFORM UNTIL END-BANK
    READ BANKFIL
        AT END SET END-BANK TO TRUE
        NOT AT END
            MOVE BANK-REKORD TO BANK-ARRAY(BANK-COUNT)
            ADD 1 TO BANK-COUNT
    END-READ
END-PERFORM
```
Andet loop går linje for linje i `Transaktioner.txt`. Med IF ser jeg, om CPR ændrer sig, så jeg kan udskrive forrige kundes totaler, og jeg matcher registreringsnummeret til banken, før jeg sender transaktionen videre:
```cobol
PERFORM UNTIL END-TRANSAKTION
    READ TRANSAKTIONFIL
        AT END SET END-TRANSAKTION TO TRUE
        NOT AT END
            MOVE CPR OF TRANSAKTIONER-REKORD TO CURRENTCPR
            IF CURRENTCPR NOT = PREVIOUSCPR
                IF PREVIOUSCPR NOT = "PREVIOUS"
                    PERFORM PRINT-TOTALS
                END-IF
                PERFORM MATCH-NAME-AND-BANK
            END-IF
            PERFORM ONLYTRANSAKTION
            MOVE CURRENTCPR TO PREVIOUSCPR
    END-READ
END-PERFORM
```

ValutaModul håndterer beløbet ved at trimme whitespace, erstatte punktum med komma og konvertere med `NUMVAL-C` og den rigtige kurs, før beløbet sendes tilbage i DKK:
```cobol
MOVE FUNCTION TRIM(P-BELOB-RAW) TO BELOB-TEXT-NORM
INSPECT BELOB-TEXT-NORM CONVERTING "." TO ","
COMPUTE P-BELOB-DKK = FUNCTION NUMVAL-C(BELOB-TEXT-NORM) * VALUTA-RATE
```

Jeg samler løbende alle tal i `Transaktion10Modul`, hvor hvert beløb enten lægges til de positive eller negative totaler, og saldoen opdateres samtidig:
```cobol
IF WS-BELOB-DKK > 0
    ADD WS-BELOB-DKK TO P-TOTAL-POS
ELSE
    ADD WS-BELOB-DKK TO P-TOTAL-NEG
END-IF
ADD WS-BELOB-DKK TO P-SALDO
```

Når CPR skifter, kalder jeg `PRINT-TOTALS`, der formatterer `TOTAL-POS`, `TOTAL-NEG` og `SALDO` til tekst. Jeg bruger `FUNCTION TRIM` og fjerner whitespace efter minus, hvis tallet er negativt, ved at trimme resten af tallet, så minus står helt til venstre. Derefter skriver jeg totalerne og en hilsen ud, samt nogle tomme linjer og en streg som separator, før jeg nulstiller til næste kunde:
```cobol
MOVE FUNCTION ABS(TOTAL-POS) TO TOTAL-POS-DISP
IF TOTAL-POS < 0
    MOVE "-" TO TOTAL-POS-OUT(1:1)
    MOVE FUNCTION TRIM(TOTAL-POS-DISP) TO TOTAL-POS-OUT(2:29)
ELSE
    MOVE FUNCTION TRIM(TOTAL-POS-DISP) TO TOTAL-POS-OUT
END-IF
...
STRING "Totalt indbetalt (DKK): " TOTAL-POS-OUT INTO OUTPUT-TEXT END-STRING
WRITE OUT-REKORD
STRING "Totalt udbetalt (DKK): " TOTAL-NEG-OUT INTO OUTPUT-TEXT END-STRING
WRITE OUT-REKORD
STRING "Saldo (DKK): " SALDO-OUT INTO OUTPUT-TEXT END-STRING
WRITE OUT-REKORD
STRING "Venlig hilsen " CURRENT-BANKNAVN INTO OUTPUT-TEXT END-STRING
WRITE OUT-REKORD
```
