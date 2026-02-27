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
            User user = new User();
            user.setId(Integer.parseInt(request.getParameter("id")));
            user.setFullName(request.getParameter("fullName"));
            user.setUsername(request.getParameter("username"));
            user.setPassword(request.getParameter("password"));
            user.setEmail(request.getParameter("email"));
            user.setPhone(request.getParameter("phone"));
            user.setNic(request.getParameter("nic"));         // අලුතින් එක් කළ දත්ත
            user.setAddress(request.getParameter("address")); // අලුතින් එක් කළ දත්ත
            user.setRole(request.getParameter("role"));

            UserDAO dao = new UserDAO();
            if(dao.updateUserDetailsByAdmin(user)) {
                response.sendRedirect("ManageUsersServlet?success=Full Profile Updated");
            } else {
                response.sendRedirect("ManageUsersServlet?error=Update Failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ManageUsersServlet?error=System Error Occurred");
        }
    }
}