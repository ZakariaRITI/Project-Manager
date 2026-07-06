package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 🔹 1. Récupérer la session
        HttpSession session = request.getSession(false);

        // 🔹 2. Détruire la session si elle existe
        if (session != null) {
            session.invalidate();
        }

        // 🔹 3. Redirection vers login
        response.sendRedirect("login.jsp");
    }
}