

@app.route('/prestitiUtente', methods=['get', 'post'])
def home():
    cf = ""
    biblio = ""
    biblioteca = list() #lista che raccoglie tutte le info
    if request.method = 'post':
        cf = request.form['codF']
        biblio = request.form['biblio']
    else:
        cf = request.args['codF']
        biblio = request.args['biblio']
#recuperi tutti i prestiti (idRisorsa, dataInizio, durata) associati al codice fiscale e biblioteca dati come parametri
    with psycopg2.connect(database='X') as con:
        with con.cursor() as cur:
            cur.execute(
                """
                select p.idrisorsa,p.datainizio,p.durata
                from presitit p
                where p.idutente = %s
                      and p.idbiblioteca = %s
                """,(cf,biblio)
            )
            biblioteca = cur.fetchAll() #prendo tutti i valori della lista risultato
        con.close() #chiudo la connessione

    if not biblioteca:
        return render_template('nessunPrestitoOErrore.html') #errore

    return render_template('view.html',bibliolista=biblioteca,codicefiscale=cf,sceltabiblio=biblio) #ok
    

    