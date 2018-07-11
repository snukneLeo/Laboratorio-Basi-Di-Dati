--ESERCIZIO1


--Si ricorda che: (1) il codice delle autostrade italiane considerate è composto dal carattere ’A’ seguito da un numero.
--(2) il codice ISTAT di un comune è una stringa di 6 cifre. (3) l’attributo numeroCaselli indica il numero di caselli
--dell’autostrada presenti nel territorio del comune (potrebbe essere anche zero).

create table autostrada
(
    codice varchar(3) primary key
        check(codice similar to 'A[0-9]+'),
    nome varchar unique not null,
    gestore varchar not null,
    lunghezza numeric(6,3)
        check(lunghezza > 0)
);

create table comune 
(
    codiceISTAT char(6) primary key
        check(codiceISTAT similat to '[0-9]{6}')
    nome varchar unique not null,
    numeroAbitanti integer not null
        check(numeroAbitanti > 0),
    superficie numeric not null
        check(superficie > 0)
);

create table raggiunge
(
    autostrada varchar(5) references autostrada,
    comune char(6) references comune,
    numeroCaselli integer not null
        check(numeroCaselli >= 0),
    primary key(autostrada,comune)
);

--ESERCIZIO2
--Trovare i comuni che non sono raggiunti da autostrade gestite dal gestore X, riportando il codice, il nome e gli
--abitanti del comune.
explain
select c.codiceISTAT,c.nome,c.numeroAbitanti
from comune c
where c.codiceISTAT not in
(
    select c1.codiceISTAT
    from raggiunge r
         join autostrada a on a.codice = r.autostrada
         join comune c1 on c1.codiceISTAT = r.comune
    where a.gestore ilike '3'
         and r.numeroCaselli > 0 --almeno c'è un autostrada
);

--oppure
explain
select c.codiceISTAT,c.nome,c.numeroAbitanti
from comune c

except

select c1.codiceISTAT,c1.nome,c1.numeroAbitanti
from raggiunge r
     join comune c1 on c1.codiceISTAT = r.comune
     join autostrada a on a.codice = r.autostrada
where a.gestore ilike '3'
      and r.numeroCaselli > 0; -- c'è almeno una autostrada


--ESERCIZIO4
--Trovare per ogni autostrada che raggiunga almeno 10 comuni, il numero totale di comuni che raggiunge e
--il numero totale di caselli, riportando il codice dell’autostrada, la sua lunghezza e i conteggi richiesti.

select a.codice, count(*), sum(r.numeroCaselli),a.lunghezza
from raggiunge r
     join autostrada a on a.codice = r.autostrada
     join comune c on c.codiceISTAT = r.comune
group by (a.codice,a.lunghezza)
having count(*)>= 10;

--Selezionare le autostrade che hanno un potenziale di utenti diretti (=numero di abitanti che la possono
--usare dal loro comune) medio rispetto al numero dei caselli dell’autostrada stessa superiore alla media
--degli utenti per casello di tutte le autostrade. Si deve riportare il codice dell’autostrada, il suo numero
--totale di utenti, la media di utenti per casello.

create temp view conteggio(codice,comune,totaleutenti,numerocaselli) as
(
    select r.autostrada,r.comune,sum(c.numeroAbitanti),sum(r.numeroCaselli)
    from raggiunge r
         join autostrada a on a.codice = r.autostrada
         join comune c on c.codiceISTAT = r.comune
);

select c.totaleutenti/c.numeroCaselli as mediautenticaselli,c.codice,c.totaleutenti
from conteggio c
where c.totaleutenti/c.numerocaselli >= ALL
(
    select avg(totaleutenti/numeroCaselli) as mediautentimediodituttiicaselli
    from conteggio
);


--ESERCIZIO5
--Considerando le query della domanda 4, illustrare quali sono gli indici da definire che possono migliorare
--le prestazioni e, quindi, scrivere il codice PostgreSQL che definisce gli indici illustrati.
--NESSUN INDICE DA SCRIVERE DATO CHE SONO JOIN SU CHIAVI PRIMARIE

select *
from raggiuge r
     join comune c on c.codiceISTAT = r.comune
where r.autostrada = 'A1';