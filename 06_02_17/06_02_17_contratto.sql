--ESERCIZIO1
drop table if exists citta;
create table citta
(
    codice char(2) primary key,
    nome varchar not null
);

create domain numero_telefono as varchar(10)
	check (value similar to '[0-9]{9,10}');

create table cliente
(
    codice integer primary key,
    nome varchar not null,
    cognome varchar not null,
    nTelefono numero_telefono not null,
    indirizzo varchar(30) not null,
    citta char(2) not null references citta
);

create table tipocontratto
(
    id integer primary key,
    tipo varchar not null
);

create table contratto
(
    contratto integer primary key,
    cliente integer not null references cliente,
    tipo integer not null references tipocontratto,
    dataInizio date not null,
    dataFine date
        check(dataFine > dataInizio)
);

create table telefonata
(
    contratto integer references contratto,
    nTelchiamato numero_telefono not null,
    istanteInizio timestamp not null,
    durata interval not null
        check(durata > '00:00:00'::interval),
    primary key(contratto,nTelchiamato,istanteInizio)
);


insert into tipoContratto (id,tipo) values (1,'privato'),(2,'business'),(3,'corporate');


insert into CITTA(codice, nome) values ('PD', 'Padova'), ('VR', 'Verona'), ('VI', 'Vicenza');
insert into CLIENTE(codice, nome, cognome, nTelefono, indirizzo, citta) 
			values(123, 'Mario', 'Rossi', '3886491850', 'via delle Passere', 'PD'),
					(234, 'Bianchi', 'Francesco', '3473478795', 'vicolo Cieco', 'VR'),
					(345, 'Gino', 'DellaValle', '3886710619', 'via Masaglie', 'VI');

insert into contratto(contratto,cliente,tipo,dataInizio,dataFine)
           values(444,123,1,'2018-08-10','2018-09-21'),
                 (789,345,3,'2017-08-10','2018-09-20'),
                 (090,234,1,'2017-10-10','2019-09-21');
insert into contratto(contratto,cliente,tipo,dataInizio)
           values(190,234,3,'2018-08-10');

insert into telefonata(contratto,nTelchiamato,istanteInizio,durata)
            values(090,'0445860209','2018-09-10 00:10:00','12:00'),
                  (444,'0918325678','2012-09-10 01:10:00','00:10'),
                  (789,'1230981958','2015-09-10 00:10:00','60:00');

--ESERCIZIO2
--Trovare il cognome, il nome e l’indirizzo dei clienti di 
--Padova che hanno fatto telefonate ieri (ieri = CURRENT_DATE-
--1) solo in un orario non compreso dalla fascia 10:00–17:00.
--Suggerimento: l’espressione CURRENT_DATE - 1 + TIME '10:00' 
--restituisce il TIMESTAMP che rappresenta ieri alle ore 10:00.

select c.nome,c.cognome,c.indirizzo
from telefonata t
     join contratto ct on ct.contratto = t.contratto
     join cliente c on c.codice = ct.cliente
     join citta ci on ci.codice = c.citta
where c.nome ilike 'padova'
      and t.istanteInizio >= CURRENT_DATE -1
      and t.istanteInizio < CURRENT_DATE

except 

select c.nome,c.cognome,c.indirizzo
from telefonata t
     join contratto ct on ct.contratto = t.contratto
     join cliente c on c.codice = ct.cliente
     join citta ci on ci.codice = c.citta
where c.nome ilike 'padova'
      and t.istanteInizio >= CURRENT_DATE -1 + time '10:00'
      and t.istanteInizio <= CURRENT_DATE + time '17:00';

