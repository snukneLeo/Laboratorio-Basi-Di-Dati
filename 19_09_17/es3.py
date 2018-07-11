#1)

app = flash(__name__)




@app.route('/prenota', methods=['post','get'])
def prenotazione():
    with psycopg2.connect(database = 'X') as con:
        with con.cursor() as cur: 
            if request.method == 'post':
                iataCompagnia = request.form['iataC']
                numerovolo = request.form['nvolo']
                orariovolo = request.form['oravolo']
                isbusinnes = request.form['isb']
            else:
                iataCompagnia = request.args['iataC']
                numerovolo = request.args['nvolo']
                orariovolo = request.args['oravolo']
                isbusinnes = request.args['isb']
            #Verifichi se c’è un posto a disposizione nella 
            # classe indicata
            if isbusinnes == true:
                cur.execute(
                    """
                    select (postiBusiness - postiBusinesscomprati)
                    from volo
                    where numero = %s and orariovolo = %s
                    and isBusiness = %s and iatacompagnia = %s
                    """,(numerovolo,orariovolo,isbusinnes,iataCompagnia)
                )
            else:
                cur.execute(
                    """
                    select (postiEconomu - postiEconomycomprati)
                    from volo
                    where numero = %s and orariovolo = %s
                    and isBusiness = %s and iatacompagnia = %s
                    """,(numerovolo,orariovolo,isbusinnes,iataCompagnia)
                )
        lista = cur.fetchAll()
    con.close()
    check = 0
    for i in lista:
        if(i > 0):
            check = 1
    tuttook = insert_into(iataCompagnia,numerovolo,orariovolo,isbusinnes)
    if not tuttook:
        return render_template('nessunVoloOPostiEsauriti.html')
    return render_template('prenotazioneEffetuata.html')
    

def insert_into(iataCompagnia,numerovolo,orariovolo,isbusinnes):
    with psycopg2.connect(database = 'X') as con:
        with con.cursor() as cur:
            if isbusinnes == true:
                cur.execute(
                    """
                    update volo
                    set postiBusiness = postiBusiness +1
                    where numerovolo = %s and
                    orariovolo = %s and iatacompagnia = %s 
                    """,(numerovolo,orariovolo,iataCompagnia)
                )
            else:
                cur.execute(
                    """
                    update volo
                    set postiBusiness = postiBusiness +1
                    where numerovolo = %s and
                    orariovolo = %s and iatacompagnia = %s 
                    """,(numerovolo,orariovolo,iataCompagnia)
                )
    con.close()
