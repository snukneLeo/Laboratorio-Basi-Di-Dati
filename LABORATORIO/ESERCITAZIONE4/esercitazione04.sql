--ESERCIZIO 1

--CREATE INDEX
CREATE INDEX corsoStudiSede ON CORSOSTUDI(sede);
ANALYZE CORSOSTUDI;


EXPLAIN SELECT DISTINCT CS.sede
FROM CORSOSTUDI CS;

--ESERCIZIO 2
explain
select distinct(i.id),i.nomeins,ie.id_facolta
from inserogato ie
     join insegn i on i.id = ie.id_insegn
where ie.annoaccademico = '2013/2014';



--ESERCIZIO3  
explain
create index indec on corsostudi(nome varchar_pattern_ops);

select c.id,c.nome,c.abbreviazione
from corsostudi c
where c.nome ilike '%lingue%';


--ESERCIZIO4 --da verificare ancora
explain
select i.id,ie.nomemodulo
from inserogato ie
     join insegn i on i.id = ie.id_insegn
where ie.annoaccademico = '2010/2011'
      and id_facolta = 7;

create index inserogato(annoaccademico,id_facolta);

--ESERCIZIO5
explain
select d.id, d.descrizione
from inserogato ie
     join discriminante d on d.id = ie.id_discriminante 
where ie.annoaccademico = '2009/2010'
     and ie.hamoduli < '0'
     and ie.crediti in('3','5','12');

create index ie on inserogato(id_discriminante,annoaccademico,hamoduli,crediti); 

--ESERCIZIO6
explain
select d.nome,d.id,d.descrizione
from inserogato ie
     join discriminante d on d.id = ie.id_discriminante
where ie.annoaccademico = '2008/2009'
      and ie.hamoduli < '0'
      and ie.crediti > '9';

create index ie on inserogato(id_discriminante,annoaccademico,hamoduli,crediti);

--ESERCIZIO7
explain
select i.nomeins,d.id,ie.crediti,ie.annierogazione
from inserogato ie
     join insegn i on i.id = ie.id_insegn
     join corsostudi cs on cs.id = ie.id_corsostudi
     join discriminante d on d.id = ie.id_discriminante
where ie.annoaccademico = '2013/2014'
      and cs.nome ilike 'laurea in informatica'
      and ie.hamoduli < '0'
group by i.nomeins,d.id,ie.crediti,ie.annierogazione
order by i.nomeins;

create index ie on inserogato(annoaccademico);
create index cs on corsostudi(nome varchar_pattern_ops,nomeins);

--ESERCIZIO8
select i.nomeins,max(ie.crediti) as maxCrediti
from inserogato ie
     join insegn i on i.id = ie.id_insegn
where ie.annoaccademico = '2013/2014'
group by i.nomeins;


create index iea on inserogato(annoaccademico);
create index nomeinsi on insegn(nomeins);


--ESERCIZIO9
explain
select ie.annoaccademico,max(ie.crediti), min(ie.crediti)
from inserogato ie
group by ie.annoaccademico;

create index iea on inserogato(annoaccademico);

--ESERCIZIO10
explain
select cs.nome
from corsostudi cs
where cs.id not in
(
      select id
      from corsostudi
      where nome ilike '%matematica%'
);

create index csn on corsostudi(nome varchar_pattern_ops);

--ESERCIZIO11

create temp view maxemin(idinserogato,idcorso,maxcrediti,mincrediti) as
(
      select ie.id,cs.id,max(ie.crediti),min(ie.crediti)
      from inserogato ie
           join corsostudi cs on cs.id = ie.id_corsostudi
      where ie.hamoduli < '0'
      group by (ie.id,cs.id)
);

select ie.annoaccademico,cs.id,sum(ie.crediti) as sommacrediti
from maxemin mm
     join inserogato ie on ie.id = mm.idinserogato
     join corsostudi cs on cs.id = mm.idcorso
where ie.hamoduli < '0'
group by (ie.annoaccademico,cs.id);
