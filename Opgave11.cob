       IDENTIFICATION DIVISION.
       PROGRAM-ID. Opgave11.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT TRANSAKTIONFIL ASSIGN TO "Transaktioner.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT OUT-FIL ASSIGN TO "RichKunder.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  TRANSAKTIONFIL.
       01 TRANSAKTIONER-REKORD.
       COPY "TRANSACTIONS.cpy".
       01 TRANSAKTIONER-RAW REDEFINES TRANSAKTIONER-REKORD
         PIC X(211).

       FD OUT-FIL.
       01 OUT-REKORD.
         02 OUTPUT-TEXT PIC X(150).

       WORKING-STORAGE SECTION.
       01 EOF-TRANSAKTION PIC X VALUE "N".
       88 END-TRANSAKTION VALUE "Y".
       01 VALUTA-RATE PIC 9(1) VALUE 1.
       01 BELOB-RAW PIC X(16) VALUE SPACES.
       01 BELOB-TEXT-NORM PIC X(16) VALUE SPACES.
       01 BELOB-DKK PIC S9(13)V99 VALUE 0.
       01 BELOB-DKK-DISP PIC -ZZZ.ZZZ.ZZZ.ZZZ.ZZ9,99 VALUE ZEROS.
       01 BELOB-DKK-OUT PIC X(30) VALUE SPACES.

       01 MAX-KUNDER PIC 9(5) VALUE 10000.
       01 KUNDE-COUNT PIC 9(5) VALUE 0.
       01 IX PIC 9(5) VALUE 0.
       01 RANK-IDX PIC 9(5) VALUE 0.
       01 MAX-IDX PIC 9(5) VALUE 0.

       01 KUNDE-TABEL OCCURS 10000 TIMES.
          05 KUNDE-CPR PIC X(15) VALUE SPACES.
          05 KUNDE-NAVN PIC X(30) VALUE SPACES.
          05 KUNDE-SALDO PIC S9(15)V99 VALUE 0.

       01 TOP-IDX.
          05 TOP-POSITION PIC 9(5) OCCURS 3 TIMES VALUE 0.

       01 SALDO-DISP PIC -ZZZ.ZZZ.ZZZ.ZZZ.ZZZ.ZZ9,99 VALUE ZEROS.
       01 SALDO-OUT PIC X(30) VALUE SPACES.

       PROCEDURE DIVISION.
       MAIN.
           OPEN INPUT TRANSAKTIONFIL
           OPEN OUTPUT OUT-FIL
           MOVE "N" TO EOF-TRANSAKTION

           PERFORM UNTIL END-TRANSAKTION
               READ TRANSAKTIONFIL
                   AT END
                       SET END-TRANSAKTION TO TRUE
                   NOT AT END
                       PERFORM BEHANDL-TRANSAKTION
               END-READ
           END-PERFORM

           PERFORM FIND-TOP-3
           PERFORM SKRIV-TOP-3

           CLOSE TRANSAKTIONFIL
           CLOSE OUT-FIL
       STOP RUN.

       BEHANDL-TRANSAKTION.
           MOVE TRANSAKTIONER-RAW(127:16) TO BELOB-RAW
           CALL "ValutaModul"
               USING BY CONTENT VALUTA OF TRANSAKTIONER-REKORD
                     BY CONTENT BELOB-RAW
                     BY REFERENCE BELOB-DKK

           PERFORM FIND-ELLER-OPRET-KUNDE
           ADD BELOB-DKK TO KUNDE-SALDO(IX)
           EXIT.

       FIND-ELLER-OPRET-KUNDE.
           MOVE 0 TO IX
           PERFORM VARYING IX FROM 1 BY 1 UNTIL IX > KUNDE-COUNT
               IF CPR OF TRANSAKTIONER-REKORD = KUNDE-CPR(IX)
                   EXIT PERFORM
               END-IF
           END-PERFORM

           IF IX > KUNDE-COUNT
               IF KUNDE-COUNT >= MAX-KUNDER
                   EXIT PARAGRAPH
               END-IF
               ADD 1 TO KUNDE-COUNT
               MOVE CPR OF TRANSAKTIONER-REKORD
                   TO KUNDE-CPR(KUNDE-COUNT)
               MOVE NAVN OF TRANSAKTIONER-REKORD
                   TO KUNDE-NAVN(KUNDE-COUNT)
               MOVE KUNDE-COUNT TO IX
           END-IF
           EXIT.

       FIND-TOP-3.
           MOVE 0 TO TOP-POSITION(1) TOP-POSITION(2) TOP-POSITION(3)

           PERFORM VARYING RANK-IDX FROM 1 BY 1 UNTIL RANK-IDX > 3
               MOVE 0 TO MAX-IDX
               PERFORM VARYING IX FROM 1 BY 1 UNTIL IX > KUNDE-COUNT
                   IF IX NOT = TOP-POSITION(1)
                      AND IX NOT = TOP-POSITION(2)
                      AND IX NOT = TOP-POSITION(3)
                      AND (MAX-IDX = 0 OR
                           KUNDE-SALDO(IX) > KUNDE-SALDO(MAX-IDX))
                       MOVE IX TO MAX-IDX
                   END-IF
               END-PERFORM
               MOVE MAX-IDX TO TOP-POSITION(RANK-IDX)
           END-PERFORM
           EXIT.

       SKRIV-TOP-3.
           PERFORM VARYING RANK-IDX FROM 1 BY 1 UNTIL RANK-IDX > 3
               IF TOP-POSITION(RANK-IDX) > 0
                   MOVE KUNDE-SALDO(TOP-POSITION(RANK-IDX))
                       TO SALDO-DISP
                   MOVE SPACES TO SALDO-OUT
                   IF KUNDE-SALDO(TOP-POSITION(RANK-IDX)) < 0
                       MOVE FUNCTION
                           ABS(KUNDE-SALDO(TOP-POSITION(RANK-IDX)))
                           TO SALDO-DISP
                       MOVE "-" TO SALDO-OUT(1:1)
                       MOVE FUNCTION TRIM(SALDO-DISP) TO SALDO-OUT(2:29)
                   ELSE
                       MOVE FUNCTION TRIM(SALDO-DISP) TO SALDO-OUT
                   END-IF

                   MOVE SPACES TO OUTPUT-TEXT
                   STRING "Kunde: "        DELIMITED BY SIZE
                          KUNDE-NAVN(TOP-POSITION(RANK-IDX))
                                            DELIMITED BY SIZE
                          " (CPR: "        DELIMITED BY SIZE
                          FUNCTION 
                          TRIM(KUNDE-CPR(TOP-POSITION(RANK-IDX)))
                                            DELIMITED BY SIZE
                          ") Saldo (DKK): " DELIMITED BY SIZE
                          SALDO-OUT        DELIMITED BY SIZE
                       INTO OUTPUT-TEXT
                   END-STRING
                   WRITE OUT-REKORD
               END-IF
           END-PERFORM
           EXIT.
