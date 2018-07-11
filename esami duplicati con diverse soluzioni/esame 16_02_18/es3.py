import psycopg2

def go():
    conn = psycopg2.connect(database='X')
    conn.isolation_level = 'serializable'
    nomeconvegno = ""
    nomesessione = ""
    idintervento = 0
    orarioinizio = ""
    with conn:
        with conn.cursor() as cur:
            scelta = "y"
            while scelta == "y":
                scelta = input("vuoi inserire? (y/n)")
                if scelta == "y":
                    check = True
                    while check:
                        nomeconvegno = input("inserisci nome convegno")
                        cur.execute(
                            """
                            select * from convegno where nome = %s
                            """,(nomeconvegno,)
                        )
                        res = list(cur)

                        if not res:
                            check = False
                        else:
                            check = True
                            print("ok")
                    
                    while check:
                        nomesessione = input("inserisci sessione")
                        cur.execute(
                            """
                            select * from sessione where nome = %s
                            """,(nomesessione,)
                        )
                        res = list(cur)

                        if not res:
                            check = False
                        else:
                            check = True
                            print("ok")
                    
                    while check:
                        idintervento = input("inserisci idintervento")
                        cur.execute(
                            """
                            select * from intervento where id = %s
                            """,(idintervento,)
                        )
                        res = list(cur)

                        if not res:
                            check = False
                        else:
                            check = True
                            print("ok")
                    
                    #tutto ok
                    while check:
                        orarioinizio = input("inserisci orario inizio (yyyy-mm-gg 00:00:00+01)")
                        cur.execute(
                            """
                            select *
                            from intervento_in_convengo ic
                                 join sessione s on s.nome = ic.nomesessione
                                 and s.nomeconvegno = ic.nomeconvegno
                                 join intervento i on i.id = ic.idintervento
                            where (s.orarioinizio + s.durata)::timestamp < s.orariofine
                            and exists
                            (
                                select 1 
                                from intervento_in_intervento i2
                                     join i2.nomeconvegno = s.nomeconvegno
                                     and i2.nome = i2.nomesessione
                                
                            )                          
                            """,(orarioinizio,)
                        )
                        res = list(cur)

                        if not res:
                            check = True
                        else:
                            check = False
                            print("no")

                        #insert
                        try:
                            cur.execute(
                                """
                                insert into intervento_in_convegno(nomeconvegno,idintervento,nomesessione,orarioinizio)
                                value(%s,%s,%s,%s)
                                """,(nomeconvegno,idintervento,nomesessione,orarioinizio)
                            )
                            cur.statusMessage()
                        catch(SQLException e):
                            return falseù
    conn.close()

                
                
