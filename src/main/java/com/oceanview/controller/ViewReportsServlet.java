package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.UserDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ViewReportsServlet")
public class ViewReportsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get the total number of Users and Bookings in the system
            UserDAO userDAO = new UserDAO();
            int totalUsers = userDAO.getAllUsers().size();

            ReservationDAO resDAO = new ReservationDAO();
            int totalBookings = resDAO.getAllReservations().size();

            // Sending that data to the JSP page
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalBookings", totalBookings);

            request.getRequestDispatcher("reports.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminDashboard.jsp?error=ReportGenFailed");
        }
    }
}