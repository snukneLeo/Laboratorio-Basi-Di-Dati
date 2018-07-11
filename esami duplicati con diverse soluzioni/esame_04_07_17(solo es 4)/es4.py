#Un template JINJA2 per una form HTML 5 che: (1) permetta di acquisire un codice fiscale (controllando il
#formato), (2) di selezionare una biblioteca dalla lista biblioteche passata come parametro al template e (3)
#invi i dati all’URL /prestitiUtente in modalità GET. Il formato di biblioteche è [ {id, nome}, ...] .
#Scrivere solo la parte della FORM, non tutto il documento HTML.


<form action="/prestitiUtente">
    <input type="text" name="cf" pattern="[A-Z]{6}[0-9]{2}[A-Z]{1}[0-9]{2}[A-Z]{1}[0-9]{3}[A-Z]{1}"/>
    <select name='biblio'>
        {% for i in biblioteca %}
        <option value="{{i.id}}"> {{i.nome}} </option>
        {%endfor%}
    </select>
    <input type="submit" value="Invia stronzo"/>
</form>


#(b) Un metodo Python che, associato all’URL /prestitiUtente secondo il framework Flask, (1) legga i
#parametri codice fiscale e identificatore biblioteca, (2) si connetta alla base di dati ’X’ (si assuma di
#dover specificare solo il nome della basi di dati) e recuperi tutti i prestiti (idRisorsa, dataInizio, du-
#rata) associati al codice fiscale e biblioteca dati come parametri (scrivere la query!), (3) usi il metodo
#render_template('view.html',...) per pubblicare il risultato passando la lista del risultato. Se il risultato
#dell’interrogazione è vuoto, il metodo deve passare il controllo a render_template('nessunPrestitoOErrore.html') .
#Scrivere solo il metodo.

from flask import Flask,request
from flask.templating import render_template
import psycopg2.extras

app = Flask(__name__)

@app.route('/prestitiUtente',methods=['GET','POST'])
def home():
    codicefiscale = request.args['cf']
    biblioteca = request.args['biblio']
    with psycopg2.connect(host='localhost',database= 'X',user='username',password='psw') as con:
        with con.cursor() as cur:
            cur.execute(
                """
                select idRisorsa,datainizio,durata
                from prestito
                where idtutente = %s
                      and idbilbioteca = %s
                """,(codicefiscale,biblioteca) #contro query injection
            )
            listares = cur.fetchAll()
        if not listares:
            return render_template('nessunPrestitoOErrore.html')
        return render_template('view.html',prestitiutenti=listares)
        con.close()




#ESERCIZIO5

Completare il seguente pezzo di codice Java affinché la procedura stampi in console il risultato dell’interroga-
zione dell’esercizio 3.
public static void main ( String [] args ) throws Exception 
{
    // Caricamento driver
    Class.forName("org.postgresql.Driver");
    String codiceFiscale = args[0];
    String idBiblio = args[1];
    // Creazione connessione
    try (Connection con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/X","",""))
    {
        PrepareStatment pst = con.PrepareStatment((
            "select idRisorsa,datainizio,durata from prestito where idtutente = ? and idbilbioteca = ?"));
        pst.clearParameters();
        pst.setString(codiceFiscale);
        pst.setString(idBiblio);

        Result rs = pst.executeQuery();
        while (rs.next())
        {
            System . out . println ( String . format ( " | %20 s | %20 s | %20 s | " , rs . getInt ( " idRisorsa " ) ,
            sdf . format ( rs . getDate ( " dataInizio " ) ) , (( PGInterval ) rs . getObject ( " durata " ) ) . getValue () ) ;
        }
    } 
    catch(SQLException e) 
    {
        System . out . println ( " Problema durante estrazione dati : " + e . getMessage () ) ;
        return ;
    }
}
        
