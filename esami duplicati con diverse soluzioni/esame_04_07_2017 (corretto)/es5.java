//ESERCIZIO5

//parte da completare


/**
 *  si connetta alla base di dati ’X’ (si assuma di
    dover specificare solo il nome della basi di dati) e recuperi tutti i prestiti (idRisorsa, dataInizio, du-
    rata) associati al codice fiscale e biblioteca dati come parametri
 */
try 
{   
    SimpleDateFormat sdf = new SimpleDateFormat('gg/mm/YYYY');
    String data = sdf.format(new Date()) //data di oggi 
    preparedStatment pst = con.preparedStatment(
    "
    select p.idrisorsa,p.datainizio,p.durata
                from presitit p
                where p.idutente = ?
                      and p.idbiblioteca = ?
    "
    );
    pst.setString(1,codice);
    pst.setString(2,biblio);
    pst.setDate(2,data);
    Result res = pst.executeQuery();
    ...
} 
catch (Exception e) 
{
    
}