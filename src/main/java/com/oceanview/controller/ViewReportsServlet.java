package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.UserDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/ViewReportsServlet")
public class ViewReportsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Access control: Ensure only Admin can view reports
        if (session == null || !"Admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            /* * Note: Fetching the entire list to get the size is not memory efficient for large datasets.
             * Consider adding a count(*) query method in your DAO classes in the future.
             */
            UserDAO userDAO = new UserDAO();
            int totalUsers = userDAO.getAllUsers().size();

            ReservationDAO resDAO = new ReservationDAO();
            int totalBookings = resDAO.getAllReservations().size();

            // Set report data as request attributes
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalBookings", totalBookings);

            request.getRequestDispatcher("reports.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while generating reports.");
            response.sendRedirect("adminDashboard.jsp");
        }
    }
}