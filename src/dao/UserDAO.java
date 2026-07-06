package dao;

import model.User;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class UserDAO {

    // ➤ CREATE
    public void addUser(User u) {

        String sql = "INSERT INTO user(nom, prenom, email, password, role) VALUES(?,?,?,?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, u.getNom());
            ps.setString(2, u.getPrenom());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getPassword());
            ps.setString(5, u.getRole());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ➤ LOGIN
    public User login(String email, String password) {

        User user = null;
        String sql = "SELECT * FROM user WHERE email=? AND password=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setNom(rs.getString("nom"));
                user.setPrenom(rs.getString("prenom"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

    // ➤ READ ALL
    public List<User> getAllUsers() {

        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM user";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setNom(rs.getString("nom"));
                u.setPrenom(rs.getString("prenom"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));

                list.add(u);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ➤ DELETE
    public void deleteUser(int id) {

        String sql = "DELETE FROM user WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ➤ ADD USER TO PROJECT
    public void addUserToProject(int userId, int projetId) {

        String sql = "INSERT INTO user_projet(user_id, projet_id) VALUES(?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, projetId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ➤ UPDATE PROFILE
    public void updateProfile(int id, String email, String password) {

        String sql = "UPDATE user SET email = ?, password = ? WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);
            ps.setInt(3, id);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
 // Dans UserDAO.java
    public void updateUserAdmin(User u) {
        String sql = "UPDATE user SET nom=?, prenom=?, email=?, role=? WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, u.getNom());
            ps.setString(2, u.getPrenom());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getRole());
            ps.setInt(5, u.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public int countUsers() {
        String sql = "SELECT COUNT(*) FROM user";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
 // Pour le KPI 7 : Nombre d'équipes (basé sur les projets ayant des membres)
    public int countActiveTeams() {
        String sql = "SELECT COUNT(DISTINCT projet_id) FROM user_projet";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // Pour le Graphe 3 : Nombre de tâches par utilisateur (Top 5)
    public Map<String, Integer> getUserWorkloadStats() {
        Map<String, Integer> stats = new LinkedHashMap<>();
        // Note : Cette requête nécessite que tes tâches soient liées à un utilisateur (ex: colonne assigned_to)
        // Si tu n'as pas encore cette colonne, on simule par le nombre de projets rejoints :
        String sql = "SELECT u.prenom, COUNT(up.projet_id) as total " +
                     "FROM user u JOIN user_projet up ON u.id = up.user_id " +
                     "GROUP BY u.id, u.prenom ORDER BY total DESC LIMIT 5";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                stats.put(rs.getString("prenom"), rs.getInt("total"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return stats;
    }
}