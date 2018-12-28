---------------------------- ESERCIZO 1 ---------------------------------------------------------------
-- Trovare nome, cognome dei docenti che nell’anno accademico 2010/2011 hanno tenuto lezioni in almeno
-- due corsi di studio (vale a dire hanno tenuto almeno due insegnamenti o moduli A e B dove A è del corso
-- C1 e B è del corso C2 dove C1 != C2).
SELECT P.id, P.nome, P.cognome
FROM Persona P
WHERE P.id IN (SELECT D.id_persona
               FROM Docenza D
               JOIN inserogato IE on D.id_inserogato = IE.id
               JOIN insegn I on I.id = IE.id_insegn
               WHERE IE.annoaccademico = '2010/2011'
               GROUP BY D.id_persona
               HAVING COUNT(distinct I.nomeins) > 1)
ORDER BY P.id

-- VALIDA ALTERNATIVA ESERICIZO 1
/*
SELECT P.id, P.nome, P.cognome
FROM Persona P
WHERE EXISTS (SELECT 1
               FROM Docenza D
               JOIN inserogato IE on D.id_inserogato = IE.id
               JOIN insegn I on I.id = IE.id_insegn
               WHERE IE.annoaccademico = '2010/2011'
               AND D.id_persona = P.id
               GROUP BY D.id_persona
               HAVING COUNT(distinct I.nomeins) > 1)
ORDER BY P.id
*/

