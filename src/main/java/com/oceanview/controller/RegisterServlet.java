package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            // Retrieving data from the JSP page
            String uname = request.getParameter("username");
            String pass = request.getParameter("password");
            String phone = request.getParameter("phone");

            String role = "Customer";

            User newUser = new User();
            newUser.setUsername(uname);
            newUser.setPassword(pass);
            newUser.setRole(role);
            newUser.setPhone(phone);

            UserDAO userDao = new UserDAO();
            boolean isRegistered = userDao.registerUser(newUser);

            if (isRegistered) {
                request.setAttribute("successMessage", "Account created successfully! You can now login.");
            } else {
                request.setAttribute("errorMessage", "Registration failed! Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Send the actual error from the database to the UI
            String exactError = (e.getMessage() != null) ? e.getMessage() : "System Error occurred!";
            request.setAttribute("errorMessage", "Database Error: " + exactError);
        }

        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}