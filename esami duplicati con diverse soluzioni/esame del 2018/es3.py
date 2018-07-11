#from flask import Flask, request
import psycopg2.extras
from getpass import getpass


#app = Flask(__name__)
#app = Flask(__name__)
_username = ""
_password = ""
_db_con = psycopg2.connect(host="", database="", user=_username, password=_password)
_db_con.isolation_level = 'REPEATABLE READ'
_db_con.set_session(autocommit=True)

def getCursor():
    return _db_con.cursor(cursor_factory=psycopg2.extras.DictCursor) #restituisce un dizionario di tuple

#main
def main():
    lista = nomeConvegni()
    print("Nome Convegni:\n")
    for i in lista:
        print(i[0])
    
    print("Inserisci il nome del convegno: ")
    nomeC = input()
    if check(nomeC):
        print(True)
    while check != True:
        print("Errore!")
        print("Inserisci il nome del convegno: ")
        nomeC = input()
    
    print("idIntervento:\n")
    for i in lista:
        print(i[1])
    
    print("Inserisci l'id: ")
    ids = input()

    print("Nome Sessione:\n")
    for i in lista:
        print(i[2])
    
    print("Inserisci il nome della Sessione: ")
    nomeSessione = input()

    print("Orario Inizio:\n")
    for i in lista:
        print(i[3])
    
    print("Inserisci l'orario di inzio: ")
    orarioInizio = input()

    insertInto(nomeC,ids,nomeSessione,orarioInizio)

    

    

def check(update):
    with getCursor() as cur:
        cur.execute("""
        SELECT *
        FROM INTERVENTO_IN_CONVEGNO
        WHERE nomeconvegno = %s
        """,(update,))
        lista = list(cur)
        if not lista:
            return False
        else:
            return True

def nomeConvegni():
    with getCursor() as cur:
        cur.execute("""
        SELECT *
        FROM INTERVENTO_IN_CONVEGNO
        """)
        #print(cur.fetchall())
        return list(cur)

def insertInto(nomeC,ids,nomeSessione,orarioInizio):
     with getCursor() as cur:
        cur.execute("""
        INSERT INTO INTERVENTO_IN_CONVEGNO(nomeconvegno,idintervento,nomesessione,orarioinizio)
        VALUES(%s,%s,%s,%s)     
        """,(nomeC,ids,nomeSessione,orarioInizio))


if __name__ == '__main__':
    main()
    #app.run(debug=True)