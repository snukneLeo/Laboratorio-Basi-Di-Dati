--PROVA DEL 16/05/2016
--tipo targa CZ 898NF
CREATE TABLE AUTO
(
    TARGA VARCHAR(7) PRIMARY KEY
        CHECK (TARGA SIMILAR TO '[A-Z]{2}[0-9]{3}[A-Z]{2}'),
    MARCA VARCHAR NOT NULL,
    MODELLO VARCHAR NOT NULL,
    POSTI INTEGER NOT NULL
        CHECK (POSTI >=2),
    CILINDRATA INTEGER NOT NULL
        CHECK (CILINDRATA > 0)
);

CREATE TABLE CLIENTEAUTO
(
    NPATENTE INTEGER PRIMARY KEY,
    COGNOME VARCHAR NOT NULL,
    NOME VARCHAR NOT NULL,
    PAESEPROVENIENZA VARCHAR(30) NOT NULL,
    NINFRAZIONI INTEGER NOT NULL
        CHECK (NINFRAZIONI >= 0)
);

CREATE TABLE NOLEGGIO
(
    TARGA VARCHAR(7) REFERENCES AUTO,
    CLIENTE INTEGER REFERENCES CLIENTEAUTO,
    INIZIO TIME NOT NULL
        CHECK (INIZIO > '00:00:00'::TIME),
    FINE TIME
        CHECK (FINE > INIZIO),
    PRIMARY KEY (TARGA,CLIENTE,INIZIO)
);

INSERT INTO AUTO(targa,marca,modello,posti,cilindrata)
    VALUES('DD789AS','Opel','Astra',5,1560),
          ('FF567OP','Skoda','Octavia',5,1600),
          ('GG781PP','Renault','RipCurl',5,1200);

INSERT INTO CLIENTEAUTO(npatente,cognome,nome,paeseprovenienza,ninfrazioni)
    VALUES(123,'Leonardo','Testolin','Calvene',0),
          (234,'Nico','Testolin','Calvene',0),
          (345,'Giovanni','CapaOnda','Svizzera',1);

INSERT INTO NOLEGGIO(targa,cliente,inizio) --SENZA ORA FINE
    VALUES('FF567OP',123,'12:00:00'),
          ('FF567OP',234,'13:00:01');

INSERT INTO NOLEGGIO(targa,cliente,inizio,fine) --CON ORA FINE
    VALUES('DD789AS',345,'14:00','16:12:09');




INSERT INTO auto (targa, marca, modello, posti, cilindrata)
	VALUES ('BE744FG', 'Ford', 'Ka', 5, 900),
		('CH131TN', 'Ford', 'Focus', 6, 1000),
		('ES500AS', 'KIA', 'Sportage', 6, 1000),
		('JF345DJ', 'Toyota', 'Aygo', 5, 1000),
		('JN456DF', 'Toyota', 'Yaris', 5, 950);

INSERT INTO clienteauto(nPatente, cognome, nome, paeseProvenienza, nInfrazioni)
	VALUES (100, 'Danzi', 'Matteo', 'Italia', 0),
		(180, 'Danzi', 'Nicolo', 'Italia', 0),
		(201, 'Lennon', 'Giovanni', 'Italia', 2),
		(901, 'Jolie', 'Angelina', 'Inghilterra', 1);

INSERT INTO noleggio(targa, cliente, inizio, fine)
	VALUES ('ES500AS', 180, '01:00:00', '05:00:00'),
		('CH131TN', 201, '14:00:00', '20:00:00'),
		('BE744FG', 201, '13:00:00', '18:00:00'),
		('BE744FG', 901, '00:30:00', '05:30:00'),
		('CH131TN', 100, '14:00:00', '19:00:00');

--ESERCIZIO2
select c.nome,c.cognome,c.paeseprovenienza
from clienteauto c
where c.npatente not in
(
    select n.cliente
    from noleggio as n
         join auto as a on a.targa = n.targa
    where a.marca ilike 'Opel'  
);


--ESERCIZIO3
--Trovare per ogni marca d’auto che ha avuto almeno 
--un noleggio: il numero complessivo di auto di quella
--marca, il numero di noleggi in cui è stata utilizzata 
--un’auto di quella marca e il numero complessivo di
--ore di noleggio per le auto di quella marca, riportando 
--la marca e i tre conteggi richiesti.

select distinct(a.marca), count(a.targa) as numeroauto,
       count(n.inizio) as numeroNoleggio,
       --numero ore (.../3600)
       sum(extract(epoch from n.fine - n.inizio)/3600) as oreNoleggio
from auto a 
     join noleggio n on n.targa = a.targa
where n.fine is not null
group by a.marca
having count(*) >=1;


--Trovare la marca con il massimo numero di ore di 
--noleggio visualizzando la marca e il numero di ore di
--noleggio.

create view numeroOre(numore,targa)as
(
    select sum(extract(epoch from n.fine - n.inizio)/3600)as numeroOre,n.targa
    from noleggio n
    group by n.targa
);

select num.targa,num.numore
from numeroOre num
where num.numore >= ALL
(
    select MAX(num1.numore)
    from numeroOre num1
);


--ESERCIZIO4
--Scrivere il codice PostgreSQL che crei uno o più indici 
--che possono migliorare le prestazioni dell’interrogazione
--della seconda domanda giustificando la scelta.

create index indexnoleggio on noleggio(targa);
create index indexauto on auto(targa varchar_pattern_ops);