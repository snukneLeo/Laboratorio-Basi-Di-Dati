--ESERCIZIO1
DROP TABLE IF EXISTS OSPEDALE;
CREATE TABLE OSPEDALE
(
    ID INTEGER PRIMARY KEY,
    NOME VARCHAR NOT NULL
);

DROP TABLE IF EXISTS DIVISIONE;
CREATE TABLE DIVISIONE
(
    ID INTEGER PRIMARY KEY,
    IDOSPEDALE INTEGER NOT NULL REFERENCES OSPEDALE,
    NOME VARCHAR(40) NOT NULL,
    NUMEROADDETTI INTEGER NOT NULL
        CHECK (NUMEROADDETTI > 0)
);

--CREATE TABLE REGIONE
--(
--    NOME CHAR(3) PRIMARY KEY
--);
DROP TABLE IF EXISTS PAZIENTE;
CREATE TABLE PAZIENTE
(
    CODICEFISCALE VARCHAR(16) PRIMARY KEY
        CHECK(CODICEFISCALE SIMILAR TO '[a-zA-Z]{6}[0-9]{2}[a-zA-Z]{1}[0-9]{2}[a-zA-Z]{1}[0-9]{3}[a-zA-Z]{1}'),
    NOME VARCHAR NOT NULL,
    COGNOME VARCHAR NOT NULL,
    REGIONE VARCHAR NOT NULL,
    NAZIONE CHAR(3) NOT NULL --REFERENCES REGIONE
);

DROP TABLE IF EXISTS RICOVERO;
CREATE TABLE RICOVERO
(
    DIVISIONE INTEGER REFERENCES DIVISIONE,
    PAZIENTE VARCHAR(16) REFERENCES PAZIENTE,
    DESCRIZIONE VARCHAR NOT NULL,
    URGENZA BOOLEAN NOT NULL DEFAULT FALSE,
    DATAAMMISSIONE DATE,
    DATADIMISSIONE DATE,
    PRIMARY KEY (DIVISIONE,PAZIENTE,DATAAMMISSIONE,DATADIMISSIONE)
);


INSERT INTO OSPEDALE(id, nome)
	VALUES (10, 'San Raffaele'), 
	(11, 'Policlinico Gemelli'), 
	(12, 'Policlinico Borgo Roma'), 
	(13, 'Ospedale Borgo Venezia'),
	(14, 'Fate Bene Fratelli'), 
	(15, 'Policlinico Borgo Milano'), 
	(16, 'Borgo Trento');

INSERT INTO DIVISIONE(id, idOspedale, nome, numeroAddetti)
	VALUES (01, 10, 'Ginecologia', 17), (02, 10, 'Pneumologia', 15), 
		(03, 16, 'Cardiochirurgia', 20), (04, 13, 'Podologia', 10),
		(05, 14, 'Reumatologia', 17), (06, 15, 'Neurochirurgia', 14), 
		(07, 14, 'Psichiatria', 18), (08, 12, 'Chirurgia Plastica', 10),
		(09, 12, 'Ostetricia', 20), (10, 12, 'Malattie Infettive', 20), 
		(11, 12, 'Ortopedia', 10), (12, 13, 'Pediatria', 19),
		(13, 16, 'Pediatria', 25);



INSERT INTO PAZIENTE (codiceFiscale, nome, cognome, regione, nazione)
	VALUES ('ASDFUN55C15U120G', 'giovanni', 'galli', 'sdead', 'SVI'),
		   ('ASEOIJ34U12Q101R', 'carlo', 'conti', 'Toscana', 'CHE'),
		   ('POKFGJ76P18D405S', 'silvia', 'giacometti', 'svizzasd', 'SVI'),
		   ('POKASD89E12T309N', 'luca', 'coglione', 'Toscana', 'ITA'),
		   ('QWERTY00O10S406F', 'greta', 'figa', 'Piemonte' ,'CHE'),
		   ('MNBVZX99K30H500F', 'giulia', 'roberts', 'Scasod', 'SVI');

