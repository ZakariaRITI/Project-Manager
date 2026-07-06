package controller;

import dao.UserDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 🔹 1. Récupérer les données du form
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 🔹 2. Vérifier utilisateur
        User user = userDAO.login(email, password);

        if (user != null) {

            // 🔥 3. Créer session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("role", user.getRole());

            // 🔥 4. Redirection selon rôle
            if ("ADMIN".equals(user.getRole())) {
            	response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect("DASHBOARD.jsp");
            }

        } else {
            // ❌ login failed
            request.setAttribute("error", "Email ou mot de passe incorrect");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}