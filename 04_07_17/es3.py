

@app.route('/presitiUtente')
def home():
    biblioteca = request.args['biblio']
    codice = request.args['codF']
    with psycopg2.connect(database = 'X') as con:
        with con.cur() as cur:
            cur.execute(
                """
                select p.idrisorsa,p.datainizio,p.durata
                from prestito p
                where idutente = %s and idbiblioteca = %s
                """,(codice,biblioteca))
        lista = cur.fetchAll()
    con.close()
            if not lista:
                return render_template('nessunPrestitoOErrore.html')
            return render_template('index.html',listaprestiti = lista,codfiscale = codice,\
                                   biblio = biblioteca)
                                   