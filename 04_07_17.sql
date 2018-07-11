--ESERCIZIO1

drop domain numtel,statorisorsa,statoutente;
drop table prestito,risorsa,tipoTab,biblioteca,utente;


create domain statoutente as varchar
    check(value in('abilitato','ammonito','sospeso'));

create domain statorisorsa as varchar
    check(value in('solo consultazione','disponibile','on-line'));

create table utente
(
    codicefiscale varchar primary key --tstlrd96a23l157i
        check(codicefiscale similar to '[a-zA-Z]{6}[0-9]{2}[a-zA-Z]{1}[0-9]{2}[a-zA-Z]{1}[0-9]{3}[a-zA-Z]{1}'),
    nome varchar not null,
    cognome varchar not null,
    telefono varchar not null
        check(telefono similar to '\+[0-9]{10}'),
    dataIscrizione date not null,
    stato statoutente not null
);

insert into utente(codicefiscale,nome,cognome,telefono,dataIscrizione,stato)
    values('TSTLRD96A23L157I','leo','testa','+0182937461','2018-06-10','abilitato'),
          ('LOUJKI09D78L180P','lord','testo','+1238172649','2017-09-20','sospeso'),
          ('POLAMZ90F17L178M','kevin','smith','+1023191827','2016-09-10','ammonito');
create table biblioteca
(
    id integer primary key
);

insert into biblioteca(id)
    values(123),
          (234),
          (345),
          (456);

create table tipoTab
(
    id integer primary key,
    tipo varchar not null
);

insert into tipoTab(id,tipo)
    values(1,'golf'),
          (2,'tennis'),
          (3,'football');

create table risorsa
(
    id integer,
    biblioteca integer references biblioteca,
    titolo varchar(20) not null,
    tipo integer not null references tipoTab,
    stato statorisorsa not null,
    primary key(id,biblioteca)
);

insert into risorsa(id,biblioteca,titolo,tipo,stato)
    values(10,123,'io ne so',2,'disponibile'),
          (11,456,'cosa mangio?',3,'solo consultazione'),
          (12,234,'dormire',1,'on-line');

create table prestito
(
    idrisorsa integer,
    idbiblioteca integer,
    idutente varchar references utente,
    datainizio date,
    durata interval
        check(durata > '00:00'::interval),
    primary key(idrisorsa,idbiblioteca,idutente,datainizio),
    foreign key (idrisorsa, idbiblioteca)
        references RISORSA(id, biblioteca)
);

insert into prestito(idrisorsa,idbiblioteca,idutente,datainizio,durata)
    values(11,456,'TSTLRD96A23L157I','2018-10-21','00:10'),
          (10,123,'POLAMZ90F17L178M','2017-12-10','01:10:00'),
          (12,234,'LOUJKI09D78L180P','2017-01-22','00:25:45');

--ESERCIZIO2
create index i1 on insegn(id);
create index i2 on inserogato(annoaccademico,id_corsostudi);

--UTENTE (codiceFiscale, nome , cognome , telefono , dataIscrizione , stato )
--PRESTITO (idRisorsa, idBiblioteca, idUtente, dataInizio, durata )
--RISORSA (id, biblioteca, titolo , tipo , stato )


--ESERCIZIO4
--Trovare per ogni utente che abbia fatto prestiti presso almeno 
--due biblioteche, il numero di prestiti terminati alla data 
--corrente presso ciascuna biblioteca e la loro 
--durata totale sempre per ciascuna biblioteca.
--Il risultato deve riportare il codice fiscale dell’utente, l’id 
--della biblioteca e i conteggi richiesti.


create temp view contadurata(codice,idbiblio,duratatotale,nprestiti) as
(
    select p.idutente, p.idbiblioteca,sum(p.durata), count(*)
    from prestito p
         join utente u on u.codiceFiscale = p.idutente
    where (p.dataInizio + durata)::date <= CURRENT_DATE --prestito finito
    group by (p.idutente,p.idbiblioteca)
);

select cd.codice,cd.idbiblio,cd.duratatotale,cd.nprestiti
from contadurata cd
where cd.codice in
(
    select idutente
    from prestito
    group by idutente
    having count(*) >=2 --almeno due prestiti
);


--Trovare per ogni biblioteca (specificata solo dal suo id), 
--l’utente/i con il maggior numero di prestiti e
--l’utente/i con la durata complessiva maggiore, riportando nel 
--risultato l’id della biblioteca, il codice fiscale
--dell’utente e i conteggi richiesti (se gli utenti per ciascuna 
--biblioteca coincidono, si deve stampare solo una riga).


select distinct(cd.idbiblio),cd.codice, cd.duratatotale,cd.nprestiti 
from contadurata cd
where cd.nprestiti >= ALL
(
    select max(nprestiti)
    from contadurata cd1
    where cd1.idbiblio = cd.idbiblio
)

or 

cd.duratatotale >= ALL
(
    select max(duratatotale)
    from contadurata cd2
    where cd2.idbiblio = cd.idbiblio
)
group by (cd.idbiblio,cd.codice,cd.duratatotale,cd.nprestiti);


create domain ciao as varchar
    check(value similar to '[0-9]{1}');

create table prova
(
    id integer primary key
        check(id > 0),
    data date not null,
    durata interval not null
        check(durata > '00:00:00'::interval),
    datainizio timestamp not null
);

insert into prova(id,data,durata,datainizio)
    values(1,'2018-07-06','00:10:00','2018-07-06 00:20:10');

select (data+durata)::timestamp, (datainizio+durata)::date
from prova
where datainizio::time = '00:20:10';