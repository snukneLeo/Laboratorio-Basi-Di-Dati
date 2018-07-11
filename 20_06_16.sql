--ESERCIZIO1
DROP TABLE IF EXISTS INGREDIENTE;
CREATE TABLE INGREDIENTE
(
    ID INTEGER PRIMARY KEY,
    NOME VARCHAR(30) NOT NULL,
    CALORIE INTEGER NOT NULL 
        CHECK(CALORIE >= 0),
    GRASSI DECIMAL NOT NULL
        CHECK(GRASSI >= 0 AND GRASSI <=100),
    PROTEINE DECIMAL NOT NULL
        CHECK(PROTEINE >= 0 AND PROTEINE <=100),
    CARBOIDRATI DECIMAL NOT NULL
        CHECK(CARBOIDRATI >= 0 AND CARBOIDRATI <= 100)
);

DROP TABLE IF EXISTS RICETTA;
CREATE TABLE RICETTA
(
    ID INTEGER PRIMARY KEY,
    NOME VARCHAR(20) NOT NULL,
    REGIONE VARCHAR NOT NULL,
    PORZIONI INTEGER NOT NULL
        CHECK (PORZIONI >=1),
    TEMPOPREPARAZIONE INTERVAL
        CHECK (TEMPOPREPARAZIONE > '00:00'::INTERVAL)
);

DROP TABLE IF EXISTS COMPOSIZIONE;
CREATE TABLE COMPOSIZIONE
(
    RICETTA INTEGER REFERENCES RICETTA,
    INGREDIENTE INTEGER REFERENCES INGREDIENTE,
    QUANTITA DECIMAL(5,2) NOT NULL
        CHECK (QUANTITA > 0),
    PRIMARY KEY(RICETTA,INGREDIENTE)
);


INSERT INTO INGREDIENTE(id, nome, calorie, grassi, proteine, carboidrati)
	VALUES (1234, 'sale', 0, 12, 13, 30),
		(1235, 'pasta', 40, 20, 80, 50),
		(1236, 'pane', 20, 50, 50, 10),
		(1237, 'pomodoro', 20, 20, 10, 10),
		(1238, 'formaggio', 50, 50, 70, 70),
		(1239, 'cioccolato', 80, 80, 50, 10),
		(1240, 'salame', 60, 60, 60, 60);

INSERT INTO RICETTA(id, nome, regione, porzioni, tempoPreparazione)
	VALUES (1, 'pizza', 'Campania', 4, '1 hour'),
		(2, 'Pane e salame', 'Veneto', 4, '5 minutes'),
		(3, 'pasta al pomodoro', 'Veneto', 2, '20 minutes'),
		(4, 'Salame al cioccolato', 'Veneto', 2, '15 minutes 30 seconds');

INSERT INTO COMPOSIZIONE(ricetta, ingrediente, quantita)
	VALUES(1, 1234, 20),
		(1, 1237, 60),
		(1, 1238, 60),
		(2, 1236, 50),
		(2, 1240, 50),
		(3, 1235, 80),
		(3, 1234, 1),
		(3, 1237, 70),
		(4, 1236, 50),
		(4, 1239, 50);


select r.nome,r.tempoPreparazione,i.carboidrati
from composizione c
     join ricetta r on r.id = c.ricetta
     join ingrediente i on i.id = c.ingrediente
where r.regione ilike 'Veneto'
group by (r.nome,r.tempoPreparazione,i.carboidrati)
having (i.carboidrati) >= (i.carboidrati * (40/100)); --almeno 40%


--ESERCIZIO3
--Trovare per ogni ricetta la quantità totale di proteine 
--e la quantità totale di grassi, riportando anche il
--nome della ricetta.


create temp view quantitaTotali(proteinetotali,grassitotali,ricetta,nomericetta)as
(
    select sum(i.proteine), sum(i.grassi),c.ricetta,r.nome
    from ingrediente i
         join composizione c on c.ingrediente = i.id
         join ricetta r on r.id = c.ricetta
    group by (c.ricetta,r.nome)
);

select qt.proteinetotali,qt.grassitotali,qt.ricetta,qt.nomericetta
from quantitaTotali qt;

--Trovare le ricette che hanno la massima 
--quantità di grassi per porzione, riportando il 
--nome della ricetta e la sua quantità di grasso totale.

select qt.nomericetta,qt.grassitotali,(qt.grassitotali/r.porzioni) as grassiPorzione
from quantitaTotali qt
     join ricetta r on r.id = qt.ricetta
where (qt.grassitotali/r.porzioni) >= ALL
(
    select (qt1.grassitotali/r1.porzioni)
    from quantitaTotali qt1
         join ricetta r1 on r1.id = qt1.ricetta
          and r1.id = qt.ricetta
);

--ESERCIZIO4
create index ricettaIndex on ricetta(regione);
create index ingredienteIndex on ingrediente(carboidrati);


