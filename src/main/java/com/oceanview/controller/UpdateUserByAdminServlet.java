package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/UpdateUserByAdminServlet")
public class UpdateUserByAdminServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String username = request.getParameter("username");
            String pass = request.getParameter("password");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");

            User u = new User();
            u.setId(id);
            u.setUsername(username);
            u.setPassword(pass);
            u.setPhone(phone);
            u.setRole(role);

            UserDAO dao = new UserDAO();
            dao.updateUserDetailsByAdmin(u);

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Sending back to the list after the update
        response.sendRedirect("ManageUsersServlet");
    }
}