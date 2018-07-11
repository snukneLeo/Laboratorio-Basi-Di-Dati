--ESERCIZIO

create domain IATAAeroporto as varchar(4)
    check(value similar to('[a-Z]{1}[0-9]{2,3}'));

create domain IATACompagnia as char(2)
    check(value similar to('[a-Z]{1}[0-9]{1}'));

create domain ICAOCompagnia as char(4)
    check(value similar to('[a-Z]{1}[0-9]{3}'));

create table utente
(
    coficefiscale char(16) primary key
        check(codicefiscale similar to '[A-Z]{6}[0-9]{2}[A-Z]{1}[0-9]{2}[A-Z]{1}[0-9]{3}[A-Z]{1}'),
    nome varchar not null,
    cognome varchar not null,
    telefono char(11)
        check(telefono similar to '\+[0-9]{10}'),
    sesso char(1) not null
        check(sesso in ('M','F'))
);

create table aeroporto
(
    iata IATAAeroporto primary key,
    nome varchar not null,
    citta varchar not null,
    nazione varchar not null
);

create table compagnia
(
    icao ICAOCompagnia primary key,
    iata IATACompagnia not null,
    nome varchar not null,
    nazione varchar not null
);

create table volo
(
    iataCompagnia IATACompagnia, --refererences compagnia(iata)
    numero integer
        check (numero > 0),
    orarioPartenza timestamp with time zone,
    icaocompagnia ICAOCompagnia not null, --refererences compagnia(icao)
    partenza IATAAeroporto not null references aeroporto, --punta a un aeroporto diverso
    destinazione IATAAeroporto not null references aeroporto, --punta a un aeroporto diverso
    durata interval
        check(durata > '00:00:00'::interval),
    postiBusiness integer not null
        check(postiBusiness >= 0),
    postiEconomy integer not null
        check(postiEconomy >= 0),
    postiBusinessComparati integer not null
        check(postiBusinessComparati >= 0 and postiBusinessComparati <= postiBusiness),
    postiEconomyComprati integer not null
        check(postiEconomyComprati >=0 and postiEconomyComprati <= postiEconomy)
    primary key(iataCompagnia,numero,orarioPartenza),
    foreign key(iataCompagnia,icaocompagnia)
        references compagnia(iata,icao)
);

create table prenotazione
(
    iataCompagnia IATACompagnia,
    numerovolo integer,
    orarioPartenza timestamp with time zone,
    codicefiscale char(16) references cliente,
    idBusiness boolean not null,
    primary key(iataCompagnia,numerovolo,orarioPartenza,codicefiscale),
    foreign key(iataCompagnia,numerovolo,orarioPartenza)
        references volo(iataCompagnia,numero,orarioPartenza)
);

--ESERCIZIO2
create index c1 on corsostudi(id);
create index c2 on inserogato(annoaccademico,id_corsostudi);

--guadagno 6095.01 --> 740.04


--ESERCIZIO4
--Scrivere in PostgreSQL l’interrogazione che determina, per ciascun volo dall’aeroporto di MPX all’aeroporto
--di LGW nel giorno 31 ottobre 2017 (nel fuso orario dell’Europa Centrale), il numero di clienti maschi già
--prenotati. Il risultato deve mostrare la chiave del volo, i codici dei due aeroporti e il conteggio richiesto.


select v.iataCompagnia,v.numero,v.orarioPartenza, count(*) as numeroclientimaschi
from volo v
     join prenotazione p on p.orarioPartenza = v.orarioPartenza
     and p.numerovolo = v.numero
     join cliente c on c.codicefiscale = p.coficefiscale
where c.sesso ilike 'M'
     and v.partenza ilike 'MPX'
     and v.destinazione ilike 'LGW'
     and v.orarioPartenza >= '2017-10-31 00:00:00+01'
     and v.orarioPartenza < '2017-11-01 00:00:00+01'
group by(v.iataCompagnia,v-numerovolo,v-orarioPartenza);


--ESERCIZIO5
--a)
--Trovare per ogni utente che abbia fatto prenotazioni con almeno due compagnie distinte, il numero di
--voli già effettuati (finiti) all’istante corrente presso ciascuna compagnia e la loro durata totale, sempre per
--ciascuna compagnia. Il risultato deve riportare il codice fiscale dell’utente, il codice ICAO della compagnia
--aerea e i conteggi richiesti.

create temp view conteggio(utente,compagnia,numerovoli,duratatotale) as
(
    select p.codicefiscale,v.icaoCompagnia,count(*),sum(durata)
    from volo v
         join prenotazione p on p.numero = v.numerovolo
         and p.orarioPartenza = v.orarioPartenza
    where (p.orarioPartenza+durata)::timestamp < current_timestamp
    group by (p.codicefiscale,v.iataCompagnia)
);


select c.utente,c.compagnia,c.numerovoli,c.duratatotale 
from conteggio c
where c.utente in
(
    select p.codicefiscale
    from prenotazione p
         join volo v on v.numero = p.numerovolo
         and v.orarioPartenza = p.orarioPartenza
    where v.icaoCompagnia <> c.compagnia --ci sono già due prenotazioni se ho compagnie diverse
)
group by(c.utente,c.compagnia,c.numerovoli,c.duratatotale);


--(b) 
--Trovare per ogni compagnia (specificata solo dal suo ICAO), l’utente (gli utenti) con il maggior numero
--di voli e l’utente (gli utenti) che ha (hanno) totalizzato il tempo di volo complessivo maggiore, riportando
--nel risultato: ICAO della compagnia, il codice fiscale dell’utente e i conteggi richiesti (se gli utenti per
--ciascuna compagnia coincidono, si deve stampare solo una riga). Si può non tenere conto se i voli sono
--già stati effettuati o no all’instante corrente.


select distinct(c.utente), c.compagnia,c.numerovoli,c.duratatotale 
from conteggio c
where c.numerovoli >= ALL
(
    select max(numerovoli)
    from conteggio
)

or 

c.duratatotale >= ALL
(
    select mx(duratatotale)
    from conteggio
)
group by(c.utente,c.compagnia,c.numerovoli,c.duratatotale);
