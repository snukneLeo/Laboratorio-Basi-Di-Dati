--ESERCIZIO1
create DOMAIN livelloD as varchar
    check(value in('principiante','intermedio','avanzato'));

create domain gm as varchar
    check(value in('petto','schiena','spalle','braccia','gambe'));
create domain giornoSett as char(3)
    check(value in('LUN','MAR','MER','GIO','VEN','SAB','DOM'));

create table esercizio
(
    nome varchar primary key,
    livello livelloD not null,
    gruppoMusicale gm not null
);

create table programma
(
    nome varchar primary key,
    livello livelloD not null
);

create table tut
(
    id integer primary key,
    eccentrico INTEGER NOT NULL
        CHECK(eccentrico >=0),
    stopEcc INTEGER NOT NULL 
        CHECK(stopEcc >=0), 
    concentrico INTEGER NOT NULL 
        CHECK(concentrico >=0), 
    stopCon INTEGER NOT NULL 
        CHECK(stopCon >=0) 
);

create table esercizio_in_programma
(
    nomeProgramma varchar references programma,
    giorno giornoSett,
    nomeEsercizio varchar references esercizio,
    ordine integer not null
        check(ordine > 0),
    serie integer not null
        check(serie > 0),
    ripetizioni integer not null
        check(ripetizioni > 0),
    tut integer not null references tut,
    riposo integer not null
        check(riposo > 0), -- in s
    primary key(nomeProgramma,giorno,nomeEsercizio)
);

INSERT INTO TUT(id, eccentrico, stopEcc, concentrico, stopCon)
	VALUES ( 123, 3, 4, 5, 6 ), (234, 1, 2, 3, 4), (345, 4, 5, 6, 7), (456, 5, 6, 7, 8), (567, 6, 7, 8, 9);

INSERT INTO ESERCIZIO(nome, livello, gruppoMusicale)
	VALUES ('panca piana', 'intermedio', 'petto'), ('vogatore', 'intermedio', 'braccia'), ('butterfly', 'principiante', 'petto'),
		('pressa', 'principiante', 'gambe'), ('lat machine', 'principiante', 'schiena'), ('shoulder press', 'intermedio', 'spalle'),
		('leg press', 'principiante', 'gambe');

INSERT INTO PROGRAMMA(nome, livello)
	VALUES ('full body', 'principiante'), ('three days', 'intermedio'), ('extreme workout', 'avanzato'), ('soft workout', 'principiante');

INSERT INTO ESERCIZIO_IN_PROGRAMMA(nomeProgramma, giorno, nomeEsercizio, ordine, serie, ripetizioni, tut, riposo)
	VALUES ('full body', 'LUN', 'butterfly', 2, 3, 10, 234, 2),
		('full body', 'GIO', 'lat machine', 1, 3, 10, 123, 2),
		('full body', 'LUN', 'vogatore', 1, 3, 10 , 123, 2),
		('full body', 'VEN', 'lat machine', 1, 3, 10, 123, 2),
		('full body', 'LUN', 'leg press', 1, 3, 10 , 123, 2),
		('full body', 'MAR', 'lat machine', 1, 3, 10, 123, 2),
		('full body', 'MER', 'lat machine', 1, 3, 10 , 123, 2),
		('full body', 'SAB', 'lat machine', 1, 3, 10, 123, 2),
		('full body', 'MER', 'panca piana', 1, 3, 10 , 123, 2),
		('extreme workout', 'LUN', 'leg press', 1, 4, 20, 567, 2),
		('extreme workout', 'LUN', 'pressa', 2, 3, 25, 456, 2),
		('extreme workout', 'MER', 'panca piana', 1, 4, 20, 345, 2),
		('extreme workout', 'VEN', 'pressa', 1, 3, 20, 234, 2),
		('three days', 'LUN', 'pressa', 1, 4, 20, 567, 2),
		('three days', 'DOM', 'lat machine', 1, 3, 10, 123, 2),
		('three days', 'VEN', 'butterfly', 2, 3, 15, 123, 2),
		('three days', 'VEN', 'shoulder press', 1, 3, 20, 234, 2);

