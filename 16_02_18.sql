--ESERCIZIO1

drop domain if exists convegnotipo;
create domain convegnotipo as varchar
    check(value in('seminario','simposio','conferenza'));

create table convegno
(
    nome varchar primary key,
    datainizio timestamp with time zone not null,
    datafine timestamp with time zone not null
        check(datainizio < datafine),
    numerosessioni integer not null
        check(numerosessioni > 0),
    tipo convegnotipo not null,
    luogo varchar not null
);

create table sessione
(
    nome varchar,
    nomeconvegno varchar references convegno,
    data timestamp with time zone not null,
    orarioinizio time with time zone,
    orariofine time with time zone
        check(orariofine > orarioinizio),
    primary key(nome,nomeconvegno)
);


create table intervento
(
    id integer primary key,
    titolo varchar not null,
    relatore varchar not null,
    durata interval
        check(durata > '00:00'::interval)
);


create table intervento_in_convegno
(
    nomeconvegno varchar,
    idintervento integer references intervento,
    nomesessione varchar,
    orarioinizio time with time zone not null,
    primary key(nomeconvegno,idintervento,nomesessione),
    foreign key (nomesessione,nomeconvegno)
        references sessione(nome,nomeconvegno)
);

drop table convegno,intervento,sessione,intervento_in_convegno;


INSERT INTO CONVEGNO(nome,dataInizio,dataFine,numeroSessioni,tipo,luogo)
    VALUES
        ('Guitar Show','2018-06-08','2018-06-10',3,'conferenza','Padova'),
        ('Polo Zanotto','2018-06-19','2018-06-21',5,'seminario','Verona'),
        ('Tecnologia Industriale','2017-09-16','2018-09-16',27,'simposio','Maragnole');

INSERT INTO INTERVENTO(id,titolo,relatore,durata)
    VALUES
        (1,'Come cambiare le corde','Giovanni Boscaini','01:10:19'::INTERVAL),
        (2,'Come cambiare i pannolini','Cristian SanduCan','00:05:00'::INTERVAL),
        (3,'Come montare una passera','Leonardo Testolin','01:30:00'::INTERVAL);

INSERT INTO SESSIONE(nome,nomeConvegno,data,orarioInizio,orarioFine)
    VALUES
        ('Domanda1','Guitar Show','2010-06-19','11:51:50','11:51:59'),
        ('Domanda2','Tecnologia Industriale','2010-06-19','11:51:50','11:52:00'),
        ('Domande3','Polo Zanotto','2010-06-19','11:51:50','12:10:50');

INSERT INTO INTERVENTO_IN_CONVEGNO(nomeConvegno,idIntervento,nomeSessione,orarioInizio)
    VALUES('Guitar Show',2,'Domanda1','11:51:50');


--ESERCIZIO2
select ic.nomesessione,ic.orarioinizio,i.titolo,i.relatore
from intervento_in_convegno ic
     join intervento i on i.id = ic.idintervento
     join sessione s on s.nome = ic.nomesessione
where ic.nomeconvegno ilike 'Guitar Show'
order by (ic.orarioinizio,s.data);

--ESERCIZIO4
--a)
create temp view conteggio(convegno,sessione,numerotot,duratatot) as
(
    select ic.nomeconvegno,ic.nomesessione,count(i.id),
           sum(i.durata)
    from intervento_in_convegno ic
         join intervento i on i.id = ic.idintervento
         join sessione s on s.nome = ic.nomesessione
         and s.nomeconvegno = ic.nomeconvegno
    group by (ic.nomeconvegno,ic.nomesessione)
);

select c.datainizio, ic.convegno,ic.sessione,
       ic.numerotot,ic.duratatot
from conteggio ic
     join convegno c on c.nome = ic.convegno;

--b)
select ic.numerotot,ic.duratatot,ic.convegno,c.datainizio
from conteggio ic
     join convegno c on c.nome = ic.convegno
group by (c.datainizio,ic.convegno,ic.duratatot,ic.numerotot)
having count(*) >= 3;


--ESERCIZIO5
create index ins_aa on inserogato(annoaccademico,modulo,id_disciminante);
