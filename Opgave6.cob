       IDENTIFICATION DIVISION. 
       PROGRAM-ID. Opgave6. 
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT KUNDEFIL ASSIGN TO "Kundeoplysninger.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
       DATA DIVISION. 
       FILE SECTION.
       FD KUNDEFIL.
       01 KUNDEOPL.
       COPY "KUNDEOPL.CPY".
       WORKING-STORAGE SECTION.
       01 END-OF-FILE     PIC X VALUE "N".
       
       PROCEDURE DIVISION.
           OPEN INPUT KUNDEFIL
              PERFORM UNTIL END-OF-FILE = "Y"
                READ KUNDEFIL
                     AT END
                          MOVE "Y" TO END-OF-FILE
                     NOT AT END
                          DISPLAY KUNDEOPL
                END-READ
              END-PERFORM
       
       CLOSE KUNDEFIL
       STOP RUN.  
       