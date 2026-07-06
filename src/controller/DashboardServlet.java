package controller;

import dao.ProjetDAO;
import dao.TacheDAO;
import model.Projet;
import model.Tache;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    private ProjetDAO projetDAO;
    private TacheDAO tacheDAO;

    @Override
    public void init() {
        projetDAO = new ProjetDAO();
        tacheDAO = new TacheDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Projet> projets = projetDAO.getProjetsByUser(user.getId());

        int totalProjets = projets.size();
        int enCours = 0;
        int termine = 0;
        int attente = 0;

        int totalTaches = 0;
        int tachesTerminees = 0;
        int tachesEnCours = 0;
        int tachesAFaire = 0;

        for (Projet p : projets) {

            if ("EN_COURS".equals(p.getStatut())) enCours++;
            else if ("TERMINE".equals(p.getStatut())) termine++;
            else attente++;

            List<Tache> taches = tacheDAO.getTachesByProjet(p.getId());

            totalTaches += taches.size();

            for (Tache t : taches) {
                if ("TERMINE".equals(t.getStatut())) tachesTerminees++;
                else if ("EN_COURS".equals(t.getStatut())) tachesEnCours++;
                else tachesAFaire++;
            }
        }

        request.setAttribute("projets", projets);

        request.setAttribute("totalProjets", totalProjets);
        request.setAttribute("enCours", enCours);
        request.setAttribute("termine", termine);
        request.setAttribute("attente", attente);

        request.setAttribute("totalTaches", totalTaches);
        request.setAttribute("tachesTerminees", tachesTerminees);
        request.setAttribute("tachesEnCours", tachesEnCours);
        request.setAttribute("tachesAFaire", tachesAFaire);

        request.getRequestDispatcher("tableauDeBord.jsp").forward(request, response);
    }
}