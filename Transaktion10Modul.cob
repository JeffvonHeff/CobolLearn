       IDENTIFICATION DIVISION.
       PROGRAM-ID. Transaktion10Modul.
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-BELOB-RAW PIC X(16) VALUE SPACES.
       01 WS-BELOB-DKK PIC S9(13)V99 VALUE 0.
       01 WS-BELOB-DKK-DISP PIC -ZZZ.ZZZ.ZZZ.ZZZ.ZZ9,99 VALUE ZEROS.
       01 WS-BELOB-DKK-OUT PIC X(30) VALUE SPACES.
       01 WS-IX PIC 9(3) VALUE 0.
       
       LINKAGE SECTION.
       01 P-TRANSAKTION-REKORD.
          COPY "TRANSACTIONS.cpy".
       01 P-TRANSAKTION-RAW PIC X(211).
       
       01 P-BANKER.
          05 P-BANK-ARRAY OCCURS 100 TIMES.
             COPY "BANKS.cpy"
                 REPLACING == 02 == BY == 10 ==.
       
       01 P-BANK-COUNT PIC 9(3).
       01 P-TOTAL-POS PIC S9(15)V99.
       01 P-TOTAL-NEG PIC S9(15)V99.
       01 P-SALDO PIC S9(15)V99.
       01 P-OUTPUT-TEXT PIC X(150).
       01 P-FOUND PIC X.
       
       PROCEDURE DIVISION USING BY REFERENCE P-TRANSAKTION-REKORD
                                 P-TRANSAKTION-RAW
                                 P-BANKER
                                 P-BANK-COUNT
                                 P-TOTAL-POS
                                 P-TOTAL-NEG
                                 P-SALDO
                                 P-OUTPUT-TEXT
                                 P-FOUND.
           MOVE "N" TO P-FOUND
           PERFORM VARYING WS-IX FROM 1 BY 1 UNTIL WS-IX >= P-BANK-COUNT
               IF REG-NR OF P-BANK-ARRAY(WS-IX) = REG-NR OF 
               P-TRANSAKTION-REKORD
                   MOVE P-TRANSAKTION-RAW(127:16) TO WS-BELOB-RAW
                   CALL "ValutaModul"
                       USING BY REFERENCE VALUTA OF P-TRANSAKTION-REKORD
                             BY REFERENCE WS-BELOB-RAW
                             BY REFERENCE WS-BELOB-DKK
                   IF WS-BELOB-DKK > 0
                       ADD WS-BELOB-DKK TO P-TOTAL-POS
                   ELSE
                       ADD WS-BELOB-DKK TO P-TOTAL-NEG
                   END-IF
                   ADD WS-BELOB-DKK TO P-SALDO
       
                   MOVE WS-BELOB-DKK TO WS-BELOB-DKK-DISP
                   MOVE FUNCTION TRIM(WS-BELOB-DKK-DISP) TO 
                   WS-BELOB-DKK-OUT
                   PERFORM UNTIL WS-BELOB-DKK-OUT(1:2) NOT = "- "
                       MOVE WS-BELOB-DKK-OUT(3:28) TO 
                       WS-BELOB-DKK-OUT(2:28)
                       MOVE "-" TO WS-BELOB-DKK-OUT(1:1)
                   END-PERFORM
       
                   MOVE SPACES TO P-OUTPUT-TEXT
                   STRING "Dato: "
                          FUNCTION TRIM(TIDSPUNKT OF 
                          P-TRANSAKTION-REKORD)
                          " Transaktionstype: "
                          FUNCTION TRIM(TRANSAKTIONSTYPE OF
                          P-TRANSAKTION-REKORD)
                          " Belob (DKK): "
                          FUNCTION TRIM(WS-BELOB-DKK-OUT)
                          " Butik: "
                          FUNCTION TRIM(BUTIK OF P-TRANSAKTION-REKORD)
                       DELIMITED BY SIZE
                       INTO P-OUTPUT-TEXT
                   END-STRING
                   MOVE "Y" TO P-FOUND
                   EXIT PERFORM
               END-IF
           END-PERFORM
           GOBACK.
       