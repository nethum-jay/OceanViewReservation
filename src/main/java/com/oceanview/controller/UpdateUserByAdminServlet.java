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

@WebServlet("/UpdateUserByAdminServlet")
public class UpdateUserByAdminServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Access control: Ensure only Admin can update user details
        if (session == null || !"Admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String idStr = request.getParameter("id");
            String username = request.getParameter("username");
            String pass = request.getParameter("password");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");

            // Server-side validation to prevent empty submissions
            if (idStr == null || username == null || username.trim().isEmpty() ||
                    pass == null || pass.trim().isEmpty() ||
                    phone == null || phone.trim().isEmpty() ||
                    role == null || role.trim().isEmpty()) {

                session.setAttribute("errorMessage", "All fields are required. Please check your inputs.");
                response.sendRedirect("ManageUsersServlet");
                return;
            }

            int id = Integer.parseInt(idStr.trim());

            // Create and set the User object
            User u = new User();
            u.setId(id);
            u.setUsername(username.trim());
            u.setPassword(pass); // Passwords are generally not trimmed
            u.setPhone(phone.trim());
            u.setRole(role.trim());

            UserDAO dao = new UserDAO();
            boolean isUpdated = dao.updateUserDetailsByAdmin(u);

            // Provide appropriate feedback messages based on the database operation
            if (isUpdated) {
                session.setAttribute("successMessage", "User '" + username.trim() + "' updated successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to update the user details.");
            }

        } catch (NumberFormatException e) {
            // Handles cases where the ID is not a valid number
            session.setAttribute("errorMessage", "Invalid User ID format.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while updating the user.");
        }

        // Redirect back to the Manage Users page
        response.sendRedirect("ManageUsersServlet");
    }
}