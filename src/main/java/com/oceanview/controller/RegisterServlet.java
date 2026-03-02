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

        UserDAO userDAO = new UserDAO();

        // Checks if this phone number is already taken (not the username)
        if (userDAO.isUserExists(phone)) {
            // If there is, an error message is sent (the data is not saved to the database).
            request.setAttribute("errorMessage", "Registration Failed! This Phone Number is already registered.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // A new number is entered into the database.
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setRole("Customer");
        newUser.setPhone(phone);

        boolean isRegistered = false;
        try {
            isRegistered = userDAO.registerUser(newUser);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Database Error: Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (isRegistered) {
            request.setAttribute("successMessage", "Registration Successful! You can now login to your account.");
        } else {
            request.setAttribute("errorMessage", "An error occurred during registration. Please try again.");
        }

        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}