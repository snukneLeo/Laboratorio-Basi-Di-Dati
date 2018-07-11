#Un metodo Python che, associato all’URL ’/telefonateCittaData’ secondo il framework Flask: (1) leg-
#ga i parametri, (2) usi il metodo model.Clienti(citta, data) per ottenere il risultato della que-
#ry ([{cognome, nome},...]), (3) corregga tutti i cognomi rendendoli maiuscoli e (4) usi il metodo
#render_template(’view.html’,...) per pubblicare il risultato. Se la lista restituita da model.Clienti
#è vuota, il metodo deve passare il controllo a render_template('erroreParametri.html') .


@app.route('/telefonataCittaData', methods=['get','post'])
def caccapopo():
    #sia solo in get
    citta = request.args['cittaScelta']
    data = datetime.datetime.strptime(request.args['data'],'%d/%m/%Y')

    listares = model.Clienti(citta,data)

    for i in listares:
        i['cognome'] = i['cognome'].upper()
    
    #invio i dati modificati
    if not listares:
       return render_template('erroreParametri.html')
    return render_template('view.html',listaclienti=listares)