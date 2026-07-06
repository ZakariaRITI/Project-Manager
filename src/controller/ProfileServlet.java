package controller;

import dao.UserDAO;
import model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    // 📌 AFFICHER PROFILE
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    // 📌 UPDATE EMAIL / PASSWORD
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 🔥 update email si rempli
        if (email != null && !email.trim().isEmpty()) {
            user.setEmail(email);
        }

        // 🔥 update password si rempli
        if (password != null && !password.trim().isEmpty()) {
            user.setPassword(password);
        }

        // 🔥 update DB
        userDAO.updateProfile(user.getId(), user.getEmail(), user.getPassword());

        // 🔥 update session
        session.setAttribute("user", user);

        response.sendRedirect("ProfileServlet");
    }
}