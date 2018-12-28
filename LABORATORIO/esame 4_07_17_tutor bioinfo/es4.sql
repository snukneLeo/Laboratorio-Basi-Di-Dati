CREATE VIEW prestitPerUtente AS 
(
    SELECT P.idUtente as idutente, P.idBiblioteca as idBiblio, COUNT(*) as numPrestiti
    FROM PRESTITO P
    WHERE (p.datainizio + durata)::DATE <= CURRENT_DATE
    GROUP BY(P.idutente, P.idBiblioteca)
);

--- a
SELECT idUtente, idBiblio, conto, durata
FROM rom prestitPerUtente PPU
WHERE (idUtente) IN
(
    SELECT idUtente
    FROM prestitPerUtente
    GROUP BY idUtente
    HAVING COUNT(*) >= 2
);


---b

SELECT idBiblio,idUtente,numPrestiti, durata
FROM prestitPerUtente
WHERE numPrestiti >= ALL
(
    SELECT MAX(p1.numPrestiti)
    FROM prestitPerUtente p1
    WHERE p.idBiblio = p1.idBiblio
)
-- uguale a prima vario con in pero (tanto per cambiare)
OR durata IN
--poteri al posto di OR durata IN usare UNIQUE
(
    SELECT MAX(p1.durata)
    FROM prestitPerUtente p1
    WHERE p.idBiblio = p1.idBiblio
);
--stesso es con unique e variato con ALL
SELECT idBiblio,idUtente,numPrestiti, durata
FROM prestitPerUtente p
WHERE (numPrestiti) IN
(
    SELECT MAX(p1.numPrestiti)
    FROM prestitPerUtente p1
    WHERE p.idBiblio = p1.idBiblio
)
UNIQUE
SELECT idBiblio,idUtente,numPrestiti, durata
FROM prestitPerUtente p 
WHERE (durata) IN
(
    SELECT MAX(p1.durata)
    FROM prestitPerUtente p1
    WHERE p.idBiblio = p1.idBiblio
)



