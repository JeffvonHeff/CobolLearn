       >>SOURCE FORMAT FREE
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
           SELECT OUT-FIL ASSIGN TO "RigeKunder.txt"
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

       01 MAX-KUNDER PIC 9(5) VALUE 10000.
       01 KUNDE-COUNT PIC 9(5) VALUE 0.
       01 RANK-IDX PIC 9(5) VALUE 0.
       01 KUNDER.
          05 KUNDE-TABEL OCCURS 10000 TIMES.
             10 KUNDE-CPR PIC X(15) VALUE SPACES.
             10 KUNDE-NAVN PIC X(30) VALUE SPACES.
             10 KUNDE-SALDO PIC S9(15)V99 VALUE 0.

       01 TOP-IDX.
          05 TOP-POSITION PIC 9(5) OCCURS 3 TIMES VALUE 0.

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
           CALL "TransaktionModul"
               USING BY REFERENCE TRANSAKTIONER-REKORD
                     BY REFERENCE TRANSAKTIONER-RAW
                     BY REFERENCE KUNDER
                     BY REFERENCE KUNDE-COUNT
                     BY REFERENCE MAX-KUNDER
           EXIT.

       FIND-TOP-3.
           CALL "Top3Modul"
               USING BY REFERENCE KUNDER
                     BY REFERENCE KUNDE-COUNT
                     BY REFERENCE TOP-IDX
           EXIT.

       SKRIV-TOP-3.
           PERFORM VARYING RANK-IDX FROM 1 BY 1 UNTIL RANK-IDX > 3
               IF TOP-POSITION(RANK-IDX) > 0
                   CALL "Top3FormatModul"
                       USING BY REFERENCE 
                       KUNDE-NAVN(TOP-POSITION(RANK-IDX))
                             BY REFERENCE 
                             KUNDE-CPR(TOP-POSITION(RANK-IDX))
                             BY REFERENCE 
                             KUNDE-SALDO(TOP-POSITION(RANK-IDX))
                             BY REFERENCE 
                             OUTPUT-TEXT
                   WRITE OUT-REKORD
               END-IF
           END-PERFORM
           EXIT.