INSERT INTO RICOVERO(divisione, paziente, descrizione, urgenza, dataAmmissione, dataDimissione)
	VALUES (03, 'ASDFUN55C15U120G', 'colpo al cuore', true, '2017-08-06', '2017-05-05'),
	(07, 'QWERTY00O10S406F', 'impazzita', false, '2017-06-11', '2017-09-12'),
	(08, 'MNBVZX99K30H500F', 'rifacimento del naso', false, '2017-06-06', '2017-06-07'),
	(02, 'ASEOIJ34U12Q101R', 'bronco polmonite', true, '2017-06-06', '2017-07-07'),
	(03, 'POKASD89E12T309N', 'cuore di pietra', true, '2017-06-19', '2017-09-09'),
	(11, 'POKFGJ76P18D405S', 'appendicite', false, '2017-03-11', '2017-03-15'),
	(03, 'QWERTY00O10S406F', 'piede a banana', false, '2017-03-19', '2017-03-21');

--ESERCIZIO2
--Scrivere il codice PostgreSQL per 
--trovare tutti gli identificatori e 
--i nomi degli ospedali dove sono stati ricoverati
--almeno una volta pazienti nati in ’Svizzera’.


select o.id, o.nome
from Ospedale o
     join divisione d on o.id = d.idOspedale
     join ricovero r on r.divisione = d.id
     join paziente p on p.codiceFiscale = r.paziente
where p.nazione ilike 'svi'
group by (o.id,o.nome)
having count(*) >=1

--Trovare il nome delle regioni aventi pazienti 
--ricoverati che non hanno mai avuto ricoveri nella Divisione
--di ’Cardiochirurgia’ dell’ospedale ’Borgo Trento’.

--ESERCIZIO3
select p.regione
from paziente p
where p.codiceFiscale NOT IN
(
	select r.paziente
	from ricovero r
		 join divisione d on d.id = r.divisione
		 join Ospedale o on o.id = d.idOspedale
	where d.nome ilike 'Cardiologia' 
		  and o.nome ilike 'Borgo Trento'
);


--Si considerino solo due divisioni, quella ’Cardiologia’ 
--e quella di ’Cardiochirurgia’ dell’ospedale ’Borgo
--Trento’. Trovare le regioni con il numero di ricoveri 
--non urgenti presso le due divisioni numericamente
--maggiore dei ricoveri urgenti sempre nelle due divisioni e 
--relativi sempre alla stessa regione. Nel risultato
--si riporti il nome della regione, il numero di ricoveri non 
--urgenti e la loro durata media.

create view numeroRicoveriNonUrgenti(numRicnoUrg,regione1)as
(
	select count(*),p.regione
	from ricovero r
		 join divisione d on d.id = r.divisione
		 join paziente p on p.codiceFiscale = r.paziente
		 join ospedale o on o.id = d.idOspedale
	where d.nome in ('Cardiologia','Cardiochirurgia')
		  and o.nome ilike 'Borgo trento'
		  and r.urgenza = false
	group by p.regione
);

create view numeroRicoveriUrgenti(numRicUrg,regione2)as
(
	select count(*),p.regione
	from ricovero r
		 join divisione d on d.id = r.divisione
		 join paziente p on p.codiceFiscale = r.paziente
		 join ospedale o on o.id = d.idOspedale
	where d.nome in ('Cardiologia','Cardiochirurgia')
		  and o.nome ilike 'Borgo trento'
		  and r.urgenza = true
	group by p.regione
);


select nu.numRicnoUrg,nu.regione1
from numeroRicoveriNonUrgenti nu
where nu.numRicnoUrg > ALL
(
	select u.numRicUrg
	from numeroRicoveriUrgenti u
	where u.regione2 = nu.regione1 
);