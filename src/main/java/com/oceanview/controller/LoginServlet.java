package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieving data from a form
        String uname = request.getParameter("username");
        String pass = request.getParameter("password");

        // Comparing with Database via UserDAO
        UserDAO dao = new UserDAO();
        User user = dao.authenticateUser(uname, pass);

        if (user != null) {
            // If the login is successful, set the session.
            HttpSession session = request.getSession();
            session.setAttribute("loggedUser", user.getUsername());
            session.setAttribute("userRole", user.getRole());

            // To prevent "null" from showing up in the Dashboard, the User ID must be entered like this.
            session.setAttribute("userId", user.getId());

            // Redirect to the relevant Dashboard according to the role
            // Using 'equalsIgnoreCase' avoids errors caused by case sensitivity.
            if ("Admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("adminDashboard.jsp");
            } else if ("Staff".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("staffDashboard.jsp");
            } else {
                response.sendRedirect("customerDashboard.jsp");
            }
        } else {
            // Create an Error Message and Forward it to the Login Page
            request.setAttribute("errorMessage", "Invalid Username or Password. Please try again!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}