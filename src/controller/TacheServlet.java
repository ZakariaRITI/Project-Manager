package controller;

import dao.TacheDAO;
import model.Tache;
import dao.ProjetDAO;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/TacheServlet")
public class TacheServlet extends HttpServlet {

    private TacheDAO tacheDAO;

    @Override
    public void init() {
        tacheDAO = new TacheDAO();
    }

    // =========================
    // 📌 GET
    // =========================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String updateStatus = request.getParameter("updateStatus");
        String status = request.getParameter("status");
        String deleteId = request.getParameter("delete");
        String editId = request.getParameter("edit");
        String projetIdStr = request.getParameter("projetId");

        // =========================
        // 🔥 UPDATE STATUS
        // =========================
        if (updateStatus != null && status != null && projetIdStr != null) {

            int tacheId = Integer.parseInt(updateStatus);
            int projetId = Integer.parseInt(projetIdStr);

            tacheDAO.updateStatus(tacheId, status);

            updateProjectProgress(projetId);

            response.sendRedirect("TacheServlet?projetId=" + projetId);
            return;
        }

        // =========================
        // 🗑️ DELETE TASK
        // =========================
        if (deleteId != null && projetIdStr != null) {

            int tacheId = Integer.parseInt(deleteId);
            int projetId = Integer.parseInt(projetIdStr);

            tacheDAO.deleteTache(tacheId);

            updateProjectProgress(projetId);

            response.sendRedirect("TacheServlet?projetId=" + projetId);
            return;
        }

        // =========================
        // ✏️ EDIT TASK (ouvrir form)
        // =========================
        if (editId != null) {

            int tacheId = Integer.parseInt(editId);

            Tache tache = tacheDAO.getTacheById(tacheId);

            request.setAttribute("tache", tache);

            request.getRequestDispatcher("editTache.jsp").forward(request, response);
            return;
        }

        // =========================
        // 📊 AFFICHAGE
        // =========================
        if (projetIdStr != null) {

            int projetId = Integer.parseInt(projetIdStr);

            // 1. Récupérer les tâches
            List<Tache> taches = tacheDAO.getTachesByProjet(projetId);

            // 2. RÉCUPÉRER L'OBJET PROJET (C'est l'ajout crucial !)
            ProjetDAO projetDAO = new ProjetDAO(); 
            model.Projet projet = projetDAO.getProjetById(projetId);

            // 3. Calculer la progression et mettre à jour le statut
            int progress = calculateProgress(taches);
            updateProjectStatus(projetId, progress);

            // 4. Envoyer TOUTES les données à la JSP
            request.setAttribute("taches", taches);
            request.setAttribute("projetId", projetId);
            request.setAttribute("progress", progress);
            
            // On envoie enfin l'objet projet (qui contient le CreatedBy)
            request.setAttribute("projet", projet); 

            request.getRequestDispatcher("taches.jsp").forward(request, response);
        }
    }

    // =========================
    // 📌 POST
    // =========================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // =========================
        // ➕ ADD TASK
        // =========================
        if (action == null || action.equals("add")) {

            int projetId = Integer.parseInt(request.getParameter("projetId"));

            Tache t = new Tache();
            t.setNom(request.getParameter("nom"));
            t.setDescription(request.getParameter("description"));
            t.setStatut("A_FAIRE");
            t.setPriorite(request.getParameter("priorite"));
            t.setProjetId(projetId);

            tacheDAO.addTache(t);

            updateProjectProgress(projetId);

            response.sendRedirect("TacheServlet?projetId=" + projetId);
            return;
        }

        // =========================
        // ✏️ UPDATE TASK
        // =========================
        if (action.equals("update")) {

            int id = Integer.parseInt(request.getParameter("id"));
            int projetId = Integer.parseInt(request.getParameter("projetId"));

            Tache t = new Tache();
            t.setId(id);
            t.setNom(request.getParameter("nom"));
            t.setDescription(request.getParameter("description"));
            t.setPriorite(request.getParameter("priorite"));

            tacheDAO.updateTache(t);

            updateProjectProgress(projetId);

            response.sendRedirect("TacheServlet?projetId=" + projetId);
        }
    }

    // =========================
    // 📊 PROGRESSION
    // =========================
    private int calculateProgress(List<Tache> taches) {

        int total = taches.size();
        int done = 0;

        for (Tache t : taches) {
            if ("TERMINE".equals(t.getStatut())) {
                done++;
            }
        }

        return (total > 0) ? (done * 100) / total : 0;
    }

    // =========================
    // 🔄 UPDATE PROJET
    // =========================
    private void updateProjectProgress(int projetId) {

        List<Tache> taches = tacheDAO.getTachesByProjet(projetId);
        int progress = calculateProgress(taches);

        updateProjectStatus(projetId, progress);
    }

    private void updateProjectStatus(int projetId, int progress) {

        if (progress == 100) {
            tacheDAO.updateProjectStatus(projetId, "TERMINE");
        } else {
            tacheDAO.updateProjectStatus(projetId, "EN_COURS");
        }
    }
}