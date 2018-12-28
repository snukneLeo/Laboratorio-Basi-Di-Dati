--ESERCIZIO 1
SELECT count(id) --STESSA COSA COUNT(*)
FROM CorsoStudi;

--ESERCIZIO 2
SELECT nome,codice,indirizzo,id_preside_persona
FROM facolta;

--ESERCIZIO 3
SELECT DISTINCT C.nome,F.nome
FROM 
    INSEROGATO AS IE 
    JOIN CORSOSTUDI AS C ON IE.id_corsostudi = C.ID
    JOIN CORSOINFACOLTA AS CIF ON C.id = CIF.id_corsostudi
    JOIN FACOLTA AS F ON F.id = CIF.id_facolta
WHERE IE.annoAccademico = '2010/2011'
ORDER BY C.nome;
LIMIT 5  OFFSET 9 --QUANTE RIGHE AL PIÙ DA VISUALIZZARE (STAMPA SOLO LE 5 RIGHE) OFFSET --> BUTTO VIA LE RIGHE E PARTO DALLA 10
                  -- OFFSET N--> CANCELLA LE PRIME N RIGHE

--ESERCIZIO 4
SELECT C.nome, C.codice, C.abbreviazione --POTREBBE VOLERCI ANCHE IL DISTINCT
FROM CORSOINFACOLTA AS CIF
     JOIN CORSOSTUDI AS C ON C.id = CIF.id_corsostudi 
     JOIN FACOLTA AS F ON F.id = CIF.id_facolta
WHERE F.nome = 'Medicina e Chirurgia';

--ESERCIZIO 5
SELECT C.codice,C.nome,C.abbreviazione
FROM CorsoStudi C
WHERE C.nome ILIKE '%lingue%'; --PATTERN TRA % % PUÒ ESSERE DA QUALUNQUE PARTE
                               --SIMILAR TO '%lingue%' --> scritto come se ci fosse LIKE quindi mi darebbe 0 
                               --perchè è come fosse scritto il pattern in minuscolo

--ESERCIZIO 6
SELECT DISTINCT C.sede 
FROM CORSOSTUDI C;
--OPPURE
SELECT C.sede
FROM CORSOSTUDI C
GROUP BY C.sede;

--ESERCIZIO 7
SELECT DISTINCT IE.nomemodulo, I.nomeins, D.descrizione,IE.modulo
FROM INSEROGATO AS IE
     JOIN INSEGN AS I ON IE.id_insegn = I.id
     JOIN DISCRIMINANTE AS D ON D.id = IE.id_discriminante
     JOIN CORSOSTUDI AS CS ON IE.id_corsostudi = CS.id
     JOIN CORSOINFACOLTA AS CIF ON CS.id = CIF.id_corsostudi
     JOIN FACOLTA AS F ON CIF.id_facolta = F.id
    --ASSOCIARE I CORSI DI STUDI NELLA FACOLTA
WHERE F.nome ILIKE 'Economia' AND
      IE.annoAccademico = '2010/2011';

--ESERCIZIO 8
SELECT DISTINCT INS.nomeins,D.descrizione
FROM INSEROGATO AS IE
     JOIN DISCRIMINANTE AS D ON D.id = IE.id_discriminante
     JOIN INSEGN AS INS ON IE.id_insegn = INS.id
WHERE IE.annoAccademico = '2009/2010' AND 
      IE.modulo = 0 AND
      --( IE.crediti = 3 OR IE.crediti = 5 OR IE.crediti = 12)
      IE.crediti IN (3,5,12)
ORDER BY D.descrizione;

--ESERCIZIO 9
SELECT IE.id, I.nomeins, D.descrizione
FROM INSEROGATO AS IE
     JOIN INSEGN AS I ON I.id = IE.id_insegn
     JOIN DISCRIMINANTE AS D ON D.id = IE.id_discriminante
WHERE IE.annoAccademico = '2008/2009' AND
      IE.modulo = 0 AND
      IE.crediti > 9
ORDER BY I.nomeins;

--ESERCIZIO 10
SELECT I.nomeins, D.descrizione, IE.crediti, IE.annierogazione
FROM INSEROGATO AS IE
     JOIN INSEGN AS I ON IE.id_insegn = I.id
     JOIN CORSOSTUDI AS C ON C.id = IE.id_corsostudi
     JOIN DISCRIMINANTE AS D ON D.id = IE.id_discriminante
WHERE IE.annoAccademico = '2010/2011' AND
      IE.modulo = 0 AND
      C.nome = 'Laurea in Informatica'
ORDER BY I.nomeins;

--ESERCIZIO 11
SELECT MAX(IE.crediti)
FROM INSEROGATO IE
WHERE IE.annoAccademico = '2010/2011';

--ESERCIZIO 12
SELECT MAX(IE.crediti) AS MAXCredito, MIN(IE.crediti) AS MINCredito, IE.annoAccademico
FROM INSEROGATO IE
GROUP BY IE.annoAccademico;

--ESERCIZIO 13
SELECT SUM(IE.crediti), MAX(IE.crediti), MIN(IE.crediti) , IE.annoAccademico AS annoAccademico,C.nome AS NomeCorso--,C.nome,IE.annoAccademico
FROM INSEROGATO AS IE
     JOIN CORSOSTUDI AS C ON C.id = IE.id_corsostudi
WHERE IE.modulo = 0
GROUP BY IE.annoAccademico , C.nome;
--LIMIT 10 OFFSET 9;
--ORDER BY C.nome DESC;


--ESERCIZIO 14
SELECT COUNT(IE.id_insegn),C.nome
FROM INSEROGATO AS IE
     JOIN CORSOSTUDI AS C ON C.id = IE.id_corsostudi
     JOIN FACOLTA AS F ON F.id = IE.id_facolta
WHERE IE.modulo = 0 AND
      IE.annoAccademico = '2009/2010' AND
      F.nome ILIKE '%Scienze Matematiche Fisiche e Naturali%'
GROUP BY C.nome;

--ESERCIZIO 15
SELECT DISTINCT C.nome, C.durataAnni
FROM INSEROGATO AS IE
     JOIN CORSOSTUDI AS C ON C.id = IE.id_corsostudi
WHERE IE.annoAccademico = '2010/2011' AND
      (IE.crediti IN (4,6,8,10,12) OR
      IE.creditilab BETWEEN 10 AND 14); 
      --((IE.creditilab >10 AND IE.creditilab < 15)));
      --  ((IE.creditilab <10 OR IE.creditilab > 15)));