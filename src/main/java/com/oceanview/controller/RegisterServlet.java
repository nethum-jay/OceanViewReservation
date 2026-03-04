package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");

        // Server-side validation to prevent empty submissions
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required. Please check your inputs.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();

            // Check if the phone number is already registered
            if (userDAO.isUserExists(phone.trim())) {
                request.setAttribute("errorMessage", "Registration Failed! This Phone Number is already registered.");
            } else {

                // Register the new user
                User newUser = new User();
                newUser.setUsername(username.trim());
                newUser.setPassword(password); // Passwords are usually not trimmed to keep exact user input
                newUser.setRole("Customer");
                newUser.setPhone(phone.trim());

                boolean isRegistered = userDAO.registerUser(newUser);

                if (isRegistered) {
                    request.setAttribute("successMessage", "Registration Successful! You can now login to your account.");
                } else {
                    request.setAttribute("errorMessage", "An error occurred during registration. Please try again.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database Error: Please try again later.");
        }

        // Centralized forward to the JSP page
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}