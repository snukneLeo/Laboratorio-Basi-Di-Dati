\encoding UTF8
---------------------------- ESERCIZO 4 ----------------------------
-- DA COMPLETARE!!!!!!!!!!!!!!!!!!!!!!!!!!
SELECT PL.ABBREVIAZIONE, PD.DISCRIMINANTE, PD.INIZIO, PD.FINE, COUNT( )
FROM LEZIONE L
    JOIN PERIODOLEZ PL ON PL.ID = L.ID_PERIODOLEZ
    JOIN PERIODODID PD ON PD.ID = PL.ID
WHERE PD.ANNOACCADEMICO = '2010/2011' AND
	(PD.DESCRIZIONE LIKE 'I semestre%' OR
    PD.DESCRIZIONE LIKE 'Primo semestre%')
    
--GROUP BY PL.ABBREVIAZIONE, PD.DISCRIMINANTE, PD.INIZIO, PD.FINE
ORDER BY PD.INIZIO, PD.FINE