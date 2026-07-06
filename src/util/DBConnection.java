package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static Connection connection;

    // Infos base de données
    private static final String URL = "jdbc:mysql://localhost:3306/projet_jee";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // mets ton mot de passe MySQL si besoin

    // Méthode pour obtenir la connexion
    public static Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(URL, USER, PASSWORD);
                System.out.println("✔ Connexion DB réussie !");
            }
        } catch (ClassNotFoundException e) {
            System.out.println("❌ Driver JDBC introuvable");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("❌ Erreur connexion DB");
            e.printStackTrace();
        }
        return connection;
    }
}