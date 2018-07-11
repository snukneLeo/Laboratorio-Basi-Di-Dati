from flask import Flask, request,render_template
import psycopg2.extras

app = Flask(__name__)
_username = ""
_password = ""
_db_con = psycopg2.connect(host="dbserver.scienze.univr.it", database="", user=_username, password=_password)
#_db_con.isolation_level = 'REPEATABLE READ'
_db_con.set_session(autocommit=True)

@app.route('/telefonataCittaData', methods=['post','get'])
def home():

    citta = request.args['citta']
    data = request.args['data']
    
    lista = model.clienti(citta,data)

    if not lista:
        return render_template('erroreParametri.html')

    for cliente in lista:
        cliente['cognome'] = cliente['cognome'].upper()
    
    return render_template('index.html',lista,citta,data)