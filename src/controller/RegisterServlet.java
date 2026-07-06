package controller;

import dao.UserDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 🔹 récupérer les données du formulaire
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 🔹 créer user
        User user = new User();
        user.setNom(nom);
        user.setPrenom(prenom);
        user.setEmail(email);
        user.setPassword(password);
        user.setRole("USER");

        try {
            // 🔹 insertion DB
            userDAO.addUser(user);

            // 🔹 redirection login
            response.sendRedirect("login.jsp");

        } catch (Exception e) {
            e.printStackTrace();

            // erreur → retour register
            request.setAttribute("error", "Erreur lors de l'inscription");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}