       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. Opgave10.
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT BANKFIL ASSIGN TO "Banker.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANSAKTIONFIL ASSIGN TO "Transaktioner.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT OUT-FIL ASSIGN TO "Kontoudskrifter.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
       
       DATA DIVISION.
       FILE SECTION.
       FD BANKFIL.
       01 BANK-REKORD.
          COPY "BANKS.cpy".
       
       FD TRANSAKTIONFIL.
       01 TRANSAKTIONER-REKORD.
          COPY "TRANSACTIONS.cpy".
       01 TRANSAKTIONER-RAW REDEFINES TRANSAKTIONER-REKORD PIC X(211).
       
       FD OUT-FIL.
       01 OUT-REKORD.
          02 OUTPUT-TEXT PIC X(150).
       
       WORKING-STORAGE SECTION.
       01 BANK-COUNT PIC 9(3) VALUE 0.
       01 EOF-TRANSAKTION PIC X VALUE "N".
          88 END-TRANSAKTION VALUE "Y".
       01 EOF-BANK PIC X VALUE "N".
          88 END-BANK VALUE "Y".
       01 IX-KONTI PIC 9(3) VALUE 1.
       
       01 PREVIOUSCPR PIC X(15) VALUE "PREVIOUS".
       01 CURRENTCPR PIC X(15) VALUE SPACES.
       01 CURRENT-BANKNAVN PIC X(30) VALUE SPACES.
       01 T-FOUND PIC X VALUE "N".
       01 TOTAL-POS PIC S9(15)V99 VALUE 0.
       01 TOTAL-NEG PIC S9(15)V99 VALUE 0.
       01 TOTAL-POS-DISP PIC -ZZZ.ZZZ.ZZZ.ZZZ.ZZZ.ZZ9,99 VALUE ZEROS.
       01 TOTAL-NEG-DISP PIC -ZZZ.ZZZ.ZZZ.ZZZ.ZZZ.ZZ9,99 VALUE ZEROS.
       01 SALDO-START PIC S9(13)V99 VALUE 50000.
       01 SALDO PIC S9(15)V99 VALUE 0.
       01 SALDO-DISP PIC -ZZZ.ZZZ.ZZZ.ZZZ.ZZZ.ZZ9,99 VALUE ZEROS.
       01 TOTAL-POS-OUT PIC X(30) VALUE SPACES.
       01 TOTAL-NEG-OUT PIC X(30) VALUE SPACES.
       01 SALDO-OUT PIC X(30) VALUE SPACES.
       
       *> Array til Bank
       01 BANKER.
          05 BANK-ARRAY OCCURS 100 TIMES.
             COPY "BANKS.cpy"
                 REPLACING == 02 == BY == 10 ==.
       
       PROCEDURE DIVISION.
       MAIN-PROGRAM.
           MOVE "CURRENT" TO CURRENTCPR
           MOVE "PREVIOUS" TO PREVIOUSCPR
       
           OPEN INPUT BANKFIL
           MOVE 1 TO BANK-COUNT
           MOVE "N" TO EOF-BANK
           PERFORM UNTIL END-BANK
               READ BANKFIL
                   AT END
                       SET END-BANK TO TRUE
                   NOT AT END
                       MOVE BANK-REKORD TO BANK-ARRAY(BANK-COUNT)
                       ADD 1 TO BANK-COUNT
               END-READ
           END-PERFORM
           CLOSE BANKFIL
       
           OPEN INPUT TRANSAKTIONFIL
           OPEN OUTPUT OUT-FIL
           PERFORM UNTIL END-TRANSAKTION
               READ TRANSAKTIONFIL
                   AT END
                       SET END-TRANSAKTION TO TRUE
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
           IF PREVIOUSCPR NOT = "PREVIOUS"
               PERFORM PRINT-TOTALS
           END-IF
           CLOSE TRANSAKTIONFIL
           CLOSE OUT-FIL
           STOP RUN.
       
       MATCH-NAME-AND-BANK.
           MOVE SPACES TO CURRENT-BANKNAVN
           PERFORM VARYING IX-KONTI FROM 1 BY 1 UNTIL IX-KONTI 
           >= BANK-COUNT
               IF REG-NR OF BANK-ARRAY(IX-KONTI) = REG-NR OF 
               TRANSAKTIONER-REKORD
                   MOVE BANKNAVN OF BANK-ARRAY(IX-KONTI) TO 
                   CURRENT-BANKNAVN
                   MOVE SPACES TO OUTPUT-TEXT
                   STRING "Kunde: " NAVN OF TRANSAKTIONER-REKORD
                       INTO OUTPUT-TEXT
                   END-STRING
                   WRITE OUT-REKORD
                   MOVE SPACES TO OUTPUT-TEXT
                   STRING "Adresse: " ADRESSE OF TRANSAKTIONER-REKORD
                       INTO OUTPUT-TEXT
                   END-STRING
                   WRITE OUT-REKORD
                   STRING "Registreringsnummer: " REG-NR OF 
                   BANK-ARRAY(IX-KONTI)
                       DELIMITED BY SIZE
                       INTO OUTPUT-TEXT
                   END-STRING
                   WRITE OUT-REKORD
                   MOVE SPACES TO OUTPUT-TEXT
                   STRING "Bank: " BANKNAVN OF BANK-ARRAY(IX-KONTI)
                       DELIMITED BY SIZE
                       INTO OUTPUT-TEXT
                   END-STRING
                   WRITE OUT-REKORD
                   MOVE SPACES TO OUTPUT-TEXT
                   STRING "Bankadresse: " BANKADRESSE OF 
                   BANK-ARRAY(IX-KONTI)
                       DELIMITED BY SIZE
                       INTO OUTPUT-TEXT
                   END-STRING
                   WRITE OUT-REKORD
                   MOVE SPACES TO OUTPUT-TEXT
                   STRING "Telefon: " TELEFON OF BANK-ARRAY(IX-KONTI)
                       DELIMITED BY SIZE
                       INTO OUTPUT-TEXT
                   END-STRING
                   WRITE OUT-REKORD
                   MOVE SPACES TO OUTPUT-TEXT
                   STRING "E-mail: " EMAIL OF BANK-ARRAY(IX-KONTI)
                       DELIMITED BY SIZE
                       INTO OUTPUT-TEXT
                   END-STRING
                   WRITE OUT-REKORD
                   MOVE SPACES TO OUTPUT-TEXT
                   STRING "Kontoudskrift for kontonr.: " KONTO-ID OF 
                   TRANSAKTIONER-REKORD
                       DELIMITED BY SIZE
                       INTO OUTPUT-TEXT
                   END-STRING
                   WRITE OUT-REKORD
                   MOVE SPACES TO OUTPUT-TEXT
                   MOVE 0 TO TOTAL-POS TOTAL-NEG
                   MOVE SALDO-START TO SALDO
               END-IF
           END-PERFORM
           EXIT.
       
       ONLYTRANSAKTION.
           CALL "Transaktion10Modul"
               USING BY REFERENCE TRANSAKTIONER-REKORD
                     BY REFERENCE TRANSAKTIONER-RAW
                     BY REFERENCE BANKER
                     BY REFERENCE BANK-COUNT
                     BY REFERENCE TOTAL-POS
                     BY REFERENCE TOTAL-NEG
                     BY REFERENCE SALDO
                     BY REFERENCE OUTPUT-TEXT
                     BY REFERENCE T-FOUND
           IF T-FOUND = "Y"
               WRITE OUT-REKORD
           END-IF
           EXIT.
       
       PRINT-TOTALS.
           MOVE SPACES TO TOTAL-POS-OUT
           MOVE FUNCTION ABS(TOTAL-POS) TO TOTAL-POS-DISP
           IF TOTAL-POS < 0
               MOVE "-" TO TOTAL-POS-OUT(1:1)
               MOVE FUNCTION TRIM(TOTAL-POS-DISP) TO TOTAL-POS-OUT(2:29)
           ELSE
               MOVE FUNCTION TRIM(TOTAL-POS-DISP) TO TOTAL-POS-OUT
           END-IF
           MOVE SPACES TO TOTAL-NEG-OUT
           MOVE FUNCTION ABS(TOTAL-NEG) TO TOTAL-NEG-DISP
           IF TOTAL-NEG < 0
               MOVE "-" TO TOTAL-NEG-OUT(1:1)
               MOVE FUNCTION TRIM(TOTAL-NEG-DISP) TO TOTAL-NEG-OUT(2:29)
           ELSE
               MOVE FUNCTION TRIM(TOTAL-NEG-DISP) TO TOTAL-NEG-OUT
           END-IF
           MOVE SPACES TO SALDO-OUT
           MOVE FUNCTION ABS(SALDO) TO SALDO-DISP
           IF SALDO < 0
               MOVE "-" TO SALDO-OUT(1:1)
               MOVE FUNCTION TRIM(SALDO-DISP) TO SALDO-OUT(2:29)
           ELSE
               MOVE FUNCTION TRIM(SALDO-DISP) TO SALDO-OUT
           END-IF
           MOVE SPACES TO OUTPUT-TEXT
           STRING "Totalt indbetalt (DKK): " TOTAL-POS-OUT
               INTO OUTPUT-TEXT
           END-STRING
           WRITE OUT-REKORD
           MOVE SPACES TO OUTPUT-TEXT
           STRING "Totalt udbetalt (DKK): " TOTAL-NEG-OUT
               INTO OUTPUT-TEXT
           END-STRING
           WRITE OUT-REKORD
           MOVE SPACES TO OUTPUT-TEXT
           STRING "Saldo (DKK): " SALDO-OUT
               INTO OUTPUT-TEXT
           END-STRING
           WRITE OUT-REKORD
           MOVE SPACES TO OUTPUT-TEXT
           STRING "Venlig hilsen " CURRENT-BANKNAVN
               INTO OUTPUT-TEXT
           END-STRING
           WRITE OUT-REKORD
           MOVE SPACES TO OUTPUT-TEXT
           WRITE OUT-REKORD
           WRITE OUT-REKORD
           MOVE SPACES TO OUTPUT-TEXT
           STRING "-----------------------------------------------"
               INTO OUTPUT-TEXT
           END-STRING
           WRITE OUT-REKORD
           MOVE SPACES TO OUTPUT-TEXT
           WRITE OUT-REKORD
           WRITE OUT-REKORD
           EXIT.
