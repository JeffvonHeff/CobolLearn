       IDENTIFICATION DIVISION. 
       PROGRAM-ID. Opgave7del2. 
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
           COPY "KUNDEOPL.CPY".
               
       FD OUTPUT-FILE.
       01 OUTPUT-KUNDE-ADR.
         02 NAVN-ADR PIC X(150).
       
       
       WORKING-STORAGE SECTION.
       01 END-OF-FILE         PIC X VALUE "N".
       01 SamletNavn          PIC X(40) VALUE SPACES.
       01 SamletAdr           PIC X(100) VALUE SPACES.
       01 PostnrogBy          PIC X(50) VALUE SPACES.
       01 TelefonogMail       PIC X(50) VALUE SPACES.
       
       PROCEDURE DIVISION.




           OPEN INPUT INPUT-FILE
           OPEN OUTPUT OUTPUT-FILE

              PERFORM UNTIL END-OF-FILE = "Y"
                READ INPUT-FILE
                     AT END
                          MOVE "Y" TO END-OF-FILE
                     NOT AT END
                         PERFORM KUNDEBEHANDLING
                END-READ
              END-PERFORM
       
       CLOSE INPUT-FILE
             OUTPUT-FILE

       STOP RUN.  
       
       KUNDEBEHANDLING.
           PERFORM FORMAT-NAVN
           PERFORM FORMAT-ADRESSE
           PERFORM FORMAT-POSTNRBY
           PERFORM FORMAT-TELEFONMAIL



       MOVE SPACES TO NAVN-ADR
       STRING "KUNDE-ID: " KUNDE-ID DELIMITED BY SIZE
            INTO NAVN-ADR
       END-STRING
       WRITE OUTPUT-KUNDE-ADR

       MOVE SPACES TO NAVN-ADR
       STRING "NAVN: " SamletNavn DELIMITED BY SIZE
            INTO NAVN-ADR
       END-STRING
       WRITE OUTPUT-KUNDE-ADR

       MOVE SPACES TO NAVN-ADR
       STRING "ADRESSE: " SamletAdr DELIMITED BY SIZE
            INTO NAVN-ADR
       END-STRING
       WRITE OUTPUT-KUNDE-ADR

       MOVE SPACES TO NAVN-ADR
       STRING "BY: " PostnrogBy DELIMITED BY SIZE
            INTO NAVN-ADR
       END-STRING
       WRITE OUTPUT-KUNDE-ADR

       MOVE SPACES TO NAVN-ADR
       STRING "KONTAKT: " TelefonogMail DELIMITED BY SIZE
            INTO NAVN-ADR
       END-STRING
       WRITE OUTPUT-KUNDE-ADR

       MOVE SPACES TO NAVN-ADR
       WRITE OUTPUT-KUNDE-ADR
       EXIT.



       FORMAT-NAVN.
           MOVE SPACES TO SamletNavn
           STRING FORNAVN DELIMITED BY SPACE
             " " DELIMITED BY SIZE
             EFTERNAVN DELIMITED BY SPACE
             INTO SamletNavn
           END-STRING
           EXIT.

       FORMAT-ADRESSE.
           MOVE SPACES TO SamletAdr
           STRING VEJNAVN OF ADDRESSE DELIMITED BY SPACE
               " " DELIMITED BY SIZE
               HUSNR OF ADDRESSE DELIMITED BY SPACE
               " " DELIMITED BY SIZE
               ETAGE OF ADDRESSE DELIMITED BY SPACE
               " " DELIMITED BY SIZE
               SIDE OF ADDRESSE DELIMITED BY SPACE
               INTO SamletAdr
           END-STRING
           EXIT.

       FORMAT-POSTNRBY.
           MOVE SPACES TO PostnrogBy
           STRING POSTNR OF ADDRESSE DELIMITED BY SPACE
               " " DELIMITED BY SIZE
               BYNAVN OF ADDRESSE DELIMITED BY SPACE
               INTO PostnrogBy
           END-STRING
           EXIT.
       
       FORMAT-TELEFONMAIL.
           MOVE SPACES TO TelefonogMail
           STRING TELEFON OF KONTAKT DELIMITED BY SPACE
               " " DELIMITED BY SIZE
               EMAIL OF KONTAKT DELIMITED BY SPACE
               INTO TelefonogMail
           END-STRING
           EXIT.   
