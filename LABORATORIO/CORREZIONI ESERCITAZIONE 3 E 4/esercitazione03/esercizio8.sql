\encoding UTF8
---------------------------- ESERCIZO 8 ----------------------------
-- CI METTE 45 SECONDI MA FUNZIONA
CREATE TEMP VIEW DOCENTIFACOLTAORE(COGNOME, NOME, FACOLTA, ORE) AS
SELECT P.COGNOME, P.NOME, F.NOME, SUM(D.ORELEZ)
FROM FACOLTA F
	JOIN INSEROGATO IE ON IE.ID_FACOLTA = F.ID
    JOIN DOCENZA D ON D.ID_INSEROGATO = IE.ID
    JOIN PERSONA P ON P.ID = D.ID_PERSONA
WHERE IE.ANNOACCADEMICO= '2009/2010'
GROUP BY P.COGNOME, P.NOME, F.NOME


SELECT P.COGNOME, P.NOME, F.NOME AS FACOLTA, SUM(D.ORELEZ) AS ORETOT
FROM PERSONA P
	JOIN DOCENZA D ON D.ID_PERSONA = P.ID
    JOIN INSEROGATO IE ON IE.ID = D.ID_INSEROGATO
    JOIN FACOLTA F ON F.ID = IE.ID_FACOLTA
WHERE IE.ANNOACCADEMICO = '2009/2010'
GROUP BY P.COGNOME, P.NOME, F.NOME
HAVING SUM(D.ORELEZ) = (SELECT MAX(OF.ORE)
					 FROM DOCENTIFACOLTAORE OF
					 WHERE OF.FACOLTA = F.NOME)
ORDER BY P.COGNOME



