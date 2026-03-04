package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Access control: Ensure only Admin can delete users
        if (session == null || !"Admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                UserDAO dao = new UserDAO();

                // Perform user deletion
                if (dao.deleteUser(id)) {
                    session.setAttribute("successMessage", "User deleted successfully.");
                } else {
                    session.setAttribute("errorMessage", "Failed to delete the user.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid User ID format.");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "An error occurred while deleting the user.");
            }
        } else {
            session.setAttribute("errorMessage", "User ID is missing.");
        }

        // Redirect back to the manage users page
        response.sendRedirect("ManageUsersServlet");
    }
}