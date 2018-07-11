/*Assumendo di avere una base di dati PostgreSQL 
che contenga le tre tabelle, scrivere un programma Java
che si interfacci alla base di dati e, dopo aver chiesto da 
input la marca ’X’, visualizzi su monitor il risultato
dell’interrogazione della domanda 2.*/

Class.forname('...');

Scanner sc = new Sccanner(System.in);
System.out.println("Inserisci marca: ");
String marca = sc.next();
sc.close();

try (Connection con = DriverManager.getConnection("..."))
{
    try (PreparedStatment pst = con.PreparedStatment(
        "
        select c.cognome,c.nome,c.paeseProvenienza
        from cliente c
        where c.npatente not in
        (
            select n.cliente
            from noleggio n
                 join auto a on n.targa = a.targa
            where a.marca ilike ?
        )"))
        {
            pst.clearParameters();
            pst.setString(1,marca);
            Resultset rs = pst.executeQuery();
            while(rs.next())
            {
                System.out.println("visualizza: " + rs.getString('nome') + rs.getString('cognome') + rs.getString('paeseProvenienza'));
            }
        }
        catch(SQLException e)
        {
            System.out.printn(e.getMessage());
        }
    ))
}