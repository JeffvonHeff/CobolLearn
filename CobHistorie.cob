       >>SOURCE FORMAT FREE
       *> COBOL-kode som en by: 01 er selve byen, 02 er huse, 03 er rum.
       *> MOVE er flyttedagen, hvor beboere og værdier flytter ind.
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CobHistorie.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       *> BYEN rummer alle huse og rum
       01 BY-KUNDEBY.
          02 HUS-IDENTITET.
             03 RUM-KUNDE-ID   PIC X(10)     VALUE SPACES.
             03 RUM-FORNAVN    PIC X(20)     VALUE SPACES.
             03 RUM-EFTERNAVN  PIC X(20)     VALUE SPACES.
          02 HUS-KONTO.
             03 RUM-KONTONR    PIC X(20)     VALUE SPACES.
             03 RUM-BALANCE    PIC 9(7)V9(2) VALUE ZEROS.
             03 RUM-VALUTA     PIC X(3)      VALUE SPACES.
       
       PROCEDURE DIVISION.
           *> Flyttedag: værdierne flytter ind i de rette rum
           *> Fyld HUS-IDENTITET med kundeinfo
           MOVE "K123456789"    TO RUM-KUNDE-ID
           MOVE "Lars"          TO RUM-FORNAVN
           MOVE "Hansen"        TO RUM-EFTERNAVN
           
           *> Fyld HUS-KONTO med kontonr, balance og valuta
           MOVE "DKK1234567890" TO RUM-KONTONR
           MOVE "15000.75"      TO RUM-BALANCE
           MOVE "DKK"           TO RUM-VALUTA
       
           *> Fortæl historien ved at vise hele byen med huse og rum
           DISPLAY "--------------------------------"
           DISPLAY "Byen er fyldt:"
           DISPLAY BY-KUNDEBY
           DISPLAY "--------------------------------"
           STOP RUN.
       