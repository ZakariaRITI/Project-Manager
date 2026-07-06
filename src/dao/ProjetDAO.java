package dao;

import model.Projet;
import util.DBConnection;

import java.sql.*;
import java.util.*;

public class ProjetDAO {

    // ===================== ADD PROJET =====================
    public void addProjet(Projet p) {

        String sql = "INSERT INTO projet(nom, description, date_debut, date_fin, statut, created_by, mot_de_passe) "
                   + "VALUES(?,?,?,?,?,?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, p.getNom());
            ps.setString(2, p.getDescription());
            ps.setDate(3, p.getDateDebut());
            ps.setDate(4, p.getDateFin());
            ps.setString(5, p.getStatut());
            ps.setInt(6, p.getCreatedBy());

            // 🔐 mot de passe (nullable)
            ps.setString(7, p.getMotDePasse());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===================== GET PROJETS BY USER =====================
    public List<Projet> getProjetsByUser(int userId) {

        List<Projet> list = new ArrayList<>();

        String sql = "SELECT p.* FROM projet p "
                   + "JOIN user_projet up ON p.id = up.projet_id "
                   + "WHERE up.user_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Projet p = new Projet();
                p.setId(rs.getInt("id"));
                p.setNom(rs.getString("nom"));
                p.setDescription(rs.getString("description"));
                p.setStatut(rs.getString("statut"));
                p.setMotDePasse(rs.getString("mot_de_passe"));
                p.setCreatedBy(rs.getInt("created_by"));
                
                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ===================== UPDATE PROJET =====================
    public void updateProjet(Projet p) {

        String sql = "UPDATE projet SET nom=?, description=?, statut=?, mot_de_passe=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, p.getNom());
            ps.setString(2, p.getDescription());
            ps.setString(3, p.getStatut());
            ps.setString(4, p.getMotDePasse());
            ps.setInt(5, p.getId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===================== DELETE PROJET =====================
    public void deleteProjet(int id) {

        String sql = "DELETE FROM projet WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===================== ADD USER TO PROJECT =====================
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

    // ===================== GET LAST ID =====================
    public int getLastInsertedId() {

        String sql = "SELECT MAX(id) AS id FROM projet";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("id");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    // ===================== GET ALL PROJETS =====================
    public List<Projet> getAllProjets() {

        List<Projet> list = new ArrayList<>();

        String sql = "SELECT * FROM projet ORDER BY id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Projet p = new Projet();
                p.setId(rs.getInt("id"));
                p.setNom(rs.getString("nom"));
                p.setDescription(rs.getString("description"));
                p.setStatut(rs.getString("statut"));
                p.setMotDePasse(rs.getString("mot_de_passe"));
                p.setCreatedBy(rs.getInt("created_by"));
                
                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ===================== GET BY ID =====================
    public Projet getProjetById(int id) {

        String sql = "SELECT * FROM projet WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Projet p = new Projet();
                p.setId(rs.getInt("id"));
                p.setNom(rs.getString("nom"));
                p.setDescription(rs.getString("description"));
                p.setStatut(rs.getString("statut"));
                p.setDateDebut(rs.getDate("date_debut"));
                p.setDateFin(rs.getDate("date_fin"));
                p.setCreatedBy(rs.getInt("created_by"));
                p.setMotDePasse(rs.getString("mot_de_passe"));

                return p;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // ===================== JOIN PROJET =====================
    public void joinProjet(int userId, int projetId) {

        String sql =
            "INSERT INTO user_projet(user_id, projet_id) " +
            "SELECT ?, ? WHERE NOT EXISTS (" +
            "SELECT 1 FROM user_projet WHERE user_id=? AND projet_id=?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, projetId);
            ps.setInt(3, userId);
            ps.setInt(4, projetId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===================== CHECK USER IN PROJECT =====================
    public boolean isUserInProjet(int userId, int projetId) {

        String sql = "SELECT 1 FROM user_projet WHERE user_id=? AND projet_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, projetId);

            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ===================== PROJETS + MEMBERS =====================
    public List<Map<String, Object>> getProjetsAvecMembres() {

        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
            "SELECT p.id as projetId, p.nom as projetNom, " +
            "u.id as userId, u.prenom, u.email " +
            "FROM projet p " +
            "JOIN user_projet up ON p.id = up.projet_id " +
            "JOIN user u ON u.id = up.user_id " +
            "ORDER BY p.id";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Map<String, Object> row = new HashMap<>();

                row.put("projetId", rs.getInt("projetId"));
                row.put("projetNom", rs.getString("projetNom"));
                row.put("userId", rs.getInt("userId"));
                row.put("prenom", rs.getString("prenom"));
                row.put("email", rs.getString("email"));

                list.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ===================== PROJETS OF USER WITH MEMBERS =====================
    public List<Map<String, Object>> getProjetsAvecMembresByUser(int userId) {

        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
            "SELECT p.id AS projetId, p.nom AS projetNom, u.id AS userId, u.prenom, u.email " +
            "FROM projet p " +
            "JOIN user_projet up ON p.id = up.projet_id " +
            "JOIN user u ON u.id = up.user_id " +
            "WHERE p.id IN (SELECT projet_id FROM user_projet WHERE user_id = ?) " +
            "ORDER BY p.id";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Map<String, Object> row = new HashMap<>();
                row.put("projetId", rs.getInt("projetId"));
                row.put("projetNom", rs.getString("projetNom"));
                row.put("userId", rs.getInt("userId"));
                row.put("prenom", rs.getString("prenom"));
                row.put("email", rs.getString("email"));

                list.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public void removeUserFromProject(int userId, int projetId) {
        String sql = "DELETE FROM user_projet  WHERE user_id = ? AND projet_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, projetId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public int countProjets() {
        String sql = "SELECT COUNT(*) FROM projet";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // Pour le graphique : répartition par statut
    public Map<String, Integer> getProjetsStatsByStatut() {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT statut, COUNT(*) as total FROM projet GROUP BY statut";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                stats.put(rs.getString("statut"), rs.getInt("total"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return stats;
    }
 // Pour le KPI 6 : Projets en retard
    public int countProjetsEnRetard() {
        // Un projet est en retard si date_fin < aujourd'hui ET statut != 'Terminé'
        String sql = "SELECT COUNT(*) FROM projet WHERE date_fin < CURRENT_DATE AND statut != 'Terminé'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // Pour le Graphe 4 : Activité mensuelle (Nombre de projets créés par mois)
    public Map<String, Integer> getMonthlyActivityStats() {
        Map<String, Integer> stats = new LinkedHashMap<>();
        String sql = "SELECT TO_CHAR(date_debut, 'Mon') as mois, COUNT(*) as total " +
                     "FROM projet GROUP BY mois ORDER BY MIN(date_debut)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                stats.put(rs.getString("mois"), rs.getInt("total"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return stats;
    }

    // Pour la Vue Globale : Récupérer les X derniers projets
    public List<Projet> getRecentProjets(int limit) {
        List<Projet> list = new ArrayList<>();
        String sql = "SELECT * FROM projet ORDER BY id DESC LIMIT ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Projet p = new Projet();
                p.setId(rs.getInt("id"));
                p.setNom(rs.getString("nom"));
                p.setDateFin(rs.getDate("date_fin"));
                p.setStatut(rs.getString("statut"));
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}