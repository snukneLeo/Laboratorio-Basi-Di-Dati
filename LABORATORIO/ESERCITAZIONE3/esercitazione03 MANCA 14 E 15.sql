--ESERCIZIO 1
SELECT P.id, P.nome, P.cognome
FROM Persona P
WHERE p.id in 
  (
    SELECT D.id_persona
    FROM docenza D
         JOIN InsErogato IE ON D.id_inserogato = IE.id
    WHERE IE.annoaccademico = '2010/2011'
    GROUP BY d.id_persona
    HAVING COUNT(distinct IE.id_corsostudi) >= 2
  )
ORDER BY P.id
LIMIT 5 OFFSET 49;

SELECT D.id_persona
    FROM docenza D
         JOIN InsErogato IE ON D.id_inserogato = IE.id
    WHERE IE.id >= ALL
    (
          select max(ie1.id)
          from inserogato ie1
    );




--ESERCIZIO 2 (DIFFERENZA)
SELECT P.nome, P.cognome, P.telefono
FROM PERSONA P
WHERE P.id IN 
(
  SELECT D.id_persona
  FROM DOCENZA D
        JOIN InsErogato AS IE ON IE.id = D.id_inserogato
  WHERE IE.annoaccademico = '2009/2010'
        AND IE.modulo >= 0
        AND IE.id_corsostudi = 4

        EXCEPT

  SELECT D.id_persona
  FROM DOCENZA D 
        JOIN InsErogato AS IE ON IE.id = D.id_inserogato
        JOIN INSEGN AS I ON I.id = IE.id_insegn
  WHERE I.nomeIns ILIKE 'Programmazione'
        AND IE.id_corsostudi = 4
)
ORDER BY P.nome;


--ESERCIZIO 3
SELECT DISTINCT P.id, P.cognome, P.nome
FROM Persona AS P 
     JOIN Docenza AS D ON P.id = D.id_persona
	   JOIN InsErogato AS IE ON D.id_inserogato = IE.id
	   JOIN Insegn AS I ON IE.id_insegn = I.id
     WHERE IE.annoaccademico = '2010/2011'
	     AND ROW(D.id_persona, I.nomeins) NOT IN 
           (
		     SELECT D1.id_persona, I1.nomeins
		     FROM InsErogato AS IE1 
                      JOIN Docenza AS D1 ON D1.id_inserogato = IE1.id
			           JOIN Insegn AS I1 ON IE1.id_insegn = I1.id
	 	        WHERE IE1.annoaccademico = '2009/2010'
	     )
LIMIT 5 OFFSET 19;

--ESERCIZIO 4
SELECT PD.DISCRIMINANTE, PD.INIZIO, PD.FINE,COUNT(IE.id_insegn)
FROM INSINPERIODO IP
     JOIN PERIODOLEZ AS PL ON PL.id = IP.ID_PERIODOLEZ
     JOIN PERIODODID AS PD ON PD.ID = PL.ID
     JOIN InsErogato AS IE ON IE.ID = IP.id_inserogato
WHERE PD.annoaccademico = '2010/2011'
      AND (PD.DESCRIZIONE ILIKE 'I semestre' 
      OR   PD.DESCRIZIONE ILIKE 'Primo semestre')
GROUP BY PD.DISCRIMINANTE, PD.INIZIO, PD.FINE
ORDER BY PD.INIZIO, PD.FINE;

--ESERCIZIO 5
SELECT COUNT(IE.id) AS "Inserogato", SUM(ie.crediti) AS "Crediti",F.nome
FROM INSEROGATO IE
     JOIN FACOLTA AS F ON F.ID = IE.id_facolta
WHERE IE.annoaccademico = '2010/2011'
      AND IE.modulo < 0
GROUP BY F.nome;

--ESERCIZIO 6
SELECT DISTINCT CS.nome, COUNT(IE.ID)
FROM INSEROGATO IE
     JOIN CORSOSTUDI AS CS ON CS.ID = IE.id_corsostudi
     JOIN FACOLTA AS F ON F.ID = IE.id_facolta
WHERE IE.hamoduli >'0'
      AND IE.annoaccademico = '2010/2011'
      AND F.nome NOT ILIKE ('%Medicina e Chirurgia%')
GROUP BY CS.NOME
ORDER BY CS.nome;

--ESERCIZIO 7
SELECT DISTINCT I.nomeIns
FROM INSEROGATO IE
     JOIN INSEGN AS I ON I.id = IE.id_insegn
WHERE IE.id_corsostudi = 4
      AND IE.id_insegn NOT IN
      (
            SELECT IE1.id_insegn
            FROM INSINPERIODO IP
                 JOIN PERIODOLEZ AS PL ON PL.ID = IP.ID_PERIODOLEZ
                 JOIN INSEROGATO AS IE1 ON IE1.ID = IP.id_inserogato
            WHERE (PL.ABBREVIAZIONE LIKE '2%')
                  AND IE1.id_corsostudi = 4
      );

