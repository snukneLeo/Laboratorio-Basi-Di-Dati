--ESERCIZIO1

create table clientevolo
(
    codicefiscale varchar primary key --tstlrd96a23l157i
        check(codicefiscale similar to '[a-zA-Z]{6}[0-9]{2}[a-zA-Z]{1}[0-9]{2}[a-zA-Z]{1}[0-9]{3}[a-zA-Z]{1}'),
    nome varchar not null,
    cognome varchar not null,
    telefono varchar not null
        check(telefono similar to '\+[0-9]{10}'),
    sesso char(1) not null
);

insert into clientevolo(codicefiscale,nome,cognome,telefono,sesso)
    values('TSTLRD96A23L157I','leo','testa','+0182937461','M'),
          ('LOUJKI09D78L180P','lord','testo','+1238172649','F'),
          ('POLAMZ90F17L178M','kevin','smith','+1023191827','M');

create table aeroporto
(
    iata char(4) primary key,
    nome varchar not null,
    citta varchar not null,
    nazione varchar not null
);

insert into aeroporto(iata,nome,citta,nazione)
    values('ABCD','italiaExspress','padova','italia'),
          ('FGHJ','nordAir','Venezia','italia'),
          ('LPOP','emirates','turchia','turchia');

create table volo
(
    iataCompagnia char(2),
    numero integer unique
        check(numero > 0),
    orarioPartenza timestamp with time zone,
    icaoCompagnia char(4) not null,
    partenza char(4) not null references aeroporto,
    destinazione char(4) not null references aeroporto,
    durata interval
        check(durata > '00:00'::interval),
    postiBusiness integer not null
        check(postiBusiness > 0),
    postiEconomy integer not null
        check(postiEconomy > 0),
    postiBusinessComprati integer not null
        check(postiBusinessComprati > 0),
    postiEconomyComprati integer not null
        check(postiEconomyComprati > 0),
    primary key(iataCompagnia,numero,orarioPartenza)
);

insert into volo(iataCompagnia,numero,orarioPartenza,icaoCompagnia,partenza
                ,destinazione,durata,postiBusiness,postiEconomy,
                postiBusinessComprati,postiEconomyComprati)
    values('as',213,'2018-10-09 00:20:10+01','ICAO','ABCD','FGHJ','00:45',120,350,100,120),
          ('ao',109,'2017-10-10 00:12:30+01','IATA','LPOP','ABCD','01:10:00',203,123,10,10);

create table prenotazione
(
    iataCompagnia char(4) references aeroporto,
    numeroVolo integer references volo(numero)
        check(numeroVolo > 0),
    orarioPartenza time,
        check(orarioPartenza > '00:00:00'::time),
    codicefiscale varchar references clientevolo,
    isBusiness boolean not null default 'false',
    primary key(iataCompagnia,numeroVolo,orarioPartenza,codicefiscale)
);

insert into prenotazione(iataCompagnia,numeroVolo,orarioPartenza,codicefiscale,isBusiness)
    values('ABCD',213,'2018-10-09 00:20:10+01','TSTLRD96A23L157I',true),
          ('LPOP',109,'2018-12-09 00:10:10+01','LOUJKI09D78L180P',false);


create table compagnia
(
    icao char(4) primary key,
    iata char(4) not null references aeroporto,
    nome varchar not null,
    nazione varchar not null
);


insert into compagnia(icao,iata,nome,nazione)
    values('ICAO','ABCD','raynaor','venezuela'),
          ('CAIO','FGHJ','superb','germania');


--ESERCIZIO2
create index c2 on inserogato(annoaccademico,id_corsostudi);
create index c1 on corsostudi(id);

--costo pagina prima: 6095.01 (caricamento totale)
--costo pagina secondo: 740.04 (caricamento totale)

--ESERCIZIO4

with psycopg2.connect(database = 'X') as con:
    with con.cursor() as cur:
    cur.execute(
        """
        select v.numerovolo, v.partenza,v.destinazione,count(*) as nmaschi
        from volo v
             join prenotazione p on p.numerovolo = v.numero
             join cliente c on c.codicefiscale = p.codicefiscale
        where v.partenza = %s and v.destinazione = %s
        and v.orarioinizio = %s and c.sesso = %s
        """,('MPX','LGW','2017-10-31 00:00:10+01','M')
    )
    lista = con.fetchAll()
con.close()

--ESERCIZIO5
--Trovare per ogni utente che abbia fatto prenotazioni con 
--almeno due compagnie distinte, il numero di
--voli già effettuati (finiti) all’istante corrente presso 
--ciascuna compagnia e la loro durata totale, sempre per
--ciascuna compagnia. Il risultato deve riportare il codice 
--fiscale dell’utente, il codice ICAO della compagnia
--aerea e i conteggi richiesti.

create temp view conteggio(iata,cf,icao,numerovoli,duratatotale) as
(
    select p.iataCompagnia,p.codicefiscale,v.icaoCompagnia,count(v.numero),sum(v.durata)
    from prenotazione p
         join volo v on v.numero = p.numerovolo
    where v.orarioPartenza <= current_date
    group by (p.iataCompagnia,p.codicefiscale,icaoCompagnia)
);

select c.iata,c.cf,c.icao,c.numerovoli,c.duratatotale
from conteggio c;

--Trovare per ogni compagnia (specificata solo dal suo ICAO), 
--l’utente (gli utenti) con il maggior numero
--di voli e l’utente (gli utenti) che ha (hanno) totalizzato il 
--tempo di volo complessivo maggiore, riportando
--nel risultato: ICAO della compagnia, il codice fiscale dell’utente 
--e i conteggi richiesti (se gli utenti per
--ciascuna compagnia coincidono, si deve stampare solo una riga). 
--Si può non tenere conto se i voli sono
--già stati effettuati o no all’instante corrente.

select distinct(p.codicefiscale),c.iata,c.numerovoli,c.duratatotale
from prenotazione p
     join conteggio c on c.cf = p.codicefiscale
where p.orarioPartenza <= current_date and c.numerovoli >= ALL
(
    select max(numerovoli)
    from conteggio
)

and 

c.duratatotale >= ALL
(
    select max(duratatotale)
    from conteggio
)
group by (p.codicefiscale,c.iata,c.numerovoli,c.duratatotale);


