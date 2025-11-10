       IDENTIFICATION DIVISION. 
       PROGRAM-ID. Opgave2. 
       DATA DIVISION. 
       WORKING-STORAGE SECTION.
       01 Kunde-id     PIC X(10) VALUE SPACES.
       01 Fornavn     PIC X(20) VALUE SPACES.
       01 Efternavn     PIC X(20) VALUE SPACES.
       01 Kontonummer     PIC X(20) VALUE SPACES.
       01 Balance     PIC 9(7)V9(2) VALUE ZEROS.
       01 Valutakode     PIC X(3) VALUE SPACES.
       PROCEDURE DIVISION.
       MOVE "K123456789" TO Kunde-id
       MOVE "Lars" TO Fornavn
       MOVE "Hansen" TO Efternavn
       MOVE "DKK1234567890" TO Kontonummer
       MOVE "15000.75" TO Balance
       MOVE "DKK" TO Valutakode
      *Nedenfor kommer en display - Cobols måde at skrive i konsollen 
       DISPLAY "Kunde-id: "  Kunde-id.
       DISPLAY "Fornavn & efternavn: "  Fornavn Efternavn.
       DISPLAY "Kontonummer: "  Kontonummer.
       DISPLAY "Balance: "  Balance Valutakode.
       STOP RUN.  
       