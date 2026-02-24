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
        User user = userDao.authenticateUser(uname, pass);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedUser", user.getUsername());
            session.setAttribute("userRole", user.getRole());

            if ("Admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("adminDashboard.jsp");
            } else if ("Staff".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("staffDashboard.jsp");
            } else {
                response.sendRedirect("customerDashboard.jsp");
            }
        }
    }
}