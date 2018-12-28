-- Esercizio 1 (839 righe nel risultato corretto)
SELECT DISTINCT P.id, P.nome, P.cognome
FROM Persona AS P
WHERE P.id IN (
	SELECT P1.id
	FROM Persona AS P1 JOIN Docenza AS Docenza AS D
		ON P1.id = D.id_persona
		JOIN InsErogato AS IE
		ON D.id_inserogato = IE.id
	WHERE IE.annoaccademico = '2010/2011'
	GROUP BY P1.id
	HAVING COUNT(DISTINCT IE.id_corsostudi) >= 2
	) 
ORDER BY P.id OFFSET 49
;

-- Esercizio 2 (5 righe nel risultato corretto)
SELECT DISTINCT P.nome, P.cognome, P.telefono
FROM Persona AS P JOIN Docenza AS D
	ON P.id = D.id_persona
	JOIN InsErogato AS IE
		ON D.id_inserogato = IE.id
WHERE IE.annoaccademico = '2009/2010'
	AND IE.id_corsostudi = 4
	AND IE.modulo >= 0 
	AND NOT EXISTS(
		SELECT 1
		FROM Persona AS P1 JOIN Docenza AS D1
			ON P1.id = D1.id_persona
			JOIN InsErogato AS IE1
				ON D1.id_inserogato = IE1.id
		WHERE P1.id = P.id
			AND IE1.nomemodulo ILIKE 'Programmazione'
			AND IE1.id_corsostudi = IE.id_corsostudi
	)
;

-- Esercizio 3 (1031 righe nel risultato corretto)
SELECT DISTINCT P.id, P.nome, P.cognome
FROM Persona AS P JOIN Docenza AS D
	ON P.id = D.id_persona
	JOIN InsErogato AS IE
		ON D.id_inserogato = IE.id
	JOIN Insegn AS I
		ON IE.id_insegn = I.id
WHERE IE.annoaccademico = '2010/2011'
	AND (D.id_persona, I.nomeins) NOT IN (
		SELECT D1.id_persona, I1.nomeins
		FROM InsErogato AS IE1 JOIN Docenza AS D1
			ON D1.id_inserogato = IE1.id
			JOIN Insegn AS I1
				ON IE1.id_insegn = I1.id
		WHERE IE1.annoaccademico = '2009/2010'
		)
ORDER BY P.nome, P.cognome LIMIT 5 OFFSET 19
;

-- Esercizio 4 (3 righe nel risultato corretto)
SELECT DISTINCT PL.abbreviazione, PD.discriminante, PD.inizio, PD.fine, COUNT(*)
FROM PeriodoLez AS PL JOIN PeriodoDid AS PD
	ON PL.id = PD.id
	JOIN InsInPeriodo AS IP
			ON IP.id_periodolez = PD.id
WHERE PD.descrizione SIMILAR TO '(Primo|I) semestre%'
	AND PD.annoaccademico = '2010/2011' 
GROUP BY PL.abbreviazione, PD.discriminante, PD.inizio, PD.fine
ORDER BY PD.inizio, PD.fine
;

-- Esercizio 5
SELECT F.nome, COUNT(IE.hamoduli) AS numeroUnitaLogistiche, SUM(IE.crediti) AS numeroCreditiTotali
FROM Facolta AS F JOIN InsErogato AS IE
	ON F.id = IE.id_facolta
WHERE IE.annoaccademico = '2010/2011'
	AND IE.modulo < 0
GROUP BY F.nome, F.id
;

-- Esercizio 6
SELECT C.nome, COUNT(*)
FROM Inserogato I JOIN Facolta F 
	ON I.id_facolta = F.id
 	JOIN CorsoStudi C 
 		ON I.id_corsostudi = C.id
WHERE F.nome <> 'Medicina e Chirurgia' 
	AND I.annoaccademico = '2010/2011' 
 	AND I.hamoduli = '1'
GROUP BY C.nome
ORDER BY C.nome
;

