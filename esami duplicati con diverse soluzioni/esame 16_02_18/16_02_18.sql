create domain tipoconvegno as varchar
    check(values in('seminario','simposio','conferenza'));

create table convegno
(
    nome varchar primary key,
    datainizio date not null,
    datafine date not null,
    numerosessione integer not null
        check(numerosessione > 0),
    tipo tipoconvegno not null,
    luogo varchar not null
    check(datafine > datainizio)
);


create table intervento
(
    id integer primary key
        check(id > 0),
    titolo varchar not null,
    relatore varchar not null,
    durata interval not null
        check(durata > '00:00:00'::interval)
);

create table sessione
(
    nome varchar,
    nomeconvegno varchar references convegno(nome),
    data date not null,
    orarioinizio timestamp with time zone not null,
    orariofine timestamp with time zone not null,
    primary key(nome,nomeconvegno),
    check(orariofine > orarioinizio)
);

create table intervento_in_convegno
(
    nomeconvegno varchar,
    idintervento integer references intervento(id),
    nomesessione varchar,
    orarioinizio timestamp with time zone not null,
    primary key(nomeconvegno,idintervento,nomesessione),
    foreign key(nomeconvegno,nomesessione)
        references sessione(nome,nomeconvegno)
);

--ESERCIZIO2
select i.titolo,i.relatore,s.*,ic.orarioinizio,s.data
from intervento_in_convegno ic
     join intervento i on i.id = ic.idintervento
     join sessione s on s.nome = ic.nomesessione
     and ic.nomeconvegno = s.nome
where ic.nomeconvegno ilike 'X'
order by(s.data,ic.orarioinizio);


--ESERCIZIO4
create temp view conteggio(convegno,giorno,totinterventi,duratatotale) as
(
    select ic.nomeconvegno,s.data,count(*),sum(i.durata)
    from intervento_in_convegno ic
         join sessione s on s.nome = ic.nomesessione
         and s.nomeconvegno = ic.nomeconvegno
         join intervento i on i.id = ic.idintervento
    group by(ic.nomeconvegno,s.data) 
);

select nomeconvegno,giorno,totinterventi,duratatotale
from conteggio;


select c.nomeconvegno,c.giorno,c.totinterventi,c.duratatotale
from conteggio c
group by(c.nomeconvegno,c.giorno,c.totinterventi,c.duratatotale)
having count(distinct(c.giorno)) >=3;

