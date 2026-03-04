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
        String uname = request.getParameter("username");
        String pass = request.getParameter("password");

        // Server-side validation to prevent unnecessary database calls for empty inputs
        if (uname == null || uname.trim().isEmpty() || pass == null || pass.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username and Password cannot be empty.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();
        // Trimming username to avoid accidental whitespace issues
        User user = dao.authenticateUser(uname.trim(), pass);

        if (user != null) {
            // Prevent Session Fixation by invalidating the old session before creating a new one (Security Best Practice)
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }
            HttpSession session = request.getSession(true);

            // Set essential user details in the session
            session.setAttribute("loggedUser", user.getUsername());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("userId", user.getId());

            // Redirect to the relevant Dashboard according to the role
            if ("Admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("adminDashboard.jsp");
            } else if ("Staff".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("staffDashboard.jsp");
            } else {
                response.sendRedirect("customerDashboard.jsp");
            }
        } else {
            // Invalid credentials handling
            request.setAttribute("errorMessage", "Invalid Username or Password. Please try again!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}