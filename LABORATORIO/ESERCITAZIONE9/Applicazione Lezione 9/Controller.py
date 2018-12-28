'''Controller dell'applicazione web 'Insegnamenti'
Formattazione salva righe per i lucidi!
@author: posenato'''

import logging
from flask import Flask, request
from flask.templating import render_template
from Model import Model

logging.basicConfig(level=logging.DEBUG)
app = Flask(__name__)  # Applicazione Flask!
app.jinja_env.line_statement_prefix = '#'  # attivo Line statements in JINJA

app.model = Model()
app.facolta = app.model.getFacolta("Scienze Matematiche Fisiche e Naturali")


@app.route('/')
def homePage():
	'''Home page deve presentare form per la scelta corso studi e
	anno accademico tra i corsi della facoltà di Scienze MM FF NN.'''
	corsiStudi = app.model.getCorsiStudi(app.facolta['id'])
	aA = app.model.getAnniAccademici(app.facolta['id'])
	return render_template('homepage.html', facolta=app.facolta, corsiStudi=corsiStudi, aa=aA, prova="<b>prova</b>")


@app.route('/insegnamenti', methods=['POST', 'GET'])
def insegnamenti():
	'''Elenco degli insegnamenti di un corso di studi in un a.a.'''
	if request.method == 'POST':
		idCorsoStudi = request.form['idCorsoStudi']
		aA = request.form['aa']
	else:
		idCorsoStudi = request.args['idCorsoStudi']
		aA = request.args['aa']

	corsoStudi = app.model.getCorsoStudi(idCorsoStudi)
	insEroConDoc = app.model.getInsEroConDoc(idCorsoStudi, aA)
	return render_template('insegnamenti.html', facolta=app.facolta, corsoStudi=corsoStudi, aa=aA, insErogati=insEroConDoc)


@app.route("/insegnamento", methods=['POST', 'GET'])
def insegnamento():
	'''Dettagli di un insegnamento erogato'''
	pass  # Da completare da parte dello studente.


if __name__ == '__main__':  # Questo if deve essere ultima istruzione.
	app.run(debug=True)  # Debug permette anche di ricaricare i file modificati senza rinizializzare il web server.
