package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String oldUsername = (String) session.getAttribute("loggedUser");

        // Getting all parameters
        String newUsername = request.getParameter("username");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String fullName = request.getParameter("fullName");
        String nic = request.getParameter("nic");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        UserDAO userDAO = new UserDAO();
        boolean success = userDAO.updateFullProfile(oldUsername, newUsername, password, phone, fullName, nic, email, address);

        if (success) {
            session.setAttribute("loggedUser", newUsername);
            request.setAttribute("successMessage", "Profile updated successfully!");
        } else {
            request.setAttribute("errorMessage", "Update failed!");
        }
        request.getRequestDispatcher("userProfile.jsp").forward(request, response);
    }
}