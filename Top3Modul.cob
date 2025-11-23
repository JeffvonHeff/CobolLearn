       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. Top3Modul.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-RANK-IDX PIC 9(5) VALUE 0.
       01 WS-IX PIC 9(5) VALUE 0.
       01 WS-MAX-IDX PIC 9(5) VALUE 0.

       LINKAGE SECTION.
       01 P-KUNDER.
          05 P-KUNDE-TABEL OCCURS 10000 TIMES.
             10 P-KUNDE-CPR PIC X(15).
             10 P-KUNDE-NAVN PIC X(30).
             10 P-KUNDE-SALDO PIC S9(15)V99.

       01 P-KUNDE-COUNT PIC 9(5).
       01 P-TOP-IDX.
          05 P-TOP-POSITION PIC 9(5) OCCURS 3 TIMES.

       PROCEDURE DIVISION USING BY REFERENCE P-KUNDER
                                 P-KUNDE-COUNT
                                 P-TOP-IDX.
           MOVE 0 TO P-TOP-POSITION(1) P-TOP-POSITION(2) P-TOP-POSITION(3)

           PERFORM VARYING WS-RANK-IDX FROM 1 BY 1 UNTIL WS-RANK-IDX > 3
               MOVE 0 TO WS-MAX-IDX
               PERFORM VARYING WS-IX FROM 1 BY 1 UNTIL WS-IX > P-KUNDE-COUNT
                   IF WS-IX NOT = P-TOP-POSITION(1)
                      AND WS-IX NOT = P-TOP-POSITION(2)
                      AND WS-IX NOT = P-TOP-POSITION(3)
                      AND (WS-MAX-IDX = 0 OR
                           P-KUNDE-SALDO(WS-IX) > P-KUNDE-SALDO(WS-MAX-IDX))
                       MOVE WS-IX TO WS-MAX-IDX
                   END-IF
               END-PERFORM
               MOVE WS-MAX-IDX TO P-TOP-POSITION(WS-RANK-IDX)
           END-PERFORM
           GOBACK.
