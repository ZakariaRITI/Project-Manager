package dao;

import model.Tache;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TacheDAO {

    // ➤ GET TASKS BY PROJECT
    public List<Tache> getTachesByProjet(int projetId) {

        List<Tache> list = new ArrayList<>();

        String sql = "SELECT * FROM tache WHERE projet_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, projetId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Tache t = new Tache();

                t.setId(rs.getInt("id"));
                t.setNom(rs.getString("nom"));
                t.setDescription(rs.getString("description"));
                t.setStatut(rs.getString("statut"));
                t.setPriorite(rs.getString("priorite"));
                t.setProjetId(rs.getInt("projet_id"));

                list.add(t);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ➤ ADD TASK
    public void addTache(Tache t) {

        String sql = "INSERT INTO tache(nom, description, statut, priorite, projet_id) VALUES(?,?,?,?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, t.getNom());
            ps.setString(2, t.getDescription());
            ps.setString(3, t.getStatut());
            ps.setString(4, t.getPriorite());
            ps.setInt(5, t.getProjetId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ➤ UPDATE STATUS TACHE
    public void updateStatus(int tacheId, String status) {

        String sql = "UPDATE tache SET statut=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, tacheId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ➤ UPDATE STATUS PROJET
    public void updateProjectStatus(int projetId, String status) {

        String sql = "UPDATE projet SET statut=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, projetId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
 // ➤ DELETE TASK
    public void deleteTache(int id) {

        String sql = "DELETE FROM tache WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
 // ➤ GET TASK BY ID (pour modifier)
    public Tache getTacheById(int id) {

        String sql = "SELECT * FROM tache WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Tache t = new Tache();

                t.setId(rs.getInt("id"));
                t.setNom(rs.getString("nom"));
                t.setDescription(rs.getString("description"));
                t.setStatut(rs.getString("statut"));
                t.setPriorite(rs.getString("priorite"));
                t.setProjetId(rs.getInt("projet_id"));

                return t;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
 // ➤ UPDATE TASK (modifier tâche)
    public void updateTache(Tache t) {

        String sql = "UPDATE tache SET nom=?, description=?, priorite=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, t.getNom());
            ps.setString(2, t.getDescription());
            ps.setString(3, t.getPriorite());
            ps.setInt(4, t.getId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public int countTaches() {
        String sql = "SELECT COUNT(*) FROM tache";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
 // 1. Compter par statut (pour le KPI %)
    public int countTachesByStatut(String statut) {
        // Utilisation de LOWER() pour comparer sans se soucier des majuscules
        String sql = "SELECT COUNT(*) FROM tache WHERE LOWER(statut) = LOWER(?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, statut.trim()); // trim() enlève les espaces vides accidentels
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // 2. Statistiques par priorité (pour le Bar Chart)
    public Map<String, Integer> getTachesStatsByPriorite() {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT priorite, COUNT(*) as total FROM tache GROUP BY priorite";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                stats.put(rs.getString("priorite"), rs.getInt("total"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return stats;
    }
 // Pour le KPI 5 : Tâches Urgentes
    public int countTachesByPriorite(String priorite) {
        String sql = "SELECT COUNT(*) FROM tache WHERE priorite = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, priorite);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
    public Map<String, Integer> getTachesStatsByStatut() {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT statut, COUNT(*) as total FROM tache GROUP BY statut";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                stats.put(rs.getString("statut"), rs.getInt("total"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return stats;
    }
}