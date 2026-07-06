package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/logout") // URL spécifique pour l'admin
public class AdminLogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Un lien <a> envoie du GET, on traite donc ici
        processLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Au cas où vous utiliseriez un bouton/formulaire
        processLogout(request, response);
    }

    private void processLogout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // 1. Récupérer la session sans en créer une nouvelle
        HttpSession session = request.getSession(false);

        if (session != null) {
            // Optionnel : Supprimer uniquement les attributs liés à l'admin
            // session.removeAttribute("adminUser"); 
            
            // 2. Détruire complètement la session
            session.invalidate();
        }

        // 3. Empêcher le bouton "Précédent" du navigateur (Cache)
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
        response.setHeader("Pragma", "no-cache"); 
        response.setDateHeader("Expires", 0);

        // 4. Redirection vers la page de login de votre choix
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}