-- Esercizio 7 
SELECT DISTINCT I.nomeins 
FROM InsErogato AS IE JOIN Insegn AS I 
	ON IE.id_insegn = I.id
WHERE IE.id_corsostudi = 4
	AND IE.id_insegn NOT IN(
		SELECT IE1.id_insegn
		FROM PeriodoLez AS PL JOIN InsInPeriodo IP
			ON IP.id_periodolez = PL.id  
			JOIN InsErogato AS IE1 
				ON IP.id_inserogato = IE1.id
		WHERE (PL.abbreviazione LIKE '2%')
			AND IE1.id_corsostudi = 4
);

-- Esercizio 8
DROP VIEW IF EXISTS OreDocentiFacolta CASCADE;
DROP VIEW IF EXISTS MaxOreDocentiFacolta CASCADE;

CREATE TEMP VIEW OreDocentiFacolta AS (
	SELECT D.id_persona AS idpersona, F.nome AS nomefacolta, SUM(D.orelez) AS sommaore
 	FROM inserogato IE JOIN corsostudi C 
 		ON IE.id_corsostudi =  C.id
   		JOIN corsoinfacolta CF 
   			ON CF.id_corsostudi = C.id
   		JOIN Facolta F 
   			ON CF.id_facolta = F.id
   		JOIN Docenza D 
   			ON D.id_inserogato = IE.id
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
FROM Persona P JOIN OreDocentiFacolta ODF 
	ON P.id = ODF.idpersona
WHERE (ODF.nomefacolta, ODF.sommaore) IN (
 	SELECT *
 	FROM MaxOreDocentiFacolta
);

-- Esercizio 9
SELECT DISTINCT I.nomeins, D.descrizione 
FROM InsErogato AS IE JOIN Insegn AS I
	ON IE.id_insegn = I.id
	JOIN Discriminante AS D
		ON IE.id_discriminante = D.id
	JOIN Docenza AS Doc 
		ON Doc.id_inserogato = IE.id
	JOIN Persona AS P
		ON Doc.id_persona = p.id
WHERE IE.id_corsostudi = 240
	AND IE.annoaccademico = '2009/2010'
	AND (P.nome <> 'Roberto'
	AND P.nome <> 'Alberto'
	AND P.nome <> 'Massimo'
	AND P.nome <> 'Luca')
	AND IE.modulo = '0'
	AND EXISTS (
		SELECT 1
		FROM InsErogato AS IE1 JOIN Insegn AS I1
			ON IE1.id_insegn = I1.id
			JOIN Docenza AS Doc1 
				ON Doc1.id_inserogato = IE1.id
			JOIN Persona AS P1
				ON Doc1.id_persona = P1.id
		WHERE IE1.id_corsostudi = 240
			AND IE1.annoaccademico = '2010/2011'
			AND (P1.nome <> 'Roberto'
			AND P1.nome <> 'Alberto'
			AND P1.nome <> 'Massimo'
			AND P1.nome <> 'Luca')
			AND IE.modulo = '0'
			AND IE1.id_insegn = IE.id_insegn
	)
;

-- Esercizio 10
SELECT DISTINCT INS.nomeins, IE.nomeunita 
FROM inserogato IE JOIN insegn INS 
	ON IE.id_insegn = INS.id 
	JOIN lezione L 
		ON L.id_inserogato = IE.id 
WHERE IE.id_corsostudi = 420 
	AND IE.annoaccademico = '2010/2011' 
	AND IE.modulo < '0' 
	AND (( L.giorno = 2 
		AND NOT EXISTS(
			SELECT 1 
			FROM lezione L1 
			WHERE  L1.id_inserogato = L.id_inserogato 
				AND L.id <> L1.id 
				AND L1.giorno = 3)
		) 
	OR ( L.giorno = 3 
		AND NOT EXISTS(
			SELECT 1 
			FROM lezione L1 
			WHERE  L1.id_inserogato = L.id_inserogato 
				AND L.id <> L1.id 
			AND L1.giorno = 2)
		)
	) 
GROUP BY INS.nomeins, IE.nomeunita
; 

-- Esercizio 11
SELECT CS.nome
FROM CorsoStudi as CS JOIN InsErogato as IE
	ON CS.id = IE.id_corsostudi
WHERE IE.id_insegn NOT IN (
		SELECT Insegn.id
		FROM Insegn
		WHERE Insegn.nomeins ILIKE '%MATEMATICA%'
	)
;

-- Esercizio 12
-- Trovare gli insegnamenti (esclusi moduli e unità logistiche) dei corsi di studi della facoltà di Scienze che sono stati 
-- tenuti dallo stesso docente per due anni accademici consecutivi riportando il nome dell’insegnamento, il nome e il cognome 
-- del docente. (Circa la condizione sull’anno accademico, dopo aver estratto una sua opportuna parte, si può trasformare questa
-- in un intero e, quindi, usarlo per gli opportuni controlli. Quindi, verificare sul manuale di PostgreSQL la funzione stringa
-- opportuna per estrarre la parte che interessa; usare quindi l’istruzione CAST visto a lezione.)
-- La soluzione ha 109 righe.
DROP VIEW IF EXISTS insegnamentiAnnoN CASCADE;
CREATE TEMP VIEW insegnamentiAnnoN AS (
	SELECT I.id, D.id_persona, 
	CAST(SUBSTRING(IE.annoaccademico FROM 1 FOR 4) AS INTEGER) AS annoN
	FROM InsErogato AS IE JOIN Insegn AS I
		ON IE.id_insegn = I.id
		JOIN Docenza AS D
			ON D.id_inserogato = IE.id
	WHERE IE.modulo = 0
	ORDER BY I.id, annoN
);

SELECT DISTINCT I.nomeins, P.nome, P.cognome
FROM InsErogato AS IE JOIN Insegn AS I
		ON IE.id_insegn = I.id
		JOIN Docenza AS D
			ON D.id_inserogato = IE.id
		JOIN Persona AS P
			ON D.id_persona = P.id
		JOIN CorsoStudi AS CS
			ON IE.id_corsostudi = CS.id
		JOIN CorsoInFacolta AS CF
			ON CF.id_corsostudi = CS.id
		JOIN Facolta AS F
			ON CF.id_facolta = F.id
WHERE IE.modulo = 0
	AND F.nome ILIKE 'Scienze Mate%'
	AND (I.id, D.id_persona, (CAST(SUBSTRING(IE.annoaccademico FROM 6 FOR 4) AS INTEGER))) IN (
		SELECT *
		FROM insegnamentiAnnoN AS IAN 
)
;

-- Esercizio 13
SELECT SS.nomestruttura, SS.fax, COUNT(*) AS csserviti
FROM StrutturaServizio SS join CorsoStudi CS
	ON CS.id_segreteria = SS.id
GROUP BY SS.nomestruttura, SS.fax
;

-- Esercizio 14
DROP VIEW IF EXISTS orePerProfessore CASCADE;
CREATE TEMP VIEW orePerProfessore AS (
	SELECT P.id, P.nome, P.cognome, SUM(D.orelez) AS oreProfessore
	FROM Docenza AS D JOIN Persona AS P
		ON D.id_persona = P.id
		JOIN InsErogato AS IE
			ON D.id_inserogato = IE.id
	WHERE D.orelez > 0 
		AND IE.annoaccademico = '2010/2011'
	GROUP BY P.id, P.nome, P.cognome
);

SELECT DISTINCT P.nome, P.cognome
FROM InsErogato AS IE JOIN Docenza AS D
	ON D.id_inserogato = IE.id
	JOIN Persona AS P
		ON D.id_persona = P.id
	JOIN orePerProfessore AS OP
		ON P.id = OP.id
WHERE IE.annoaccademico = '2010/2011'
	AND D.creditilez > 0
	AND OP.oreProfessore > (
			SELECT AVG(orePerProfessore.oreProfessore) 
			FROM orePerProfessore
		)
;  

-- Esercizio 15


















