package controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.UserProjetDAO;

/**
 * Servlet gérant l'affichage et la suppression des membres dans les équipes (côté Admin)
 */
@WebServlet("/EquipeServletAdmin")
public class EquipeServletAdmin extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserProjetDAO upDAO = new UserProjetDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        // --- LOGIQUE DE SUPPRESSION ---
        if ("delete".equals(action)) {
            try {
                String userIdStr = request.getParameter("userId");
                String projetIdStr = request.getParameter("projetId");

                if (userIdStr != null && projetIdStr != null) {
                    int uid = Integer.parseInt(userIdStr);
                    int pid = Integer.parseInt(projetIdStr);
                    
                    // Exécution de la suppression dans la base de données
                    upDAO.leaveProject(uid, pid);
                }
                
                // REDIRECTION : On recharge la servlet pour rafraîchir la liste
                // On utilise request.getContextPath() pour garantir que l'URL est correcte
                response.sendRedirect(request.getContextPath() + "/EquipeServletAdmin");
                return;

            } catch (NumberFormatException e) {
                // En cas d'erreur de format d'ID, on redirige simplement
                response.sendRedirect(request.getContextPath() + "/EquipeServletAdmin");
                return;
            }
        }

        // --- LOGIQUE D'AFFICHAGE (Action par défaut) ---
        
        // 1. Récupération de la liste complète des équipes via le DAO
        List<Map<String, Object>> equipes = upDAO.getAllEquipes();
        
        // 2. On place la liste dans l'objet request pour la JSP
        request.setAttribute("equipesList", equipes);
        
        // 3. Forward vers la page JSP de gestion des équipes
        request.getRequestDispatcher("manageEquipes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirige les requêtes POST vers le GET pour simplifier
        doGet(request, response);
    }
}