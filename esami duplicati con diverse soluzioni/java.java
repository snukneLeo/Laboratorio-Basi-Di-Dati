import sql.*;
import SimpleDateFormat.*;

public static void main(String [] args) throws ClassNotFoundException,SQLException
{
    Class.forName("org.postgresql.Driver");
    String nome = args[0];
    String codicefiscale = args[1];
    String data = args[2];

    SimpleDateFormat sdf = new SimpleDateFormat('dd/MM/yyyy');
    Date d = new Date(sdf.parse(data).getTime());

    try(Connection con = DriverManager.getConnection("jdbc:postgres://localhost/suamamma/popo","user","password"))
    {
        try(PreparedStatment pst = con.PrepareStatment("select nome,cognome from cristiano where bambino = ? and codfiscale = ? and data = ?"));
        {
            pst.clearParameters();
            pst.setString(1,nome);
            pst.setString(2,codicefiscale);
            pst.setDate(3,d);

            ResultSet rs = pst.executeQuery();
            while(rs.next())
            {
                System.out.println(rs.getString('nome') + " " + rs.getString('cognome') + " " +sdf.format(rs.getDate('datainizio')));
            }
        }
        catch(SQLException e)
        {
            System.out.println(e.getMessage());
        }
    }
    catch(SQLException e)
    {
        System.out.println(e.getMessage());
    }
} 