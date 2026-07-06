package controller;

import dao.ProjetDAO;
import model.Projet;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ProjetServlet")
public class ProjetServlet extends HttpServlet {

    private ProjetDAO projetDAO;

    @Override
    public void init() {
        projetDAO = new ProjetDAO();
    }

    // ================= GET =================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String page = request.getParameter("page");

        try {

            // ================= DELETE =================
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                projetDAO.deleteProjet(id);
                response.sendRedirect("ProjetServlet");
                return;
            }

            // ================= EDIT =================
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));

                Projet projet = projetDAO.getProjetById(id);

                request.setAttribute("projet", projet);
                request.getRequestDispatcher("editProjet.jsp").forward(request, response);
                return;
            }

            // ================= LIST =================
            List<Projet> projets = projetDAO.getProjetsByUser(user.getId());
            request.setAttribute("projets", projets);

            if ("dashboard".equals(page)) {
                request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("mesProjets.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= POST =================
 // ================= POST =================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Récupération des paramètres communs
        String action = request.getParameter("action");
        String idStr = request.getParameter("id"); // Présent uniquement lors de la modif
        String nom = request.getParameter("nom");
        String desc = request.getParameter("description");
        String motDePasse = request.getParameter("motDePasse");
        String statut = request.getParameter("statut");

        try {
            // --- 1. ACTION : REJOINDRE UN PROJET ---
            if ("join".equals(action)) {
                int projetId = Integer.parseInt(request.getParameter("projetId"));
                Projet projet = projetDAO.getProjetById(projetId);

                if (projet.getMotDePasse() != null && !projet.getMotDePasse().isEmpty()) {
                    if (!projet.getMotDePasse().equals(motDePasse)) {
                        session.setAttribute("error", "❌ Mot de passe incorrect !");
                        response.sendRedirect("DASHBOARD.jsp");
                        return;
                    }
                }

                if (!projetDAO.isUserInProjet(user.getId(), projetId)) {
                    projetDAO.addUserToProject(user.getId(), projetId);
                }
                session.setAttribute("success", "✔ Projet rejoint !");
                response.sendRedirect("DASHBOARD.jsp");
                return;
            }

            // --- 2. ACTION : MODIFIER (Si un ID est présent) ---
            if (idStr != null && !idStr.trim().isEmpty()) {
                int id = Integer.parseInt(idStr);
                
                Projet p = new Projet();
                p.setId(id);
                p.setNom(nom);
                p.setDescription(desc);
                p.setStatut(statut);
                // Si mdp vide, on peut décider de garder l'ancien ou mettre null
                p.setMotDePasse((motDePasse != null && !motDePasse.trim().isEmpty()) ? motDePasse : null);

                projetDAO.updateProjet(p);
                response.sendRedirect("ProjetServlet");
                return;
            }

            // --- 3. ACTION : CRÉER (Si pas d'ID mais un nom présent) ---
            if (nom != null && !nom.trim().isEmpty()) {
                Projet p = new Projet();
                p.setNom(nom);
                p.setDescription(desc);
                p.setStatut("EN_COURS");
                p.setCreatedBy(user.getId());
                p.setMotDePasse((motDePasse != null && !motDePasse.trim().isEmpty()) ? motDePasse : null);

                projetDAO.addProjet(p);
                
                // Associer automatiquement le créateur au projet
                int newId = projetDAO.getLastInsertedId();
                projetDAO.addUserToProject(user.getId(), newId);

                response.sendRedirect("ProjetServlet");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ProjetServlet?error=true");
        }
    }
}