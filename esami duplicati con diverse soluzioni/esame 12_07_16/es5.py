#Assumendo di avere una base di dati PostgreSQL che contenga le tabelle di questo tema d’esame, scrivere
#un programma Python che, leggendo i dati da console, inserisca una o più tuple nella tabella RICOVERI. Il
#programma deve visualizzare l’esito di ogni singolo inserimento. Non è richiesto che il programma visualizzi i
#dati possibili per gli attributi con domini vincolati. È richiesto che il programma suggerisca il tipo di dati da
#inserire e che non ammetta possibilità di SQL Injection.


def ricoveroinsert():
    conn = psycopg2.connect(host='localhost',database='x',user='user',pass='')
    divione = ""
    paziente = ""
    descrizione = ""
    urgenza = False
    dataAmmissione = ""
    dataDimissione = ""
    with conn:
        with conn.cursor() as cur:
            scelta = 'y'
            while scelta == 'y':
                scelta = input("Vuoi inserire una tupla?")
                if scelta == 'y':
                    #divisione, paziente, descrizione , urgenza , dataAmmissione, dataDimissione
                    divisione = input("inserisci la divisione")
                    paziente = input("inserisci il codice fiscale del paziente")
                    descrizione = input("inserisci la descrizione del ricovero")
                    urgenza = bool(input("inserisci true o false per l'urgenza"))
                    dataAmmissione = input("inserisci la data (gg-mm-yyyy)")
                    dataDimissione = input("inserisci la data (gg-mm-yyyy)")

                    try:
                        cur.execute(
                            """
                            insert into ricovero(divisione,paziente,descrizione,urgenza,dataammissione,datadimissione)
                                value(%s,%s,%s,%s,%s,%s)
                            """,(divione,paziente,descrizione,urgenza,dataAmmissione,dataDimissione)
                        )
                        print(cur.statusMessage)
                    catch(SQLException e)
                        conn.close()
                        return False
                else:
                    conn.close()
                    return False
    conn.close()