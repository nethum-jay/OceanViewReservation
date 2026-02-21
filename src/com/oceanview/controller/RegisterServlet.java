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
        String uname = request.getParameter("username");
        String pass = request.getParameter("password");
        String role = request.getParameter("role");

        User newUser = new User();
        newUser.setUsername(uname);
        newUser.setRole(role);

        UserDAO userDao = new UserDAO();
        boolean isRegistered = userDao.registerUser(newUser, pass);

        if (isRegistered) {
            // If registration is successful, send to Login page
            request.setAttribute("successMessage", "Account created successfully! Please login.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            // If registration fails (e.g. if the name is already taken) display an error
            request.setAttribute("errorMessage", "Registration failed! Username might already exist.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}