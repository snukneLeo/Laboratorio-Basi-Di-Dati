\encoding UTF8
---------------------------- ESERCIZO 12 ----------------------------
/*
Il primo consiglio è quello di creare una vista temporanea,
in cui mettere id_insegnamento, id_docente, annoaccademico estratti da Docenza, InsErogato, CorsoInFacolta, Facolta e
con opportuni filtri sia per il nome della facoltà che per il modulo dell'insegnamento erogato.
*/

CREATE TEMP VIEW INSEGNAMENTIDOCENTI(id_insegnamento, id_docente, annoaccademico) AS
SELECT I.ID, D.ID, IE.ANNOACCADEMICO
FROM INSEGN I
	JOIN INSEROGATO IE ON IE.ID_INSEGN = I.ID
	JOIN DOCENZA D ON D.ID_INSEROGATO = IE.ID
	JOIN CORSOSTUDI CS ON CS.ID = IE.ID_CORSOSTUDI
	JOIN CORSOINFACOLTA CF ON CF.ID_CORSOSTUDI = CS.ID
	JOIN FACOLTA F ON F.ID = CF.ID_FACOLTA
WHERE F.NOME ILIKE '%SCIENZE%' AND
	IE.MODULO = 0
	
/*
Da qui si procederà con la creazione della query per trovare il nome dell'insegnamento ed il nome/cognome del docente.
Il punto chiave di questa query è nel JOIN tra la vista creata precedentemente e se stessa.
Elaborando correttamente i dati, otterrete 456 righe.
*/

SELECT I.NOMEINS, P.NOME, P.COGNOME
FROM INSEGN I
	JOIN INSEGNAMENTIDOCENTI INDOC ON INDOC.id_insegnamento = I.ID
	JOIN DOCENZA D ON D.ID = INDOC.id_docente
	JOIN PERSONA P ON P.ID = D.ID_PERSONA
	
	-- RAGIONARE CON IL CAST