--ESERCIZIO 8
DROP VIEW IF EXISTS OreDocentiFacolta CASCADE;
DROP VIEW IF EXISTS MaxOreDocentiFacolta CASCADE;

CREATE TEMP VIEW OreDocentiFacolta AS (
	SELECT D.id_persona AS idpersona, F.nome AS nomefacolta, SUM(D.orelez) AS sommaore
 	FROM inserogato IE 
           JOIN corsostudi C ON IE.id_corsostudi =  C.id
   	     JOIN corsoinfacolta CF ON CF.id_corsostudi = C.id
   	     JOIN Facolta F ON CF.id_facolta = F.id
   	     JOIN Docenza D ON D.id_inserogato = IE.id
 	WHERE D.orelez IS NOT NULL 
 		AND IE.annoaccademico = '2009/2010'
	GROUP BY D.id_persona, F.nome
);

CREATE TEMP VIEW MaxOreDocentiFacolta AS (
	SELECT ODF.nomefacolta AS nomefacolta, MAX(ODF.sommaore) AS maxsommaore
 	FROM OreDocentiFacolta ODF
 	GROUP BY ODF.nomefacolta
);

SELECT P.cognome, P.nome, ODF.nomefacolta, ODF.sommaore
FROM Persona P 
     JOIN OreDocentiFacolta ODF ON P.id = ODF.idpersona
WHERE ROW(ODF.nomefacolta, ODF.sommaore) IN 
(
 	SELECT *
 	FROM MaxOreDocentiFacolta
)

ORDER BY P.cognome,P.nome;

