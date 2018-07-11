--La quantità di grassi, proteine e carboidrati è in grammi su 100 grammi di ingrediente; la quantità nella tabella
--COMPOSIZIONE si assume espressa in grammi. La unità di misura dell’attributo INGREDIENTE.Calorie si assume essere
--kcal. Vincoli di integrità: COMPOSIZIONE.Ricetta → RICETTA , COMPOSIZIONE.Ingrediente → INGREDIENTE .

create table ingrediente
(
    id integer primary key,
    nome varchar not null,
    calorie decimal not null
        check(calorie > 0 and calorie <=100),
    grassi decimal not null
        check(grassi >  0 and calorie <=100),
    proteine decimal not null
        check(proteine > 0 and proteine<=100),
    carboidrati decimal not null
        check(carboidrati > 0 and carboidrati <= 100),
    check((grassi + proteine + carboidrati) = 100)
);

create table ricetta
(
    id integer primary key,
    nome varchar not null,
    regione varchar not null,
    porzioni integer not null
        check(porzioni > 0),
    tempopreparazione interval not null
        check(tempopreparazione > '00:00:00'::interval)
);

create table composizione
(
    ricetta integer references ricetta,
    ingrediente integer references ingrediente,
    quantita integer not null
        check(quantita > 0),
    primary key(ricetta,ingrediente)
);


--Trovare il nome e il tempo di preparazione delle ricette della regione Veneto che contengono almeno un
--ingrediente con più del 40% di carboidrati.


select r.nome, r.tempopreparazione
from composizione c
     join ricetta r on r.id = c.ricetta
     join ingrediente i on i.id = c.ingrediente
where r.regione ilike 'veneto'
      and i.carboidrati > 40 --perchè ogni grammo è per 100 grammi di ingredienti (il totale è gia per 100 grammi)


--(a)
--Trovare per ogni ricetta la quantità totale di proteine e la quantità totale di grassi, riportando anche il
--nome della ricetta.

create temp view conteggio(ricetta,nomericetta,totaleproteine,totalegrassi) as
(
    select r.id, r.nome,sum(i.proteine),sum(i.grassi)
    from composizione c
         join ricetta r on r.id = c.ricetta
         join ingrediente i on i.id = c.ingrediente
    group by (r.id)
);

select c.ricetta,c.nomericetta,c.totaleproteine,c.totalegrassi
from conteggio c;



--(b) Trovare le ricette che hanno la massima quantità di grassi per porzione, riportando il nome della ricetta
--e la sua quantità di grasso totale.

select c.nomericetta,c.totalegrassi
from conteggio c
     join ricetta r on e.id = c.ricetta
where (c.totalegrassi/r.porzione) >= ALL
(
    select max(c1.totalegrassi/r1.porzione)
    from conteggio c1
         join ricetta r1 on r1.id = c1.ricetta
);


--ESERCIZIO4
create index c1 on ricetta(regione);
create index c1 on ingredienti(carboidrati);

--ESERCIZIO5
--Assumendo di avere una base di dati PostgreSQL che contenga le tre tabelle di questo tema d’esame, scrivere
--un programma Python che si interfacci alla base di dati e, dopo aver chiesto da input il nome di una regione,
--visualizzi su monitor il risultato dell’interrogazione della domanda 2 considerando la regione data in input.

def metodo():
    listainfo = list()
    print("Inserisci nome regione")
    regione = input()
    with psycopg2.connect(database='X') as con:
        with con.cursor() as cur:
            cur.execute(
                """
                select r.nome, r.tempopreparazione
                from composizione c
                    join ricetta r on r.id = c.ricetta
                    join ingrediente i on i.id = c.ingrediente
                where r.regione ilike %s
                      and i.carboidrati > 40 
                """,(regione)
            )
            listainfo = cur.fetchAll()
        
        if not listainfo:
            return false
        
        for i in listainfo:
            print(listainfo[i])
        con.close()
    return true
