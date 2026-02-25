package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/UpdateUserByAdminServlet")
public class UpdateUserByAdminServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Getting data from the form
            int id = Integer.parseInt(request.getParameter("id"));
            String fullName = request.getParameter("fullName");
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");

            UserDAO dao = new UserDAO();
            boolean success = dao.updateUserByAdmin(id, fullName, username, role, email, phone);

            if (success) {
                // If successful, send back to the list.
                response.sendRedirect("ManageUsersServlet?success=UserUpdated");
            } else {
                response.sendRedirect("ManageUsersServlet?error=UpdateFailed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ManageUsersServlet?error=ServerError");
        }
    }
}