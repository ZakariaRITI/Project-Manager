package dao;

import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserProjetDAO {

    private Connection con = DBConnection.getConnection();

    // ➤ JOIN PROJECT
    public void joinProject(int userId, int projetId) {
        try {
            String sql = "INSERT INTO user_projet(user_id, projet_id) VALUES(?,?)";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setInt(2, projetId);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
 // ➤ RÉCUPÉRER TOUS LES MEMBRES ET LEURS PROJETS
    public List<Map<String, Object>> getAllEquipes() {
        List<Map<String, Object>> Equipes = new ArrayList<>();
        String sql = "SELECT u.id as userId, u.nom, u.prenom, p.id as projetId, p.nom as projetNom " +
                     "FROM user_projet up " +
                     "JOIN user u ON up.user_id = u.id " +
                     "JOIN projet p ON up.projet_id = p.id " +
                     "ORDER BY p.nom";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> ligne = new HashMap<>();
                ligne.put("userId", rs.getInt("userId"));
                ligne.put("userName", rs.getString("prenom") + " " + rs.getString("nom"));
                ligne.put("projetId", rs.getInt("projetId"));
                ligne.put("projetNom", rs.getString("projetNom"));
                Equipes.add(ligne);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return Equipes;
    }

    // ➤ RETIRER UN MEMBRE D'UN PROJET
    public void leaveProject(int userId, int projetId) {
        String sql = "DELETE FROM user_projet WHERE user_id = ? AND projet_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, projetId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}
