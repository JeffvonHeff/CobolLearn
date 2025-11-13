       IDENTIFICATION DIVISION. 
       PROGRAM-ID. Opgave3. 
       DATA DIVISION. 
       WORKING-STORAGE SECTION.
       01 Kunde-id           PIC X(10) VALUE SPACES.
       01 Fornavn            PIC X(20) VALUE SPACES.
       01 Efternavn          PIC X(20) VALUE SPACES.
       01 Kontonummer        PIC X(20) VALUE SPACES.
       01 Balance            PIC 9(7)V9(2) VALUE ZEROS.
       01 Valutakode         PIC X(3) VALUE SPACES.
       01 SamletNavn         PIC X(40) VALUE SPACES.
       01 IX                 PIC 9(7) VALUE 1.
       01 IX2                PIC 9(7) VALUE 1.
       01 CURRENT-CHAR       PIC X(1) VALUE SPACE.
       01 PREVIOUS-CHAR      PIC X(1) VALUE SPACE.
       01 CleanName          PIC X(40) VALUE SPACES.


       PROCEDURE DIVISION.
       MOVE "K123456789" TO Kunde-id
       MOVE "Lars" TO Fornavn
       MOVE "Hansen" TO Efternavn
       MOVE "DKK1234567890" TO Kontonummer
       MOVE "15000.75" TO Balance
       MOVE "DKK" TO Valutakode

       STRING Fornavn DELIMITED BY SIZE " "
             DELIMITED BY SIZE Efternavn
             DELIMITED BY SIZE
             INTO SamletNavn
       
       PERFORM VARYING IX FROM 1 BY 1 UNTIL IX > LENGTH OF SamletNavn
           MOVE SamletNavn(IX:1) TO CURRENT-CHAR
           IF CURRENT-CHAR NOT = SPACE OR PREVIOUS-CHAR NOT = SPACE
              MOVE CURRENT-CHAR TO CleanName(IX2:1)
              MOVE CURRENT-CHAR TO PREVIOUS-CHAR
              ADD 1 TO IX2
           END-IF
       END-PERFORM

       DISPLAY "--------------------------------".
       DISPLAY "Kunde-id           : " Kunde-id.
       DISPLAY "Navn (renset)      : " CleanName.
       DISPLAY "Kontonummer        : " Kontonummer.
       DISPLAY "Balance            : " Balance" "Valutakode.
       DISPLAY "--------------------------------".

       STOP RUN.  
       