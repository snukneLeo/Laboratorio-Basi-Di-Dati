public static void main ( String [] args ) throws Exception 
{
// Caricamento driver
Class . forName ( " org . postgresql . Driver " ) ;
String codiceFiscale = args [0];
String idBiblio = args [1];
// Creazione connessione
try (Connection con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/X","",""))
    {
        preparedStatment pst = con.preparedStatment("select idrisorsa,dataInizio,durata from prestito where idutente = ? and idbiblioteca = ?"
        pst.clearParameters();
        pst.setString(1,codiceFiscale);
        pst.setString(2,idBiblio);
        resultpst res = pst.executeQuery();
        )
    
        try
        {
            while (rs.next())
            {
                System.out.println (String . format ( " | %20 s | %20 s | %20 s | " , rs . getInt ( " idRisorsa " ) ,
                sdf. format ( rs . getDate ( " dataInizio " ) ) , (( PGInterval ) rs . getObject ( " durata " ) ) . getValue () ) ;
            }
        } 
        catch ( SQLException e ) 
        {
            System . out . println ( " Problema durante estrazione dati : " + e . getMessage () ) ;
            return;
        }
    }
}
