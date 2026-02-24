package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            UserDAO dao = new UserDAO();

            if(dao.deleteUser(id)) {
                response.sendRedirect("ManageUsersServlet?success=User Deleted");
            } else {
                response.sendRedirect("ManageUsersServlet?error=Delete Failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ManageUsersServlet?error=ErrorOccurred");
        }
    }
}