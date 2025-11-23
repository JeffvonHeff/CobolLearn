       IDENTIFICATION DIVISION.
       PROGRAM-ID. ValutaModul.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 VALUTA-RATE PIC 9V9 VALUE 1,0.
       01 BELOB-TEXT-NORM PIC X(16) VALUE SPACES.

       LINKAGE SECTION.
       01 P-VALUTA PIC X(4).
       01 P-BELOB-RAW PIC X(16).
       01 P-BELOB-DKK PIC S9(13)V99.

       PROCEDURE DIVISION USING P-VALUTA
                                 P-BELOB-RAW
                                 P-BELOB-DKK.
           MOVE 1,0 TO VALUTA-RATE
           IF P-VALUTA(1:3) = "USD"
               MOVE 6,7 TO VALUTA-RATE
           ELSE
               IF P-VALUTA(1:3) = "EUR"
                   MOVE 7,5 TO VALUTA-RATE
               END-IF
           END-IF

           MOVE FUNCTION TRIM(P-BELOB-RAW) TO BELOB-TEXT-NORM
           INSPECT BELOB-TEXT-NORM CONVERTING "." TO ","
           COMPUTE P-BELOB-DKK = FUNCTION NUMVAL-C(BELOB-TEXT-NORM) *
               VALUTA-RATE
           GOBACK.
