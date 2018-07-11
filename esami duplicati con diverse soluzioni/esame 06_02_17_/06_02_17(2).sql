--ESERCIZIO1


create table citta
(
    codice varchar(3) primary key,
    nome varchar not null
);


create table cliente
(
    codice varchar primary key,
    nome varchar not null,
    cognome varchar not null,
    ntelefono varchar(11)
        check(ntelefono similar to '+[0-9]{10}'),
    indirizzo varchar not null,
    citta varchar not null references citta(codice)
);

create table tipocontratto
(
    id integer primary key,
    nometipo varchar not null
);

create table contratto
(
    contratto char(10) primary key,
    cliente varchar references cliente(codice),
    tipo integer not null references tipocontratto(id),
    datainizio date not null,
    datafine date,
    check (datafine > datainizio) --vincolo tabella
);

create table telefonata
(
    contratto char(10) references contratto,
    ntelefonochiamato varchar
        check(ntelefonochiamato similar to '+[0-9]{10}'),
    istanteinizio timestamp,
    durata interval not null
        check(durata > '00:00:00'::interval),
    primary key(contratto,ntelefonochiamato,istanteinizio)
);

--ESERCIZIO2
--Trovare il cognome, il nome e l’indirizzo dei clienti di Padova che hanno fatto telefonate ieri (ieri = CURRENT_DATE-
--1) solo in un orario non compreso dalla fascia 10:00–17:00.
--Suggerimento: l’espressione CURRENT_DATE - 1 + TIME '10:00' restituisce il TIMESTAMP che rappresenta ieri
--alle ore 10:00.


select c.nome,c.cognome
from cliente c
     join citta ct on ct.codice = c.citta
     join contratto con on con.cliente = c.codice
     join telefonata t on t.contratto = con.contratto
where ct.nome ilike 'padova'
      and (t.istanteinizio)::date >= CURRENT_DATE -1 
      and (t.istanteinizio)::date < CURRENT_DATE 
      and c.codice not in
      (
          select c1.codice
          from cliente c1
               join citta ct1 on ct1.codice = c1.citta
               join contratto con1 on con1.cliente = c1.codice
               join telefonata t1 on t1.contratto = con1.contratto
          where t1.istanteinizio >= CURRENT_DATE -1 + time '10:00'
          and tq.istanteinizio < CURRENT_DATE -1 + time '17:00'
      );

--ESERCIZIO4

--Trovare per ogni contratto iniziato nel mese di Gennaio 2007 il numero di telefonate e la durata totale
--delle telefonate eseguite nel mese di Maggio 2007 dal cliente del contratto, riportando nel risultato la data
--di inizio del contratto, identificatore del contratto e i conteggi richiesti.

create temp view conteggio(datainizio,contratto,cliente,numerotel,duratatotale) as
(
    select ct.datainizio,ct.contratto,ct.cliente,count(*),sum(t.durata)
    from contratto ct
         join telefonata t on t.contratto = ct.contratto
    where ct.datainizio >= '2007-01-01'
         and (t.istanteinizio >= '2007-05-01 00:00:00'
         and  t.istanteinizio < '2007-06-01 00:00:00')
    group by (ct.contratto,ct.cliente)
);

select datainizio,contratto,numerotel,duratatotale
from conteggio;

--Trovare per ogni contratto il mese in cui ha effettuato il maggior numero di telefonate nell’anno 2016
--riportando il numero di contratto, il mese e il numero di telefonate.


create temp view ok(contratto,numtel) as
(
    select ct.contratto,count(*)
    from contratto ct
         join telefonata t on t.contratto = ct.contratto
    where extract(year from ct.datainizio) = '2016'
    group by (ct.contratto)
)

select extract(month from t.istanteinizio),o.contratto,o.numtel
from contratto ct1
     join ok o on o.contratto = ct1.contratto
     join telefonata t on t.contratto = ct1.contratto
where o.numtel >= ALL
(
    select max(numtel)
    from ok
);