@app.route('/prenota', methods=['post','get'])
def prenota():
    cf = ""
    iataC = ""
    numerovolo = 0
    orarioVolo = ""
    isbusiness = None
    listares = list()

    if request.method = 'post':
        cf = request.form['cf']
        iataC = request.form['iata']
        numerovolo = request.form['nv']
        isbusiness = request.form['bus']
        orarioVolo = request.form['ov']
    else:
        cf = request.args['cf']
        iataC = request.args['iata']
        numerovolo = request.args['nv']
        isbusiness = request.args['bus']
        orarioVolo = request.args['ov']

    with psycopg2.connect(databse='X') as con:
        with con.cursor() as cur:
            cur.execute(
                """
                select (v.postiBusiness-v.postiBusinessComprati) as b, (v.postiEconomy-v.postiEconomyComprati) as e
                from volo v
                where v.iataCompagnia = %s
                        and v.numero = %s
                        and v.orariopartenza = %s
                """,(iataC,numerovolo,orariopartenza)
            )
            listares = cur.fetchAll()

            if not listares:
                conn.close()
                return render_template('nessunVoloOPostiEsauriti.html')
    
            checkb = 0
            checke = 0
            if listares[0] > 0:
                checkb = 1
            if listares[1] > 0:
                checke = 1

            if checkb == 1:
                cur.execute(
                    """
                    update volo
                    set postiBusinessComprati = postiBusinessComprati+1
                    where iatacompagnia = %s
                          and numero = %s
                          and orariopartenza = %s
                    """,(iataC,numerovolo,orariopartenza)
                )
            elif checke == 1:
                 cur.execute(
                    """
                    update volo
                    set postieconomyComprati = postieconomyComprati+1
                    where iatacompagnia = %s
                          and numero = %s
                          and orariopartenza = %s
                    """,(iataC,numerovolo,orariopartenza)
                )
            if checkb == 1 or checke == 1:
                cur.execute(
                    """
                    insert into prenotazione(iataCompagnia, numeroVolo, orarioPartenza, codiceFiscale, isBusiness)
                    values(%s,%s,%s,%s,%s)
                    """,(iataC,numerovolo,orarioVolo,cf,isbusiness)
                )
            elif checkb == 0 and checke == 0:
                con.close()
                    return render_template('prenotazioneEffettuata.html')
            con.close()
            return render_template('prenotazioneEffettuata.html')
       
    
    
        