--ESERCIZIO 9 
-- (USO EXIST PERCHÈ NON POSSO FARE ALTRO CHE VALUTARE)
-- (IN ENTRAMBI I CASI SIA L'ANNO ACCADENICO 2009/2010 AND 2010/2011)
SELECT distinct I.nomeIns,D.DESCRIZIONE--,P.nome
FROM INSEROGATO IE
     JOIN DOCENZA AS DOC ON DOC.id_inserogato = IE.id
     JOIN PERSONA AS P ON P.id = DOC.id_persona
     JOIN INSEGN AS I ON I.ID = IE.id_insegn
     JOIN DISCRIMINANTE AS D ON IE.ID_DISCRIMINANTE = D.id
WHERE IE.id_corsostudi = 240
      AND IE.annoaccademico = '2009/2010'
      AND P.nome NOT IN('Roberto','Alberto','Massimo','Luca')
      AND IE.modulo = '0'
      AND EXISTS
      (
            SELECT 1
            FROM INSEROGATO IE1
                 JOIN DOCENZA AS DOC1 ON DOC1.id_inserogato = IE1.id
                 JOIN PERSONA AS P1 ON P1.id = DOC1.id_persona
                 JOIN INSEGN AS I1 ON I1.ID = IE1.id_insegn
            WHERE IE1.id_corsostudi = 240
                  AND IE1.annoaccademico = '2010/2011'
                  AND P1.nome NOT IN('Roberto','Alberto','Massimo','Luca')
                  AND IE1.modulo = '0'
                  AND IE1.id_insegn = IE.id_insegn ----------IMPORTANTISSIMO
      )
ORDER BY I.nomeins;


--ESERCIZIO 10
SELECT DISTINCT I.nomeins, IE.nomeunita
FROM INSEROGATO IE
     JOIN INSEGN AS I ON I.id = IE.id_insegn
     JOIN LEZIONE AS L ON IE.id = L.id_inserogato
WHERE IE.annoaccademico = '2010/2011'
      AND IE.id_corsostudi = 420
      AND IE.modulo < '0'
      AND 
      ((L.GIORNO = 2
            AND NOT EXISTS
            (
                  SELECT 1 
                  FROM LEZIONE L1 
                  WHERE L1.id_inserogato = L.id_inserogato
                        AND L.id <> L1.id
                        AND L1.GIORNO = 3
            )
      )
      OR 
            (
                  L.GIORNO = 3
                  AND NOT EXISTS
                  (
                        SELECT 1 
                        FROM LEZIONE L1 
                        WHERE L1.id_inserogato = L.id_inserogato
                              AND L.id <> L1.id
                              AND L1.GIORNO = 2  
                  )
            )
      )
ORDER BY I.nomeIns;


--ESERCIZIO 11
SELECT CS.nome
FROM CORSOSTUDI AS CS

EXCEPT

SELECT CS.NOME
FROM CORSOSTUDI CS
     JOIN INSEROGATO AS IE ON IE.id_corsostudi = CS.id
     JOIN INSEGN AS I ON I.ID = IE.id_insegn
WHERE I.nomeIns ILIKE '%MATEMATICA%';

--ESERCIZIO 12
CREATE TEMP VIEW subAnno AS 
(
      SELECT I.id,D.id_persona,
             CAST(SUBSTRING(IE.annoaccademico FROM 1 FOR 4) AS INTEGER) AS anno
      FROM INSEROGATO IE
           JOIN DOCENZA AS D ON D.id_inserogato = IE.ID
           JOIN INSEGN AS I ON IE.id_insegn = I.ID
      WHERE IE.modulo = '0'
      GROUP BY I.ID, D.id_persona, anno
);

SELECT DISTINCT I.nomeins,P.nome,P.cognome
FROM INSEROGATO IE
     JOIN CORSOSTUDI AS CS ON CS.ID = IE.id_corsostudi
     JOIN corsoinfacolta AS CIF ON CIF.id_corsostudi = CS.ID
     JOIN FACOLTA AS F ON F.ID = CIF.id_facolta
     JOIN DOCENZA AS D ON D.id_inserogato = IE.ID
     JOIN PERSONA AS P ON P.ID = D.id_persona
     JOIN INSEGN AS I ON I.ID = IE.id_insegn
WHERE IE.modulo = 0
	AND F.nome ILIKE 'Scienze Mate%'
	AND (I.id, D.id_persona, (CAST(SUBSTRING(IE.annoaccademico FROM 6 FOR 4) AS INTEGER))) IN 
      (
		SELECT *
		FROM subAnno AS ANNO 
      )
LIMIT 5 OFFSET 531;

--ESERCIZIO 13
SELECT SS.NOMESTRUTTURA, SS.FAX, COUNT(cs.id)
FROM STRUTTURASERVIZIO SS
     JOIN CORSOSTUDI AS CS ON CS.ID_SEGRETERIA = SS.ID
GROUP BY SS.ID
HAVING COUNT(CS.id) >= 1;

--ESERCIZIO 14

DROP VIEW IF EXISTS conteggioProfessoriCreditiMag0 CASCADE;
CREATE TEMP VIEW conteggioProfessoriCreditiMag0 AS
(
      SELECT DISTINCT D.id_persona,SUM(D.creditilez) AS CREDITIPERPROFESSORE
      FROM DOCENZA D
           JOIN INSEROGATO AS IE ON IE.id = D.id_persona
      WHERE D.creditilez > 0
            AND IE.annoaccademico = '2010/2011'
      GROUP BY D.id_persona
);

SELECT AVG(conteggioProfessoriCreditiMag0.CREDITIPERPROFESSORE) AS MEDIA 
FROM conteggioProfessoriCreditiMag0;




--ESERCIZIO 15
DROP VIEW IF EXISTS PROFINSEGN CASCADE;
CREATE TEMP VIEW PROFINSEGN AS
(
      SELECT P.NOME,P.ID,P.cognome, COUNT(IE.id_insegn)
      FROM DOCENZA D
      JOIN PERSONA AS P ON P.ID = D.id_persona
      JOIN INSEROGATO AS IE ON IE.ID = D.id_inserogato
      WHERE IE.annoaccademico = '2005/2006'
            AND IE.modulo = '0'
      GROUP BY P.ID
);

DROP VIEW IF EXISTS PROFUNITA CASCADE;
CREATE TEMP VIEW PROFUNITA AS
(
      SELECT P.NOME,P.ID,P.cognome, COUNT(IE.nomeunita)
      FROM DOCENZA D
      JOIN PERSONA AS P ON P.ID = D.id_persona
      JOIN INSEROGATO AS IE ON IE.ID = D.id_inserogato
      WHERE IE.annoaccademico = '2005/2006'
            AND IE.modulo < '0'
      GROUP BY P.ID
);

DROP VIEW IF EXISTS PROFMODULI CASCADE;
CREATE TEMP VIEW PROFMODULI AS
(
      SELECT P.NOME,P.ID,P.cognome, COUNT(IE.nomemodulo)
      FROM DOCENZA D
      JOIN PERSONA AS P ON P.ID = D.id_persona
      JOIN INSEROGATO AS IE ON IE.ID = D.id_inserogato
      WHERE IE.annoaccademico = '2005/2006'
            AND IE.modulo > '0'
      GROUP BY P.ID
);

DROP VIEW IF EXISTS PROF CASCADE;
CREATE TEMP VIEW PROF AS
(
      SELECT P.NOME, P.ID, P.cognome, COUNT(P.ID)
      FROM DOCENZA D
      JOIN PERSONA AS P ON P.ID = D.id_persona
      JOIN INSEROGATO AS IE ON IE.ID = D.id_inserogato
      WHERE IE.annoaccademico = '2005/2006'
            AND (IE.modulo < '0'
            OR IE.hamoduli = '0')
      GROUP BY P.ID
);

SELECT *
FROM PROFINSEGN

UNION

SELECT *
FROM PROFUNITA

UNION

SELECT *
FROM PROFMODULI

UNION

SELECT *
FROM PROF;

      
