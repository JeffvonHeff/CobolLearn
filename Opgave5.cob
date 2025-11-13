       IDENTIFICATION DIVISION. 
       PROGRAM-ID. Opgave5. 
       DATA DIVISION. 
       WORKING-STORAGE SECTION.
       01 KUNDEOPL.
       COPY "KUNDEOPL.CPY".
       

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
       