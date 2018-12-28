CREATE DOMAIN giorniSettimana AS CHAR(3)
    CHECK(VALUE IN('lunedi','martedi','mercoledi','giovedi','venerdi','sabato','domenica')
);
--ESERCIZIO 1
CREATE TABLE Museo ( 
    nome VARCHAR(30) DEFAULT 'MuseoVeronese',
    citta VARCHAR(20) DEFAULT 'Verona',
    PRIMARY KEY(nome,citta), -- coppia di chiavi
    indirizzo VARCHAR, -- si adatta alla lunghezza dell'indirizzo 
    numeroTelefono VARCHAR(13) NOT NULL CHECK (numeroTelefono SIMILAR TO '\+?[0-9]+'),
    giornoChiusura giorniSettimana,
    prezzo NUMERIC(5,2) NOT NULL DEFAULT 10.00  --EQUIVALENTI ANCHE CON DECIMAL
);

CREATE TABLE Mostra (
    titolo VARCHAR(30), --NON NECESSARIO IL NOT NULL
    inizio DATE NOT NULL,
    PRIMARY KEY(titolo,inizio),
    fine DATE NOT NULL,
    museo VARCHAR(30),
    citta VARCHAR (20),
        FOREIGN KEY(museo,citta) 
            REFERENCES Museo(nome,citta) --È SUPERFLUO METTERE (nome,citta) PERCHÈ MUSEO È GIA CHIAVE 
            ON UPDATE SET DEFAULT ON DELETE SET DEFAULT,
    prezzo NUMERIC(5,2)
);

CREATE TABLE Opera(
    nome VARCHAR(30),
    cognomeAutore VARCHAR(20),
    nomeAutore VARCHAR(20),
    PRIMARY KEY(nome,cognomeAutore,nomeAutore),
    museo VARCHAR(30),
    citta VARCHAR(20),
        FOREIGN KEY (museo,citta)
            REFERENCES Museo(nome,citta) 
            ON UPDATE CASCADE ON DELETE SET NULL,
    epoca VARCHAR,
    anno VARCHAR(10)
);

CREATE TABLE Orario(
    progressivo INTEGER PRIMARY KEY,
    museo VARCHAR(30),
    citta VARCHAR(20),
        FOREIGN KEY(museo,citta)
            REFERENCES Museo(nome,citta) 
            ON UPDATE CASCADE ON DELETE CASCADE,
    giorno giorniSettimana,
    orarioApertura TIME WITH TIME ZONE DEFAULT '09:00 CET',
    orarioChiusura TIME WITH TIME ZONE DEFAULT '19:00 CET'
);
---------------------------------------------------------------------------------
--ESERCIZIO 2
INSERT INTO Museo (nome,citta,indirizzo, numeroTelefono,giornoChiusura,prezzo)  
       VALUES ('Arena','Verona','piazza Bra','045 8003204', 'martedi',20); --SE VOGLIO USARE IL DEFAULT CHIUDO LA PARENTESI TONDA PRIMA 
                                                                           --DI INSERIRE IL VALORE -> PRENDE O NULL OPPURE DEFAULT

INSERT INTO Museo(nome,citta,indirizzo, numeroTelefono,giornoChiusura,prezzo) 
       VALUES ('CastelVecchio', 'Verona', 'Corso CastelVecchio','045 594734','lunedi',15)
-- ESERCIZIO 3
INSERT INTO Opera(nome,cognomeAutore,nomeAutore,museo,citta,epoca,anno)
       VALUES('Contesa tr','tintoretto','Jacopo','CastelVecchio','Verona','Riconoscimento','1545 circa'),
             ('Palo alto','Caliari','Paolo','CastelVecchio','Verona','Rinascimento','1548 circa'),
             ('Episodi della vita','tieplo','gianbattista','CastelVecchio','Verona','Neoclassicismo','1725-25');
INSERT INTO Mostra(titolo,inizio,fine,museo,citta,prezzo)
       VALUES('Il sengo di cristo','25-11-2017','25-02-2018','CastelVecchio','Verona',9),
             ('Il conflitto','13-10-2018','07-01-2018','CastelVecchio','Verona',3),
             ('Mostra di leo','23-01-1996','25-02-2016','CastelVecchio','Verona',4);
-- ESERCIZIO 4
--ATTRIBUTO PREZZO SBAGLIATO. PRECISIONE SBAGLIATA
INSERT INTO Museo(nome,citta,indirizzo, numeroTelefono,giornoChiusura,prezzo) 
       VALUES ('CastelVecchio', 'Verona', 'Corso CastelVecchio','045 594734','lunedi',1000.0009)
--------------------------------------------------------------------------------------------------------
-- ESERCIZIO 5
--ALTER TABLE su museo
ALTER TABLE Museo ADD COLUMN sitoInternet VARCHAR NOT NULL DEFAULT 'http://www.google.it'
--UPDATE 
UPDATE museo 
    SET sitoInternet = 'http://www.castelvecchio.it'
    WHERE nome = 'CastelVecchio' AND citta = 'Verona';

--UPDATE
UPDATE museo 
    SET sitoInternet = 'http://www.arena.it'
    WHERE nome = 'Arena' AND citta = 'Verona';
--------------------------------------------------------------------------------------------------------
-- ESERCIZIO 6
--MODIFICA MOSTRA
ALTER TABLE mostra RENAME COLUMN prezzo to prezzoIntero; --COLUMN ANCHE OMESSA
--AGGIUNGERE PREZZORIDOTTO CON VALORE DI DEFAULT
ALTER TABLE Mostra ADD COLUMN prezzoRidotto NUMERIC(4,2) NOT NULL DEFAULT 5;
--VINCOLO DI CHECK SULLA TABELLA
ALTER TABLE Mostra ADD CHECK (prezzoRidotto < prezzoIntero); --QUANDO UN ATTRIBUTO PARLA DI PIÙ PARTI DELLA TABELLA SI PARLA DI CHECK DI TABELLA
                                                             -- VINCOLO DI TABELLA

----------------------------- NON RICHIESTO DALL'ES (MI È TOCCATO)
UPDATE mostra 
    SET prezzoIntero = 10
    WHERE titolo = 'Il conflitto';
-----------------------------
-- ESERCIZIO 7
---ADD PREZZORIDOTTO + 1 solo se prezzoIntero < 15
UPDATE mostra
    SET prezzoRidotto = prezzoRidotto + 1
    WHERE prezzoIntero < 15;

