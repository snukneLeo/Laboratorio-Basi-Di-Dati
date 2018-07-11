--ESERCIZIO1

create domain livellodominio as varchar
    check(values in('principiante','intermedio','avanzato'));

create table gm as varchar()
    check(values in('petto','schiena','spalle','spalle','braccia','gambe'));

create table giornosett as char(3)
    check(values in('LUN','MAR','MER','GIO','VEN','SAB','DOM'));

create table esecizio
(
    nome varchar primary key,
    livello livellodominio not null,
    gruppomuscolare gm not null
);

create table programma
(
    nome varchar primary key,
    livello livellodominio not null
);

create table tut
(
    id serial primary key,
    valore1 integer not null
        check(valore1 > 0),
    valore2 integer not null
        check(valore2 > 0),
    valore3 integer not null
        check(valore3 > 0),
    valore4 integer not null
        check(valore4 > 0)
);

create table esercizio_in_programma
(
    nomeprogramma varchar references programma,
    giorno giornosett,
    nomeesercizio varchar references esercizio,
    ordine integer not null
        check(ordine > 0),
    serie integer not null
        check(serie > 0),
    ripetizioni integer not null
        check(ripetizioni > 0),
    tut integer not null references tut(id),
    riposo integer not null
        check(riposo > 0), -- in secondi
    primary key(nomeprogramma,giorno,nomeesercizio)
);

--ESERCIZIO2
--Dato il nome ’X’ di un programma di allenamento, scrivere una query che visualizzi tutti gli esercizi da fare
--(con tutti i dati necessari per l’esecuzione) ordinati per i giorni di allenamento e ordine di esecuzione. Si deve
--anche visualizzare il gruppo muscolare dell’esercizio.

select ep.*,t.valore1,t.valore2,t.valore3,t.valore4,e.gruppomuscolare
from esercizio_in_programma ep
     join esercizio e on e.nome = ep.nomeesercizio
     join tut t on t.id = ep.tut
where ep.nomeprogramma ilike 'X' --full body
order by (ep.giorno,ep.ordine);



--Trovare per ogni programma di allenamento distribuito su almeno 3 giorni il numero totale di esercizi da
--svolgere e il tempo totale in minuti per ciascun giorno di allenamento. Il risultato deve visualizzare nome
--programma di allenamento, giorno e i conteggi richiesti per l’allenamento del giorno considerato.
--Suggerimento: Ogni ripetizione di esercizio richiede un tempo pari alla somma dei valori del TUT. Per esempio,
--se il TUT è (4,1,4,1), il tempo totale di una ripetizione è 10 s. Ogni serie richiede un tempo pari al tempo TUT
--moltiplicato per il numero di ripetizioni più il tempo di riposo a fine serie. Il tempo di una serie moltiplicato per
--il numero di serie è il tempo totale (in s) per fare l’esercizio.

create temp view conteggio(nomeprogramma,giorno,numerototaleesercizi,tempototale) as
(
    select ep.nomeprogramma,count(distinct(*)),count(ep.nomeesercizio),sum((((t.valore1 + t.valore2 + t.valore3 + t.valore4)*ep.ripetizioni)+ep.riposo)*ep.serie)
    from esercizio_in_programma ep
         join tut t on t.id = ep.tut
    group by (count(*)>=3)
);


select nomeprogramma,giorno,numerototaleesercizi,tempototale
from conteggio
group by(nomeprogramma,giorno,numerototaleesercizi,tempototale);

--Trovare tutti i programmi di allenamento (visualizzando nome e livello) ciascuno dei quali contiene esercizi
--di livello ’principiante’ per il gruppo muscolare ’gambe’, ha una durata di almeno 45 minuti per ciascun
--giorno e non contiene esercizi di qualsiasi livello per il gruppo muscolare ’petto’.

select e.nome, e.livello,c.tempototale,c.numerototaleesercizi
from esercizio e
     join esercizio_in_programma ep on ep.nomeesercizio = e.nome
     join conteggio c on c.nomeprogramma = ep.nomeprogramma
where e.nome in
(
    select e1.nome
    from esercizio_in_programma ep
         join esercizio e1 on e1.nome = ep.nomeesercizio
    where eq.gruppomuscolare ilike 'gambe'
         and e1.livello ilike 'principante'
         and eq.nome not in
         (
             select e2.nome
             from esercizio_in_programma ep1
                  join esercizio e2 on e2.nome = ep1.nomeesercizio
             where e2.gruppomuscolare ilike 'petto'
         )
)
group by(e.nome,e.livello,c.tempototale,c.numerototaleesercizi)
having c.numerototaleesercizi >=25;


--oppure

select eip.nomeprogramma, p.livello
from esercizioinprogramma eip join programma p on p.nome=eip.nomeprogramma 
        join tut t on t.id=eip.tut
where eip.nomeprogramma in(
    select eip.nomeprogramma
    from esercizioinprogramma eip join esercizio e on e.nome=eip.nomeesercizio
    where e.livello='principiante' and e.gruppomuscolare='gambe'
) 
and not exists (
    select eip2.nomeprogramma, sum(((t1.value+t2.value+t3.value+t4.value)*eip.ripetizioni+eip.riposo)*eip.serie)) as conto
    from esercizioinprogramma eip2
    where eip2.nomeprogramma=eip1.programma
    group by eip2.nomeprogramma
    having conto < 45
) and eip.nomeprogramma not in(
    select eip.nomeprogramma
    from esercizioinprogramma eip join esercizio e on e.nome=eip.nomeesercizio
    where e.gruppomuscolare='gambe'

);


--ESERCIZIO5
gli indici per le chiavi sono già creati ma in questo caso non
vengono usati perchè non li conviene usarli (forse è così)

create index i2 on esercizio_in_programma(tut,ordine);