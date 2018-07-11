--ESERCIZIO1
DROP TABLE IF EXISTS AUTOSTRADA;
CREATE TABLE AUTOSTRADA
(
    codice varchar(5) primary key
        check (codice similar to 'A[0-9]+'),
    nome varchar unique not null,
    gestore varchar not null,
    lunghezza numeric(6,3) not null
        check (lunghezza > 0::numeric)
);

DROP TABLE IF EXISTS COMUNE;
CREATE TABLE COMUNE
(
    codiceISTAT char(6) primary key
        check(codiceISTAT similar to '[0-9]{6}'),
    nome varchar(40) unique not null,
    numeroAbitanti integer not null
        check (numeroAbitanti > 0),
    superficie numeric
        check(superficie > 0::numeric)
);


DROP TABLE IF EXISTS RAGGIUNGE;
CREATE TABLE RAGGIUNGE
(
    autostrada varchar(5) references autostrada,
    comune char(6) references comune,
    numeroCaselli integer not null
        check(numeroCaselli >= 0),
    primary key(autostrada,comune)
);

INSERT INTO AUTOSTRADA(codice, nome, gestore, lunghezza)
	VALUES ('A1', 'a', '1', 100),
	('A2', 'b', '2', 500),
	('A3', 'c', '3', 510),
	('A4', 'd', '2', 520),
	('A5', 'e', '3', 530),
	('A6', 'f', '1', 550),
	('A7', 'g', '2', 540),
	('A8', 'h', '3', 560),
	('A9', 'u', '3', 570),
	('A10','l', '3', 580);

INSERT INTO COMUNE(codiceIstat, nome, numeroAbitanti, superficie)
	VALUES ('123456', 'Verona', 1200, 1000),
	('123457', 'Vicenza', 1300, 1050),
	('123458', 'Padova', 1400, 1045),
	('123459', 'Bologna', 1500, 4030),
	('123450', 'Venezia', 1600, 1020),
	('123451', 'Molveno', 1700, 100),
	('123452', 'Caldiero', 1800, 1000),
	('123453', 'Viterbo', 1900, 1060),
	('123454', 'Lucca', 1020, 3000);
	
INSERT INTO RAGGIUNGE(autostrada, comune, numeroCaselli)
	VALUES ('A1', '123456', 4),
	('A1', '123454', 2), ('A1', '123452', 4), ('A1', '123453', 6), ('A1', '123451', 2), ('A1', '123450', 1), ('A1', '123457', 2), 
	('A2', '123459', 4), ('A2', '123458', 4), ('A2', '123457', 4), ('A2', '123456', 4),
	('A3', '123452', 4), ('A3', '123451', 4), ('A3', '123454', 4),
	('A4', '123450',1);

--ESERCIZIO2
--Trovare i comuni che non sono raggiunti
--da autostrade gestite dal gestore X, riportando il codice, 
--il nome e gli abitanti del comune.

select c.codiceISTAT,c.nome,c.numeroAbitanti
from comune c
where c.codiceIstat not in
(
    select r.comune
    from raggiunge r
         join autostrada a on a.codice = r.autostrada
    where a.gestore ilike '2'
          and r.numeroCaselli > 0 
);

--ESERCIZIO4

--Trovare per ogni autostrada che raggiunga almeno 10 comuni, 
--il numero totale di comuni che raggiunge e
--il numero totale di caselli, riportando il codice dell’autostrada, 
--la sua lunghezza e i conteggi richiesti.

select a.codice,a.lunghezza, 
       count(*) as nComuni,
       sum(a.lunghezza) as lungAuto
from raggiunge r
     join comune c on c.codiceISTAT = r.comune
     join autostrada a on a.codice = r.autostrada
group by (a.codice,a.lunghezza)
having count(*) >=10;


--Selezionare le autostrade che hanno un potenziale 
--di utenti diretti (=numero di abitanti che la possono
--usare dal loro comune) medio rispetto al numero dei caselli 
--dell’autostrada stessa superiore alla media
--degli utenti per casello di tutte le autostrade. Si deve 
--riportare il codice dell’autostrada, il suo numero
--totale di utenti, la media di utenti per casello.

create temp view utentiPerAutostrada(codA,utentiDiretti,numeroCaselli)as
(
    select a.codice,count(c.numeroAbitanti),sum(r.numeroCaselli)
    from raggiunge r
         join comune c on c.codiceISTAT = r.comune
         join autostrada a on a.codice = r.autostrada
    group by a.codice
);

select upa.codA,upa.utentiDiretti,(upa.utentiDiretti/upa.numeroCaselli) as mediaUtCasello
from utentiPerAutostrada upa
where upa.utentiDiretti/upa.numeroCaselli >= ALL
(
    select avg(upa1.utentiDiretti/upa1.numeroCaselli)
    from utentiPerAutostrada upa1
);

--ESERCIZIO5
--a)Considerando le query della domanda 4, 
--illustrare quali sono gli indici da definire 
--che possono migliorare
--le prestazioni e, quindi, scrivere il codice 
--PostgreSQL che definisce gli indici illustrati. 

--Prima query nessun indice
--seconda query nessun indice

--b)
select *
from raggiunge r
     join comune c on c.codiceIstat = r.comune
where r.autostrada = 'A1';