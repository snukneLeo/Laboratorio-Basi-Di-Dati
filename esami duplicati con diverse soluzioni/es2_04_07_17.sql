create index  i1 on inserogato(annoaccademico,id_corsostudi);


--QUERY DAL PIANO
create index anncristinao on inserogato(annoaccademico);
select *
from inserogato ie
     join insegn i on i.id = ie.id_insegn
where ie.annoaccademico like '2006/2007'
      and ie.id_corsostudi >= ALL
      (
            select max(ie1.id_corsostudi)
            from inserogato ie1
            where ie1.id_insegn = ie.id_insegn
      );