--ESERCIZIO2
--Dato il nome ’X’ di un programma di allenamento, 
--scrivere una query che visualizzi tutti gli esercizi da fare
--(con tutti i dati necessari per l’esecuzione) ordinati 
--per i giorni di allenamento e ordine di esecuzione. Si deve
--anche visualizzare il gruppo muscolare dell’esercizio.

select eip.nomeEsercizio,eip.giorno,eip.ordine,eip.serie,
       eip.ripetizioni, eip.tut, eip.riposo,e.gruppoMusicale
from esercizio_in_programma eip
     join programma p on p.nome = eip.nomeprogramma
     join esercizio e on e.nome = eip.nomeEsercizio
where p.nome ilike 'full body'
order by (eip.giorno);


--ESERCIZIO4
--a)Trovare per ogni programma di allenamento distribuito su 
--almeno 3 giorni il numero totale di esercizi da
--svolgere e il tempo totale in minuti per ciascun giorno 
--di allenamento. Il risultato deve visualizzare nome
--programma di allenamento, giorno e i conteggi richiesti per 
--l’allenamento del giorno considerato.
--Suggerimento: Ogni ripetizione di esercizio richiede un tempo 
--pari alla somma dei valori del TUT. Per esempio,
--se il TUT è (4,1,4,1), il tempo totale di una ripetizione è 10 s. 
--Ogni serie richiede un tempo pari al tempo TUT
--moltiplicato per il numero di ripetizioni più il tempo di riposo 
--a fine serie. Il tempo di una serie moltiplicato per
--il numero di serie è il tempo totale (in s) per fare l’esercizio.

create temp view nTotgiorni(nomeP,nomeE,giornoc,tempotot) as
(
    select ep.nomeprogramma,ep.nomeesercizio,ep.giorno, 
           sum((((t.eccentrico + t.stopEcc + t.concentrico+t.stopCon)*(ep.ripetizioni+ep.riposo))*ep.serie)/60) --in minuti
    from esercizio_in_programma ep
         join tut t on t.id = ep.tut
    group by (ep.nomeprogramma,ep.nomeesercizio,ep.giorno)
);

select distinct(ep.nomeprogramma), ep.giorno, 
       count(ep.nomeEsercizio) as nTotaleEsercizi,
       nt.tempotot
from esercizio_in_programma ep
     join nTotgiorni nt on nt.nomeP = ep.nomeprogramma
     and nt.nomeE = ep.nomeesercizio
group by (ep.nomeprogramma,ep.giorno,nt.tempoTot)
having count(ep.giorno) >=3;

--b)
--Trovare tutti i programmi di allenamento (visualizzando nome 
--e livello) ciascuno dei quali contiene esercizi
--di livello ’principiante’ per il gruppo muscolare ’gambe’, 
--ha una durata di almeno 45 minuti per ciascun
--giorno e non contiene esercizi di qualsiasi livello per il
--gruppo muscolare ’petto’.

select p.nome,p.livello,e.gruppoMusicale, (nt.tempotot)
from esercizio_in_programma ep
     join esercizio e on e.nome = ep.nomeEsercizio
     join programma p on p.nome = ep.nomeprogramma
     join nTotgiorni nt on nt.nomeE = ep.nomeEsercizio
     and nt.nomep = ep.nomeprogramma
where e.nome not in
      (
          select nome
          from esercizio
          where gruppoMusicale ilike 'petto'
                and p.livello not ilike 'principiante'
                and e.gruppoMusicale not ilike 'gambe'
      )
group by (p.nome,p.livello,nt.tempotot,e.gruppoMusicale)
having (nt.tempotot) >= 25; -- non metto 45 perchè non ne ho nel db

--ESERCIZIO5
--a) nessun indice creato
--b)
create index eip on esercizio_in_programma(tut,ordine)