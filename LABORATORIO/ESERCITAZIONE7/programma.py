import psycopg2
from datetime import date
from decimal import Decimal
import re
pattern = re.compile("^\d{2,2}/\d{2,2}/\d{4,4}$")
################################
#GLOBAL VARIABLE
username = "none"
password = "none"
numRow = 0
################################


#DEFINE METHOD FOR READING #####################################################
def updloadCred():
    global username
    global password
    with open("config.ini", mode="r") as credenziali:
        i = 0
        credList = [0 for i in range(0,2)]
        for line in credenziali:
            credList[i] = line
            i += 1
        username = credList[0]
        password = credList[1]
        print("Upload credenziali correct...")
#END ###########################################################################

#CONNECTION DATABASE ###########################################################
updloadCred()
connector = psycopg2.connect(host="dbserver.scienze.univr.it", \
                         database="id178kua", user=username.strip(),\
                         password=password.strip())
#END ###########################################################################
#CONNECTION DATABASE ###########################################################
def connection():
    print("Connection is established...")
#END ###########################################################################

#CLOSE CONNECTION DBMS #########################################################

#END ###########################################################################

# INSERT INTO SPESA ############################################################
def insert():
    print("Stai inserendo valori all'interno del DBMS...Attenzione!")
    dateIn = input("Inserisci la data della spesa (dd/mm/aaaa): ")
    if not isinstance(dateIn,str) or not pattern.match(dateIn):
          print("Date is not format dd/mm/aaaa")
          exit()
    print("Inserisci la voce della spesa effettuata in data: ",dateIn)
    voice = input()
    print("Inserisci l'importo della spesa: ",voice)
    importo = input()
    with connector:
        with connector.cursor() as cur:
            cur.execute("INSERT INTO SPESA (DATA,VOCE,IMPORTO)\
                        VALUES (%s,%s,%s)", \
                        ( dateIn, voice, importo ) )
            print("Feedback: ",cur.statusmessage)
        #connector.commit()
#END ###########################################################################

# SELECT FROM SPESA ############################################################
def select():
    with connector:
        with connector.cursor() as cur:
            cur.execute("SELECT id,data,voce,importo FROM SPESA")
            # Dentro il width interno , si stampa la tabella
            print( '=' * 55)
            print("N" , "Data" ,  "Voce" , "Importo")
            print ( '-' * 55)
            tot = Decimal(0)
            for riga in cur:
                global numRow
                numRow += 1
                print(riga[0] ,str(riga[1]) ,riga[2] ,Decimal(riga[3]))
                tot += riga[3]
            print( '-' * 55)
            print("Totale: ",tot)
            print( '=' * 55)
#END ###########################################################################

# DELETE FROM SPESA ############################################################
def delete():
    with connector:
        with connector.cursor() as cur:
            select()
            if(numRow == 0):
                print("Siamo spiacenti ma la tabella spesa non ha nessuna riga")
                exit()
            else:
                choiseUser = int(input("Scegliere l'id (N) da eliminare: "))
                cur.execute("DELETE FROM spesa WHERE id = %s" , (choiseUser ,) )
                print("Feedback: ",cur.statusmessage)
            #connector.commit()
#END ###########################################################################

#DEFINE MENU FOR PROGRAM #######################################################
def menu():
    choise = 0
    while(choise != 4):
            print("1. Inserire una voce di spesa")
            print("2. Vedere tutte le voci di spesa")
            print("3. Cancellare una voce di spesa")
            print("4. Exit")
            choise = int(input("Inserisci la scelta opportuna (1-4): "))
            if(choise == 1):
                insert()
            if(choise == 2):
                select()
            if(choise == 3):
                delete()
#END ###########################################################################



#MAIN ##########################################################################
connection()
menu()
#END MAIN ######################################################################
