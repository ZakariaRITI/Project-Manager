package controller;

import dao.UserDAO;
import model.User;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
    
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    // Méthode utilitaire pour vérifier si l'utilisateur est Admin
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        return currentUser != null && "ADMIN".equals(currentUser.getRole());
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // --- SÉCURITÉ : Bloquer si pas Admin ---
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "delete":
                supprimerUtilisateur(request, response);
                break;
            case "editPage":
                preparerModification(request, response);
                break;
            case "list":
            default:
                afficherListe(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            ajouterUtilisateur(request, response);
        } else if ("update".equals(action)) {
            enregistrerModification(request, response);
        }
    }

    // --- MÉTHODES PRIVÉES ---

    private void afficherListe(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<User> listUsers = userDAO.getAllUsers();
        request.setAttribute("usersList", listUsers);
        request.getRequestDispatcher("/gestion-users.jsp").forward(request, response);
    }

    private void ajouterUtilisateur(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        User newUser = new User(0, 
            request.getParameter("nom"), 
            request.getParameter("prenom"), 
            request.getParameter("email"), 
            request.getParameter("password"), 
            request.getParameter("role"));
        userDAO.addUser(newUser);
        response.sendRedirect("UserServlet?action=list");
    }

    private void supprimerUtilisateur(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession();
        User adminConnecte = (User) session.getAttribute("user");
        int idASupprimer = Integer.parseInt(request.getParameter("id"));

        // --- SÉCURITÉ LOGIQUE : Ne pas se supprimer soi-même ---
        if (adminConnecte != null && adminConnecte.getId() == idASupprimer) {
            // On redirige avec un message d'erreur (optionnel)
            response.sendRedirect("UserServlet?action=list&error=selfdelete");
            return;
        }

        userDAO.deleteUser(idASupprimer);
        response.sendRedirect("UserServlet?action=list");
    }

    private void preparerModification(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        
        User userFound = userDAO.getAllUsers().stream()
                            .filter(u -> u.getId() == id)
                            .findFirst()
                            .orElse(null);

        request.setAttribute("userToEdit", userFound);
        request.getRequestDispatcher("/modifier-user.jsp").forward(request, response);
    }

    private void enregistrerModification(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession();
        User adminConnecte = (User) session.getAttribute("user");
        
        int idModif = Integer.parseInt(request.getParameter("id"));
        String nouveauRole = request.getParameter("role");

        // --- SÉCURITÉ LOGIQUE : Un admin ne peut pas changer son propre rôle ---
        // (Pour éviter de perdre ses accès par erreur)
        if (adminConnecte != null && adminConnecte.getId() == idModif && !"ADMIN".equals(nouveauRole)) {
            response.sendRedirect("UserServlet?action=list&error=selfrolechange");
            return;
        }

        User u = new User();
        u.setId(idModif);
        u.setNom(request.getParameter("nom"));
        u.setPrenom(request.getParameter("prenom"));
        u.setEmail(request.getParameter("email"));
        u.setRole(nouveauRole);

        userDAO.updateUserAdmin(u);
        response.sendRedirect("UserServlet?action=list");
    }
}