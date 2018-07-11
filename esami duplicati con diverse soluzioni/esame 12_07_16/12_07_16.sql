--ESERCIZIO1
create table paziente
(
    codicefiscale varchar(16) primary key
        check(codicefiscale similar to '[A-Z]{6}[0-9]{2}[A-Z]{1}[0-9]{2}[A-Z]{1}[0-9]{3}[A-Z]{1}'),
    nome varchar not null,
    cognome varchar not null,
    regione varchar not null,
    nazione char(3) not null
);

create table ospedale
(
    id integer primary key
        check(id > 0),
    nome varchar not null
);

create table divisione
(
    id integer primary key
        check(id >0),
    idospedale integer not null references ospedale(id),
    nome varchar not null,
    numeroaddetti integer not null
        check(numeroaddetti > 0)
);

create table ricovero
(
    divisione integer references divisione(id),
    paziente varchar references paziente(codicefiscale),
    descrizione varchar not null,
    urgenza boolean not null default 'false',
    dataammissione date,
    datadimissione date,
    primary key(divisione,paziente,dataammissione,datadimissione)
);


--ESERCIZIO2
--Scrivere il codice PostgreSQL per trovare tutti gli identificatori e i nomi degli ospedali dove sono stati ricoverati
--almeno una volta pazienti nati in ’Svizzera’.

select o.id,o.nome
from ricovero r
     join paziente p on p.codicefiscale = r.paziente
     join divisione d on d.id = r.divisione
     join ospedale o on o.id = d.idospedale
where p.nazione ilike 'svizzera'
group by(o.id,o.nome)
having count(*) >= 1;


--ESERCIZIO3
--Trovare il nome delle regioni aventi pazienti ricoverati che non hanno mai avuto ricoveri nella Divisione
--di ’Cardiochirurgia’ dell’ospedale ’Borgo Trento’

select p.regione
from paziente p
where p.codicefiscale not in
(
    select p1.codicefiscale
    from divisione d
         join ricovero r on r.divisione = d.id
         join paziente p1 on p1.codicefiscale = r.paziente
         join ospedale o on o.id = d.idospedale
    where d.nome ilike 'Cardiochirurgia'
    and o.nome ilike 'Borgo trento'
);

--Si considerino solo due divisioni, quella ’Cardiologia’ e quella di ’Cardiochirurgia’ dell’ospedale ’Borgo
--Trento’. Trovare le regioni con il numero di ricoveri non urgenti presso le due divisioni numericamente
--maggiore dei ricoveri urgenti sempre nelle due divisioni e relativi sempre alla stessa regione. Nel risultato
--si riporti il nome della regione, il numero di ricoveri non urgenti e la loro durata media.

create view ricoverononurgente(regione,numricoverinonurgenti,durata) as
(
    select p.regione,count(*),sum((r.datadimissione-r.dataammissione)::time)
    from ricovero r
         join paziente p on p.codicefiscale = r.paziente
         join divisione d on d.id = r.divisione
    where d.nome in ('cardiologia','cardiochirurgia')
    group by (p.regione)
);

create view ricoveriurgenti(regione,numricoveriurgenti,durata) as 
(
    select p.regione,count(*),sum((r.datadimissione-r.dataammissione)::time)
    from ricovero r
         join divisione d on d.id = r.divisione
         join paziente p on p.codicefiscale = r.paziente
    where d.nome in ('cardiologia','cardiochirurgia')
    group by(p.regione)
);


select rnu.regione,rnu.numricoverinonurgenti,avg(rnu.durata) as durata_media
from ricoverononurgente rnu
where rnu.durata >= ALL
(
    select ru.durata
    from ricoveriurgenti ru
    where rnu.regione = ru.regione -- sempre stessa regione!
);


--ESERCIZIO4
--Considerando le query della domanda 3, illustrare quali sono gli indici da definire che possono migliorare le
--prestazioni e, quindi, scrivere il codice PostgreSQL che definisce gli indici illustrati

create index nomeospedale on ospedale(nome);
create index nomedivisione on divisione(nome);
