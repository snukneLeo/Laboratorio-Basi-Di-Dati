CREATE DOMAIN STATOUTENTE AS VARCHAR
    CHECK(VALUE IN('abilitato','ammonito','sospeso'));

CREATE DOMAIN STATORISORSA AS VARCHAR
    CHECK(VALUE IN('solo consultazione','disponibile','on-line'));

--L’insieme di questi valori
--può variare nel tempo ma si vuole mantenere un controllo stretto.
--DOBBIMO CREARE UNA TABELLA SEMPRE!!

CREATE TABLE TIPORISORSA
(
    id INTEGER PRIMARY KEY,
    nome VARCHAR NOT NULL,
);

--prestito.idUtente -> utente.codicefisc
--prestito.idrisorsa, idBiblio -> risorsa.idbiblioteca

CREATE TABLE UTENTE
(
    codiceFiscale VARCHAR(16) PRIMARY KEY
        CHECK  codiceFiscale SIMILAR TO '[A-Z]{6}[0-9]{2}[A-Z]{1}[0-9]{2}[A-Z]{1}[0-9]{3}[A-Z]',
    nome VARCHAR NOT NULL,
    cognome VARCHAR NOT NULL,
    telefono CHAR(11)
        CHECK telefono SIMILAR TO '\+[0-9]{10}',
    dataIscrizione DATE NOT NULL,
    stato STATOUTENTE NOT NULL
);

CREATE TABLE RISORSA
(
    id INTEGER,
    biblioteca VARCHAR REFERENCES BIBLIOTECA(id)
    titolo VARCHAR NOT NULL,
    --la chiave referenziata può essere null ATTENZIONE
    TIPO INTEGER NOT NULL REFERENCES TIPORISORSA, --uguale a quello sopra
    stato STATORISORSA NOT NULL,
    PRIMARY KEY(id,biblioteca)
);

CREATE TABLE RISORSA
(
    idRisorsa INTEGER,
    idBiblioteca VARCHAR,
    idUtente VARCHAR REFERENCES UTENTE,
    dataInizio DATE,
    durata INTERVAL NOT NULL 
        CHECK (durata > '00:00'::INTERVAL),
    FOREIGN KEY(idRisorsa, idBiblioteca) REFERENCES RISORSA(id,biblioteca)
    PRIMARY KEY(idRisorsa,idBiblioteca,idUtente,dataInizio)
);

--ESERCIZIO 2
--partiamo dal fondo di quella a destra gia ottimizzata e saliamo
--ATTENZIONE CONTROLLARE SEMPRE SE NELLA PARTE CI SONO GIÀ INDICI CREATI
CREATE INDEX I1 ON INSEGN(id);
CREATE INDEX I2 ON INSEERPGATO(annoaccademico,id_corsostudi);

--GUADAGNO PAGINE
--6428.47 a 359.43 

