--ESERCIZIO1

create domain statoutente as varchar
    check(value in('abilitato','ammonito','sospeso'));

create domain statorisorsa as varchar
    check(value in('solo consultabile','disponibile','on-line'));

create table utente
(
    codicefiscale char(16) primary key
        check(codicefiscale similar to '[a-zA-Z]{6}[0-9]{2}[a-zA-Z]{1}[0-9]{2}[a-zA-Z]{1}[0-9]{3}[a-zA-Z]{1}[]'),
    nome varchar not null,
    cognome varchar not null,
    telefono char(11) not null
        check(telefono similar to '\+[0-9]{10}'),
    dataiscrizione date not null,
    stato statoutente not null
);

create table tiporisorsa
(
    id integer primary key,
    tipo varchar not null
);

create table biblioteca
(
    id integer primary key,
    nome varchar not null
);

create table risorsa
(
    id integer,
    biblioteca integer references biblioteca(id),
    titolo varchar not null,
    tipo integer not null references tiporisorsa(id),
    stato statorisorsa not null,
    primary key(id,biblioteca)
);

create table prestito
(
    idRisorsa integer,
    idBiblioteca integer,
    idUtente char(16) references utente(codicefiscale),
    dataInizio date,
    durata interval not null
        check(durata > '00:00:00'::interval), --cast
    primary key(idRisorsa,idBiblioteca,idUtente,dataInizio),
    foreign key(idRisorsa,idBiblioteca) 
        references risorsa(id,biblioteca)
);



drop table prestito,risorsa,biblioteca,tiporisorsa,utente;


--ESERCIZIO2
create index i1 on insegn(id);
create index i2 on inserogato(annoaccademico,id_corsostudi);

--guadagno --> si passa da 6428.47 a 359.43



--ESERCIZIO4
--Trovare per ogni utente che abbia fatto prestiti presso almeno due biblioteche, il numero di prestiti ter-
--minati alla data corrente presso ciascuna biblioteca e la loro durata totale sempre per ciascuna biblioteca.
--Il risultato deve riportare il codice fiscale dell’utente, l’id della biblioteca e i conteggi richiesti
--a)
create temp view conteggio(utente,biblio,numprestiti,duratatotale) as
(
    select p.idUtente,p.idBiblioteca,count(*),sum(durata)
    from prestito p
    where (dataInizio + durata)::date < current_date
    group by (p.idUtente,p.idBiblioteca)
);

select c.utente,c.biblio,c.numprestiti,c.duratatotale
from conteggio c
where c.utente in
(
    select p.idUtente
    from prestito p
    group by (p.idUtente)
    having count(*) >=2
);

--b)
--Trovare per ogni biblioteca (specificata solo dal suo id), l’utente/i con il maggior numero di prestiti e
--l’utente/i con la durata complessiva maggiore, riportando nel risultato l’id della biblioteca, il codice fiscale
--dell’utente e i conteggi richiesti (se gli utenti per ciascuna biblioteca coincidono, si deve stampare solo una
--riga).

select distinct(c.utente),c.biblio,c.numprestiti,c.duratatotale
from conteggio c
where  c.numprestiti >= ALL
(
    select max(numprestiti)
    from conteggio
    where c.biblio = biblio
)

or c.duratatotale >= ALL
(
    select max(duratatotale)
    from conteggio
    where c.biblio = biblio
)
group by (c.biblio,c.utente,c.numprestiti,c.duratatotale);
