

def insert():
    print("nome convegno:")
    convegno = input()
    print("nome sessione:")
    sessione = input()
    print("idintervento:")
    intervento = input()
    print("orarioinizio:")
    orario = input()

    check = checkdate(convegno,sessione,intervento,orario)
    if check == 0:
        print("errore")
    else:
        updateInfo(convegno,sessione,intervento,orario)


def checkdate(convegno,sessione,intervento,orario):
    check = 0
    with psycopg2.connect(database='X') as con:
        with con.cursor() as cur:
            cur.execute(
                """select *
                   from convegno
                   where nome = %s
                """,(convegno))
        lista = cur.fetchAll()
    con.close()

    if not lista:
        print('Errore nome convegno errato')
        view()
        return
    return 1

def view():
    with psycopg2.connect(database = 'X') as con:
        with con.cursor() as cur:
            cur.execute(
                """
                select nome
                from convegno
                """
            )
        lista = cur.fetchAll()
    con.close()

    for i in lista:
        print(i.nome)
        print("\n")
...lo rifaccio per tutti gli altri

def updateInfo(convegno,sessione,intervento,orario):
    with psycopg2.connect(databse='X') as con:
        with con.cursor() as cur:
            cur.execute(
                """
                insert into intervento_in_convegno
                                    (nomeconvegno,idintervento,nomesessione,orarioinizio)
                    values(%s,%s,%s,%s)
                """,(convegno,intervento,sessione,orario)
            )