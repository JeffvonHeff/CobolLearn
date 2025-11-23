       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TransaktionModul.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-BELOB-RAW PIC X(16) VALUE SPACES.
       01 WS-BELOB-DKK PIC S9(13)V99 VALUE 0.
       01 WS-IX PIC 9(5) VALUE 0.

       LINKAGE SECTION.
       01 P-TRANSAKTION-REKORD.
       COPY "TRANSACTIONS.cpy".
       01 P-TRANSAKTION-RAW PIC X(211).

       01 P-KUNDER.
          05 P-KUNDE-TABEL OCCURS 10000 TIMES.
             10 P-KUNDE-CPR PIC X(15).
             10 P-KUNDE-NAVN PIC X(30).
             10 P-KUNDE-SALDO PIC S9(15)V99.

       01 P-KUNDE-COUNT PIC 9(5).
       01 P-MAX-KUNDER PIC 9(5).

       PROCEDURE DIVISION USING BY REFERENCE P-TRANSAKTION-REKORD
                                 P-TRANSAKTION-RAW
                                 P-KUNDER
                                 P-KUNDE-COUNT
                                 P-MAX-KUNDER.
           MOVE P-TRANSAKTION-RAW(127:16) TO WS-BELOB-RAW
           CALL "ValutaModul"
               USING BY REFERENCE VALUTA OF P-TRANSAKTION-REKORD
                     BY REFERENCE WS-BELOB-RAW
                     BY REFERENCE WS-BELOB-DKK

           MOVE 0 TO WS-IX
           PERFORM VARYING WS-IX FROM 1 BY 1 UNTIL WS-IX > P-KUNDE-COUNT
               IF CPR OF P-TRANSAKTION-REKORD = P-KUNDE-CPR(WS-IX)
                   EXIT PERFORM
               END-IF
           END-PERFORM

           IF WS-IX > P-KUNDE-COUNT
               IF P-KUNDE-COUNT >= P-MAX-KUNDER
                   GOBACK
               END-IF
               ADD 1 TO P-KUNDE-COUNT
               MOVE CPR OF P-TRANSAKTION-REKORD
                   TO P-KUNDE-CPR(P-KUNDE-COUNT)
               MOVE NAVN OF P-TRANSAKTION-REKORD
                   TO P-KUNDE-NAVN(P-KUNDE-COUNT)
               MOVE P-KUNDE-COUNT TO WS-IX
           END-IF

           ADD WS-BELOB-DKK TO P-KUNDE-SALDO(WS-IX)
           GOBACK.
