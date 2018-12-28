--ESERCIZIO 1 (NON SERVE FARE NESSUN TRANSAZIONE)
-- no transazione solo insert
INSERT INTO MUSEO(nome,citta,indirizzo,numerotelefono,giornochiusura,prezzo)
VALUES('Fiera','VERONA','piazza brà',0045601900,'lunedi',10.99);



-- ci sarà errore (la prima transazione fa prima quella e l'altra darà errore)
-- nel caso in cui le due applicazioni agiscono in parallelo 
-- e devono inseriscono lo stesso dato e laprima inserisce 
-- in modo corretto il dato l'altra non riesce perché è già stato
-- inserito


-- ESERCIZIO 2
--arrontondare alle cifre che si vuole
--ROUND(PREZZO * 1.10, 2) -- CIO CHE VOGLIO AUMENTARE , NUMERO DI CIFRE DECIMALI
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT *
FROM MUSEO
WHERE (PREZZO - PREZZO::INTEGER) <> 0 --ALTRO MODO PREZZO <> CEIL(PREZZO)
       AND CITTA ILIKE 'VERONA';

UPDATE MUSEO
SET PREZZO = PREZZO * 1.10
WHERE (PREZZO - PREZZO::INTEGER) <> 0
       AND CITTA ILIKE 'VERONA';
END;


UPDATE MUSEO
SET PREZZO = PREZZO * 1.10
WHERE CITTA ILIKE 'VERONA';


-- non serve per l'es
UPDATE MUSEO
SET PREZZO = 9.55
WHERE PREZZO > 100;


--ESERCIZIO 3
INSERT INTO Mostra(titolo,inizio,fine,museo,citta,prezzointero,prezzoridotto)
       VALUES('Il segno di Andrea','15-08-2017','21-09-2018','CastelVecchio','Verona',40,20);

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT AVG(PREZZOINTERO) AS MEDIAPREZZOINTERI
FROM MOSTRA 
WHERE CITTA ILIKE 'VERONA';

SELECT AVG(PREZZORIDOTTO) AS MEDIAPREZZORIDOTTO
FROM MOSTRA 
WHERE CITTA ILIKE 'VERONA';
END;


--ESERCIZIO 4
UPDATE MOSTRA
SET PREZZOINTERO = PREZZOINTERO * 1.10
WHERE CITTA ILIKE 'VERONA';

UPDATE MOSTRA
SET PREZZORIDOTTO = PREZZORIDOTTO * (5/100);

--ESERCIZIO 5
CREATE TEMP VIEW MEDIAPREZZO AS 
(
    SELECT SUM(PREZZO) AS SOMMAPREZZI, COUNT(*) AS CONTA
    FROM MUSEO
    WHERE CITTA ILIKE 'VICENZA'
);

INSERT INTO Museo(nome,citta,indirizzo, numeroTelefono,giornoChiusura,prezzo) 
SELECT 'Museo moderno', 'Verona', 'Corso Brà' ,'045 763167', 'giovedì', (SOMMAPREZZI/CONTA)
FROM MEDIAPREZZO;