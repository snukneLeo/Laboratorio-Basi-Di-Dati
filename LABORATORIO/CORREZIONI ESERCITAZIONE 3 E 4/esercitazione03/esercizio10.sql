\encoding UTF8
---------------------------- ESERCIZO 10 ----------------------------
/*
Trovare le unità logistiche del corso di studi con id=420 erogati nel 2010/2011
che hanno lezione o il lunedì (Lezione.giorno=2) o il martedì (Lezione.giorno=3),
ma non in entrambi i giorni, riportando il nomedell’insegnamento e il nome dell’unità ordinate per nome insegnamento.
La soluzione ha 7 righe. Le prime quattro sono:
nomeins | nomeunita
-- ------------------------------+-------------
Algoritmi | Teoria
Architettura degli elaboratori | Teoria
Architettura degli elaboratori | Laboratorio
Basi di dati | Laboratorio
*/
SELECT I.NOMEINS, IE.NOMEUNITA
FROM INSEGN I
	JOIN INSEROGATO IE ON IE.ID_INSEGN = I.ID
    JOIN CORSOSTUDI CS ON CS.ID = IE.ID_CORSOSTUDI
    JOIN LEZIONE L ON L.ID_INSEROGATO = IE.ID
WHERE IE.ANNOACCADEMICO = '2010/2011' AND
	IE.MODULO < 0 AND
	CS.ID = 420 AND
    (L.GIORNO IN (2,3))
    
    EXCEPT 
    
SELECT I.NOMEINS, IE.NOMEUNITA
FROM INSEGN I
	JOIN INSEROGATO IE ON IE.ID_INSEGN = I.ID
    JOIN CORSOSTUDI CS ON CS.ID = IE.ID_CORSOSTUDI
    JOIN LEZIONE L ON L.ID_INSEROGATO = IE.ID
WHERE IE.ANNOACCADEMICO = '2010/2011' AND
	IE.MODULO < 0 AND
	CS.ID = 420 AND
    (L.GIORNO = 2 AND L.GIORNO = 3)
    
ORDER BY 1
	