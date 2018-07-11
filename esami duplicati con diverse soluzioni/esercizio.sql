--Trovare per ogni contratto il mese in cui ha effettuato il maggior numero di 
--telefonate nell’anno 2016
--riportando il numero di contratto, il mese e il numero di telefonate.

create temp view conteggio(contratto,mese,numtelefonate) as
(
    select c.contratto,extract(month from c.datainizio) as meseEstratto,count(*)
    from contratto c
        join telefonata t on t.contratto = c.contratto
    where extract(year from c.datainizio) = '2016'
    group by (c.contratto,meseEstratto)
);

select c.contratto,c.mese,c.numtelefonate
from conteggio c
where c.numtelefonate >= ALL
(
    select max(numtelefonate)
    from conteggio
);

Trovare per ogni contratto iniziato nel mese di Gennaio 2007 il numero di telefonate e 
la durata totale
delle telefonate eseguite nel mese di Maggio 2007 dal cliente del contratto, riportando 
nel risultato la data
di inizio del contratto, identificatore del contratto e i conteggi richiesti.


create temp view conteggio2(contratto,data,numerotel) as 
(
    select c.contratto,c.datainizio,count(*)
    from contratto c
         join telefonata t on t.contratto = c.contratto
    where c.datainizio between '2007-01-01' and '2007-01-31'
    group by(c.contratto,c.datainizio)
);

create temp view conteggio3(contratto,data,duratatotale) as
(
    select c.contratto,c.datainizio,sum(t.duratatotale)
    from contratto c
         join telefonata t on t.contratto = c.contratto
    where (t.istanteinizio)::date between '2007-05-01' and '2007-05-31'
    group by(c.contratto,c.datainizio)
);

select c1.contratto,c.datainizio,c1.numerotel,c2.duratatotale
from conteggio2 c1
     join conteggio3 c2 on c2.contratto = c1.contratto
group by(c1.contratto,c.datainizio,c1.numerotel,c2.duratatotale);


Trovare per ogni utente che abbia fatto prestiti presso almeno due biblioteche, il numero di
prestiti terminati alla data corrente presso ciascuna biblioteca e la loro durata totale sempre 
per ciascuna biblioteca.
Il risultato deve riportare il codice fiscale dell’utente, l’id della biblioteca e i conteggi 
richiesti.

UTENTE (codiceFiscale, nome , cognome , telefono , dataIscrizione , stato )
PRESTITO (idRisorsa, idBiblioteca, idUtente, dataInizio, durata )
RISORSA (id, biblioteca, titolo , tipo , stato )

create temp view conteggio(utente,biblio,numprestiti,duratatotale) as
(
    select r.idUtente,r.idBiblioteca,count(*),sum(p.durata)
    from prestito p
         join risorsa r on r.id = p.idRisorsa
         and p.idBiblioteca = p.biblioteca
    where (p.dataInizio+durata)::date < current_date
    group by(r.idUtente,r.idBiblioteca)
);

select c.utente,c.biblioteca,c.numprestiti,c.duratatotale
from conteggio c
where c.utente in
(
    select utente
    from conteggio
    group by (utente)
    having count(*) >=2
);

