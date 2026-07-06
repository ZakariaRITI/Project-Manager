package controller;

import dao.ProjetDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/EquipeServlet")
public class EquipeServlet extends HttpServlet {

    private ProjetDAO projetDAO;

    @Override
    public void init() {
        projetDAO = new ProjetDAO();
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

        try {

            List<Map<String, Object>> data =
                    projetDAO.getProjetsAvecMembresByUser(user.getId());

            request.setAttribute("data", data);

            request.getRequestDispatcher("equipe.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {

            // ================= QUITTER PROJET =================
            if ("leave".equals(action)) {

                int projetId = Integer.parseInt(request.getParameter("projetId"));

                projetDAO.removeUserFromProject(user.getId(), projetId);

                session.setAttribute("success", "✔ Vous avez quitté le projet !");
                response.sendRedirect("EquipeServlet");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}