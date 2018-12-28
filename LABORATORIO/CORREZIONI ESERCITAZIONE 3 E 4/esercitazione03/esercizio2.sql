\encoding UTF8
---------------------------- ESERCIZO 2 ----------------------------
SELECT P.NOME, P.COGNOME, P.TELEFONO
FROM PERSONA P
WHERE P.ID IN(SELECT D.ID_PERSONA
			  FROM DOCENZA D
				JOIN INSEROGATO IE ON IE.ID = D.ID_INSEROGATO
			  WHERE IE.ANNOACCADEMICO = '2009/2010' AND
				IE.MODULO >= 0 AND
				ID_CORSOSTUDI = 4
              EXCEPT
				SELECT D.ID_PERSONA
				FROM DOCENZA D
              		JOIN INSEROGATO IE ON IE.ID = D.ID_INSEROGATO
					JOIN INSEGN  I ON I.ID = IE.ID_INSEGN
									WHERE UPPER(I.NOMEINS) = 'PROGRAMMAZIONE' AND
										IE.ID_CORSOSTUDI = 4)				
ORDER BY P.COGNOME;