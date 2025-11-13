       IDENTIFICATION DIVISION. 
       PROGRAM-ID. Opgave4. 
       DATA DIVISION. 
       WORKING-STORAGE SECTION.
       01 KUNDEOPL.
           02 KUNDE-ID         PIC X(10) VALUE SPACES.
           02 FORNAVN          PIC X(20) VALUE SPACES.
           02 EFTERNAVN        PIC X(20) VALUE SPACES.
           02 KONTOINFO.
               03 KONTONUMMER      PIC X(20) VALUE SPACES.
               03 BALANCE          PIC 9(7)V9(2) VALUE ZEROS.
               03 VALUTAKODE       PIC X(3) VALUE SPACES.


       PROCEDURE DIVISION.
       MOVE "K123456789" TO KUNDE-ID
       MOVE "Lars" TO FORNAVN
       MOVE "Hansen" TO EFTERNAVN
       MOVE "DKK1234567890" TO KONTONUMMER
       MOVE "15000.75" TO BALANCE
       MOVE "DKK" TO VALUTAKODE
      *Nedenfor kommer en display - Cobols måde at skrive i konsollen 
       DISPLAY KUNDEOPL
       STOP RUN.  
       