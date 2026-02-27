package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // For security purposes, get the name of the currently logged in user from the session.
        HttpSession session = request.getSession();
        String loggedUsername = (String) session.getAttribute("loggedUser");

        if (loggedUsername == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get other data sent from the form
        // Username cannot be edited, so it is used by the session itself
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String nic = request.getParameter("nic");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        // Updating the Database via UserDAO
        UserDAO dao = new UserDAO();

        // Returns 'loggedUsername' for both the old name and the new name (since the name doesn't change)
        boolean isUpdated = dao.updateFullProfile(loggedUsername, loggedUsername, password, phone, fullName, nic, email, address);

        // Setting messages to indicate success/failure
        if (isUpdated) {
            request.setAttribute("successMessage", "Profile updated successfully! Database is now synced.");
        } else {
            request.setAttribute("errorMessage", "Failed to update profile. Please check database connection.");
        }

        // Forward to the Profile page
        request.getRequestDispatcher("userProfile.jsp").forward(request, response);
    }
}