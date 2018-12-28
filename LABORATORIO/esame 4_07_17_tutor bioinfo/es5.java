public static void main ( String [] args ) throws Exception {
// Caricamento driver
Class . forName ( " org . postgresql . Driver " ) ;
String codiceFiscale = args [0];
String idBiblio = args [1];
// Creazione connessione
try 
(
    Connection con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/X","",""))
    {
    try 
    (
        preparedStatement pst = con.preparedStatement("SELECT ... FROM PRESTITO WHERE IDBIBLIO = ? AND IDUTENTE = ?"
        pst.clearParameters();
        pst.setString(1,idBiblio);
        pst.setString(2,codiceFiscale);
        ResultSet rs = pst.executeQuery();
        )
    {
        while ( rs . next () ) {
        System . out . println ( String . format ( " | %20 s | %20 s | %20 s | " , rs . getInt ( " idRisorsa " ) ,
            sdf. format ( rs . getDate ( " dataInizio " ) ) , (( PGInterval ) rs . getObject ( " durata " ) ) . getValue () ) ;
}
} catch ( SQLException e ) {
System . out . println ( " Problema durante estrazione dati : " + e . getMessage () ) ;
return ;
}