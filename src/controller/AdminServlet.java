package controller;

import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.ProjetDAO;
import dao.TacheDAO;
import dao.UserDAO;
import model.User;

@WebServlet("/admin/dashboard")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO userDAO = new UserDAO();
    private ProjetDAO projetDAO = new ProjetDAO();
    private TacheDAO tacheDAO = new TacheDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. SÉCURITÉ
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");
        if (!"ADMIN".equals(sessionUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès refusé.");
            return;
        }

        try {
            // --- 2. RÉCUPÉRATION DES 8 KPIs RÉELLES ---
            
            int totalUsers = userDAO.countUsers();
            int totalProjets = projetDAO.countProjets();
            int totalTaches = tacheDAO.countTaches();

            // KPI 4 : Taux de complétion réel
            
            int tachesTerminees = tacheDAO.countTachesByStatut("terminé");
            int tauxCompletion = (totalTaches > 0) ? (tachesTerminees * 100 / totalTaches) : 0;

            // KPI 5 : Tâches Terminées (Modifié selon votre demande)
            int kpiTachesFinies = tachesTerminees; 

            // KPI 6 : Projets en retard (Basé sur la date actuelle en DB)
            int tachesEnCours = tacheDAO.countTachesByStatut("EN_COURS");

            // KPI 7 : Équipes actives (Nombre de projets avec membres)
            int equipesActives = userDAO.countActiveTeams(); 

            // KPI 8 : Charge moyenne (Nombre de tâches par projet)
            double chargeMoyenne = (totalProjets > 0) ? (double) totalTaches / totalProjets : 0;

            // --- 3. DONNÉES POUR LES 4 GRAPHIQUES ---
            
            // Graphe 1 : Statut des Projets (Réel)
            Map<String, Integer> statsProjets = projetDAO.getProjetsStatsByStatut();
            
            // Graphe 2 : Priorités des Tâches (Réel)
            Map<String, Integer> statsPriorites = tacheDAO.getTachesStatsByPriorite();
            
            // Graphe 3 : Charge de travail Top 5 (Réel)
            Map<String, Integer> chargeTravail = userDAO.getUserWorkloadStats();

            // Graphe 4 : Statut des Tâches (Nouveau - Réel)
            Map<String, Integer> statsTachesStatut = tacheDAO.getTachesStatsByStatut();

            // --- 4. INJECTION DES ATTRIBUTS ---
            
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalProjets", totalProjets);
            request.setAttribute("totalTaches", totalTaches);
            request.setAttribute("tauxCompletion", tauxCompletion);
            request.setAttribute("tachesTerminees", kpiTachesFinies); // KPI 5
            request.setAttribute("tachesEnCours", tachesEnCours);
            request.setAttribute("equipesActives", equipesActives);
            request.setAttribute("serveurSante", String.format("%.1f", chargeMoyenne)); // KPI 8 : Détourné pour la charge

            request.setAttribute("statsProjets", statsProjets);
            request.setAttribute("statsPriorites", statsPriorites);
            request.setAttribute("chargeTravail", chargeTravail);
            request.setAttribute("statsTachesStatut", statsTachesStatut); // Graphe 4

            // --- 5. ROUTAGE ---
            request.getRequestDispatcher("/dashboardadmin.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur de chargement des données réelles.");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}