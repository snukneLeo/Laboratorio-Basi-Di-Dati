'''
Modified on Apr 28, 2018

In questo programma si assume che lo studente NON sappia usare le funzioni di Flask per leggere i dati del request.
Questo programma  FUNZIONA solo con un giocatore alla volta!
@author: posenato
'''

import random
from flask import Flask

app = Flask("Gioco")
# Alcune variabili dell'applicazione per rappresentare lo stato e le costanti del gioco.
#app.rnd = Random()
#app.rnd.seed()
app.stringa = ""
app.sequence = [0, 0, 0]
app.seqMaxIndex = 2
app.index = 0
app.moves = 0
app.maxAllowedMoves = 10

# Le seguenti variabili (in realtà costanti stringa) sono per scrivere pezzi di codice HTML in modo semplice
# Sono variabili di MODULO!
head = """<!DOCTYPE html>
<html>
<head>
	   <style>
       form, input {
         padding: 2px;
         width: auto;
         text-align: center;
       }
       input {
         font-size: x-large;
         padding: 5px;
       }
       </style>

</head>
<body>
"""
#print(app.sequence)

form = """
<form action="/pushed0" method="get">
	<input type="submit" value="0">
</form>
<form action="/pushed1" method="get">
	<input type="submit" value="1">
</form>
"""

form2 = """
<form action="/pushed0" "method="get">
    <input type="text" value="Indovina" readonly>
</form>
"""

tail = """
<form style="text-align: right" action="/" method="get">
	<input type="submit" value="Mi sono rotto, ricomincia!">
</form>
"""


def makeRandomSequence():
	#'''Genera una sequenza casuale di 3 bit e la memorizza nell'attributo app.sequence.'''
    numcasuale = 0
    for i in range(0,len(app.sequence)):
        app.sequence[i] = random.randint(0,1)


def availableMoves():
	'''Ritorna il numero di mosse ancora possibili'''
	return app.maxAllowedMoves - app.moves


@app.route('/')
def homePage():
	'''Inizializza il gioco e ritorna il codice HTML per la home page.'''
	makeRandomSequence()
	app.index = 0
	app.moves = 0
	return head + """
	<h1>Piccolo gioco di fortuna</h1>
	<p>Il giocatore deve indovinare una sequenza casuale di Vero o False di lunghezza 3.</p>
    <p>Ogni volta che il giocatore indovina un mossa, il gioco va avanti. Ogni volta che il giocatore sbaglia una mossa, il gioco ricomincia.</p>
	<p>Il giocatore vince se indovina una sequenza entro 10 mosse.</p>
	""" + form + form2 + tail


@app.route('/pushed0')
def falseButton():
    app.stringa += "0"
    return manageButton(False)


@app.route('/pushed1')
def trueButton():
    app.stringa += "1"
    return manageButton(True)




def manageButton(rightValue):
    """Realizza la logica del gioco. Ritorna il codice HTML della pagina di risposta in base allo stato del gioco e alla mossa fatta e passata in input"""
    fortuna = ""
    corretto = True
    if availableMoves() <= 0:
        answer = "<p>Hai terminato le mosse possibili.</p><h3>Hai perso!</h3>"
        return head + answer + tail
    if len(fortuna) == 3:
        for i in range(0,len(fortuna)):
            if fortuna[i] == app.sequence[i] and corretto == True:
                corretto = True
            else:
                corretto = False
        if corretto == False:
            answer = "<p>Mi dispiace ma la sequenza è sbagliata!</p>"
        else:
            answer = "<p>Grande!</p>"
            return head + answer + tail
    elif rightValue == True: # valore 1
        fortuna += "1"
        #return fortuna
    else: #valore 0
        fortuna += "0"
        #return fortuna


if __name__ == '__main__':
	app.run(debug=True)
