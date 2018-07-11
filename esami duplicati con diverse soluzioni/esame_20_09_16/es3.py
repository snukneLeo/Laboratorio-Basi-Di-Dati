#Assumendo di avere una base di dati PostgreSQL che contenga le tabelle di questo tema d’esame, scrivere un
#programma Python che, leggendo i dati da console, inserisca una o più tuple nella tabella RAGGIUNGE facendo
#un controllo preventivo che le eventuali dipendenze siano rispettate. Se una dipendenza non è rispettata, il
#programma deve richiedere di reinserire il dato associato alla dipendenza prima di procedere a inserire la tupla
#nella tabella RAGGIUNGE. Il programma deve visualizzare l’esito di ogni singolo inserimento. È richiesto che
#il programma suggerisca il tipo di dati da inserire e che non ammetta possibilità di SQL Injection.



def insertraggiunge():
    with psycopg2.connect(host='localhost',database='X',user='user',password='psw') as con:
        with con.cursor() as cur:
            scelta = 'y'
            autostrada = ""
            comune = ""
            numerocaselli = 0
            errore = 0
            while(scelta != 'n'):
                print("Vuoi inserire una tupla sulla tabella raggiunge? (y,n)")
                scelta = input()
                if scelta != 'n':
                    autostrada = input("inserisci il codice autostrada A[0-9]+")
                    while errore != 1:
                        cur.execute(
                            """
                            select * from autostrada where codice = %s
                            """,(autostrada,)
                        )
                        status = cur.fetchone()
                        if not status and status[0] != 1:
                            errore = 1
                        else:
                            errore = 0
                            print("autostrada presente")
                    errore = 0
                    comune = input("inserisci comune")
                    while errore != 1:
                        cur.execute(
                            """
                            select * from comune where codiceISTAT ilike %s
                            """,(comune,)
                        )
                        status = cur.fetchone()
                        if not status and status[0] != 1:
                            errore = 1
                        else:
                            errore = 0
                            print("comune presente")
                    
                    errore = 0
                    numerocaselli = int(input("Inserisci il numero di caselli"))
                    while errore != 1:
                        if numerocaselli < 0:
                            errore = 1
                        else:
                            errore = 0
                            print("numero caselli corretto")
                    
                    #inserisco tutto
                    try:
                        cur.execute(
                            """
                            insert into raggiunge(autostrada,comune,numerocaselli)
                                values(%s,%s,%s)
                            """,(autostrada,comune,numerocaselli)
                        )
                    except (Exception, psycopg2.IntegrityError):
                        return False
                    print("Inserimento avvenuto con successo")
                    print(cur.statusmessage) #stampa INSERT 0 1
                else:
                    scelta = 'n'
        con.close()



#VERSIONE DI JAVA

public void method()
{
    Scanner sc = new Scanner(System.in);
    System.out.println("Vuoi inserire una tupla? (y,s)");
    string scelta = sc.next();
    int errore = 0;

    while(scelta.equals('y'))
    {
        if scelta.equals('y')
        {
            try (Connection con = DriverManager.getConnection("...."))
            {
                while(errore != 1)
                {
                    System.out.println("Inserisci il codice dell'autostrada A[0-9]");
                    string codA = sc.next();
                    try(PreparedStatment pst = con.PreparedStatment(
                        "select codice from autostrada where codice = ?"
                    ));
                    pst.clearParameters();
                    pst.setString(1,codA);
                    Result res = pst.executeQuery();
                    if (length(res) > 0)
                    {
                        while(res.next())
                        {
                            System.out.println("ok");
                            System.out.println(res.getString('codice'));
                        }
                    }
                    else
                    {
                        errore = 1;
                    }
                }
                errore = 0;
                while(errore != 1)
                {
                    System.out.println("Inserisci il comune 091230");
                    string comune = sc.next();

                    try(PreparedStatment pst = con.PreparedStatment(
                        "select codiceISTAT from autostrada where codiceISTAT = ?"
                    ));
                    {
                        pst.clearParameters();
                        pst.setString(1,comune);
                        Result res = pst.executeQuery();
                        if (length(res) > 0)
                        {
                            while(res.next())
                            {
                                System.out.println("ok");
                                System.out.println(res.getString('codice'));
                            }
                        }
                        else
                        {
                            errore = 1;
                        }
                    }
                    catch(SQLEception e)
                    {
                        System.out.println(e.getMessage());
                    }
                }
                while(errore != 1)
                {
                    System.out.println("Inserisci numero caselli");
                    string numerocaselli = sc.next();

                    if (numerocaselli >= 0)
                    {
                        errore = 0;
                        system.out.printn("ok");
                    }
                    else
                    {
                        errore = 1
                        System.out.println("errore")
                    }
                }

                try (PreparedStatment pst = con.PreparedStatment(
                    "insert into raggiunge(autostrada,comune,numerocaselli) values (?,?,?)"
                ));
                {
                    pst.clearParameters();
                    pst.setString(codA);
                    pst.setString(comune);
                    pst.setInteger(numerocaselli);
                    pst.executeUpdate();
                }
                catch(SQLEception e)
                {
                    System.out.println(e.getMessage());
                    return false;
                }
            }
            catch(SQLEception e)
            {
                System.out.println(e.getMessage());
            }
        }
        else:
            return false;
    }
   
}

