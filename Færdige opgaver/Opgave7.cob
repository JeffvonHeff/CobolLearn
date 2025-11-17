       IDENTIFICATION DIVISION. 
       PROGRAM-ID. Opgave7. 
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE ASSIGN TO "Kundeoplysninger.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT OUTPUT-FILE ASSIGN TO "KundeoplysningerOut.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
       DATA DIVISION. 
       FILE SECTION.
       FD INPUT-FILE.
       01 INPUT-KUNDE-ADR.
         02 NAVN-ADR PIC X(150).

       FD OUTPUT-FILE.
       01 OUTPUT-KUNDE-ADR.
         02 NAVN-ADR PIC X(150).
       
       
       WORKING-STORAGE SECTION.
       01 END-OF-FILE     PIC X VALUE "N".
       
       PROCEDURE DIVISION.
           OPEN INPUT INPUT-FILE
           OPEN OUTPUT OUTPUT-FILE

              PERFORM UNTIL END-OF-FILE = "Y"
                READ INPUT-FILE
                     AT END
                          MOVE "Y" TO END-OF-FILE
                     NOT AT END
                          MOVE INPUT-KUNDE-ADR TO OUTPUT-KUNDE-ADR
                          WRITE OUTPUT-KUNDE-ADR
                          DISPLAY "Noget tekst? " OUTPUT-KUNDE-ADR
                END-READ
              END-PERFORM
       
       CLOSE INPUT-FILE
       CLOSE OUTPUT-FILE
       STOP RUN.  
       