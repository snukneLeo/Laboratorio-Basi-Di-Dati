--ESERCIZIO 1
CREATE DOMAIN tipoConvegno AS VARCHAR
    CHECK(VALUE IN ('seminario','simposio','conferenza'));

CREATE TABLE CONVEGNO
(
    nome VARCHAR(30) PRIMARY KEY,
    dataInizio DATE NOT NULL,
    dataFine DATE NOT NULL
        CHECK (dataFine >= dataInizio),
    numeroSessioni INTEGER NOT NULL
        CHECK (numeroSessioni > 0),
    tipo tipoConvegno NOT NULL,
    luogo VARCHAR NOT NULL
);

CREATE TABLE INTERVENTO
(
    id INTEGER PRIMARY KEY,
    titolo VARCHAR(30) NOT NULL,
    relatore VARCHAR NOT NULL,
    durata INTERVAL NOT NULL
        CHECK(durata > '00:00:'::INTERVAL)
);

CREATE TABLE SESSIONE
(
    nome VARCHAR,
    nomeConvegno VARCHAR(30) REFERENCES CONVEGNO(nome),
    dataS DATE NOT NULL,
    orarioInizio TIME WITH TIME ZONE NOT NULL,
    orarioFine TIME WITH TIME ZONE NOT NULL
        CHECK (orarioFine >= orarioInizio),
    PRIMARY KEY(nome,nomeConvegno)
);

CREATE TABLE INTERVENTO_IN_CONVEGNO
(
    nomeConvegno VARCHAR(30) REFERENCES CONVEGNO(nome),
    idIntervento INTEGER REFERENCES INTERVENTO(id),
    nomeSessione VARCHAR,
    orarioInizio TIME WITH TIME ZONE NOT NULL,
    PRIMARY KEY(nomeConvegno,idIntervento,nomeSessione),
    FOREIGN KEY(nomeConvegno, nomeSessione)
        REFERENCES SESSIONE(nomeConvegno,nome)
);
INSERT INTO CONVEGNO(nome,dataInizio,dataFine,numeroSessioni,tipo,luogo)
    VALUES
        ('Guitar Show','2018-06-08','2018-06-10',3,'conferenza','Padova'),
        ('Polo Zanotto','2018-06-19','2018-06-21',5,'seminario','Verona'),
        ('Tecnologia Industriale','2017-09-16','2018-09-16',27,'simposio','Maragnole');

INSERT INTO INTERVENTO(id,titolo,relatore,durata)
    VALUES
        (1,'Come cambiare le corde','Giovanni Boscaini','01:10:19'::INTERVAL),
        (2,'Come cambiare i pannolini','Cristian SanduCan','00:05:00'::INTERVAL),
        (3,'Come montare una passera','Leonardo Testolin','01:30:00'::INTERVAL);

INSERT INTO SESSIONE(nome,nomeConvegno,dataS,orarioInizio,orarioFine)
    VALUES
        ('Domanda1','Guitar Show','2010-06-19','11:51:50','11:51:59'),
        ('Domanda2','Tecnologia Industriale','2010-06-19','11:51:50','11:52:00'),
        ('Domande3','Guitar Show','2010-06-19','11:51:50','12:10:50');

INSERT INTO INTERVENTO_IN_CONVEGNO(nomeConvegno,idIntervento,nomeSessione,orarioInizio)
    VALUES
        ('Guitar Show',2,'Domanda1','10:51:50'),
        ('Tecnologia Industriale',1,'Domanda2','12:51:50'),
        ('Tecnologia Industriale',3,'Domanda2','16:51:50');


--ESERCIZIO 2
SELECT c.dataInizio,c.dataFine,ic.orarioInizio,s.nome,i.titolo,i.relatore
FROM INTERVENTO_IN_CONVEGNO ic 
     JOIN CONVEGNO c on ic.nomeConvegno = c.nome
     JOIN SESSIONE s on s.nome = ic.nomeSessione
     JOIN INTERVENTO i on i.id = ic.idIntervento
WHERE c.nome = 'Guitar Show'
ORDER BY c.dataInizio,c.dataFine,ic.orarioInizio;


--ESERCIZIO 5
CREATE INDEX ins_aa ON INSEROGATO(annoaccademico,crediti,modulo)