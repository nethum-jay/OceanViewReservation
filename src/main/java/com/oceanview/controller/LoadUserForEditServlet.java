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

@WebServlet("/LoadUserForEditServlet")
public class LoadUserForEditServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Access control: Ensure only Admin can access the edit user page
        if (session == null || !"Admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                UserDAO dao = new UserDAO();
                User user = dao.getUserById(id);

                // If user exists, forward to the edit page
                if (user != null) {
                    request.setAttribute("userToEdit", user);
                    request.getRequestDispatcher("editUserByAdmin.jsp").forward(request, response);
                    return;
                } else {
                    session.setAttribute("errorMessage", "User not found.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid User ID format.");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "An error occurred while loading user details.");
            }
        } else {
            session.setAttribute("errorMessage", "User ID is missing.");
        }

        // Redirect back to the manage users page if any error occurs
        response.sendRedirect("ManageUsersServlet");
    }
}