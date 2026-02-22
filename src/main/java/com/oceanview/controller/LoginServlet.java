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

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uname = request.getParameter("username");
        String pass = request.getParameter("password");

        UserDAO userDao = new UserDAO();
        User loggedInUser = userDao.authenticateUser(uname, pass);

        if (loggedInUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedUser", loggedInUser.getUsername());
            session.setAttribute("userRole", loggedInUser.getRole());
            session.setAttribute("userId", loggedInUser.getId());

            response.sendRedirect("dashboard.jsp");
        } else {
            // If login fails, return to the Login page with an Error message
            request.setAttribute("errorMessage", "Invalid Username or Password!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}