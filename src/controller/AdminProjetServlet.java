package controller;

import dao.ProjetDAO;
import model.Projet;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/manageProjets")
public class AdminProjetServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProjetDAO projetDAO = new ProjetDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "delete":
                    int idToDelete = Integer.parseInt(request.getParameter("id"));
                    projetDAO.deleteProjet(idToDelete);
                    response.sendRedirect("manageProjets?action=list");
                    break;

                case "edit":
                    int idToEdit = Integer.parseInt(request.getParameter("id"));
                    Projet existingProjet = projetDAO.getProjetById(idToEdit);
                    request.setAttribute("projet", existingProjet);
                    request.getRequestDispatcher("adminEditProjet.jsp").forward(request, response);
                    break;

                case "list":
                default:
                    List<Projet> projects = projetDAO.getAllProjets();
                    request.setAttribute("projetsList", projects);
                    request.getRequestDispatcher("manageProjets.jsp").forward(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageProjets?action=list&error=true");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                // Logique d'ajout
                Projet newP = new Projet();
                newP.setNom(request.getParameter("nom"));
                newP.setDescription(request.getParameter("description"));
                newP.setStatut(request.getParameter("statut"));
                newP.setMotDePasse(request.getParameter("motDePasse"));
                if (currentUser != null) {
                    newP.setCreatedBy(currentUser.getId());
                    projetDAO.addProjet(newP);
                }

            } else if ("update".equals(action)) {
                // ================= CODE À INSÉRER ICI =================
                int id = Integer.parseInt(request.getParameter("id"));
                
                // On charge l'objet complet depuis la BDD pour ne pas perdre 
                // la date de début, date de fin et le créateur.
                Projet p = projetDAO.getProjetById(id); 
                
                if (p != null) {
                    p.setNom(request.getParameter("nom"));
                    p.setDescription(request.getParameter("description"));
                    p.setStatut(request.getParameter("statut"));
                    p.setMotDePasse(request.getParameter("motDePasse"));
                    
                    projetDAO.updateProjet(p); 
                }
                // ======================================================
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("manageProjets?action=list");
    }
}