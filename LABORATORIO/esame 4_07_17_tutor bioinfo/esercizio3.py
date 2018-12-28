@app.route('/prestitiUtente')
def prestito():
    codiceFiscale = request.args['utente']
    biblioteca = request.args['biblio']
    with psycopg2.connect(database='X') as conn:
        with conn.cursor() as cur:
            cur.execute
            (
                """SELECT idRisorsa, dataInizio, durata 
                   FROM Prestito
                   WHERE idUtente = %s AND idBiblioteca = %s""",
                   (codiceFiscale,biblioteca)
            )
        lista = cur.fetchall()
    conn.close()

    if not lista:
        return render_template('/nessunPrestito.html')
    else:
        return render_template('view.html',listaPrestiti=lista,cUtente=codiceFiscale,idbiblio=biblioteca)