package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ViewReservationServlet")
public class ViewReservationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Access control: Ensure user is logged in
        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String role = (String) session.getAttribute("userRole");
        String loggedUser = (String) session.getAttribute("loggedUser");

        List<Map<String, String>> resList = null;

        try {
            ReservationDAO dao = new ReservationDAO();

            if ("Customer".equals(role)) {
                // Fetch all bookings for the logged-in customer
                resList = dao.getCustomerReservations(loggedUser);
            } else {
                // Admin or Staff: Search by Booking ID or Phone Number
                String searchValue = request.getParameter("searchValue");

                if (searchValue != null && !searchValue.trim().isEmpty()) {
                    resList = dao.searchReservations(searchValue.trim());

                    if (resList == null || resList.isEmpty()) {
                        request.setAttribute("errorMessage", "No bookings found for the provided ID or Phone Number.");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while fetching reservations.");
        }

        request.setAttribute("resList", resList);
        request.getRequestDispatcher("viewReservation.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Forward POST requests (e.g., from Cancellation) to doGet to handle seamlessly
        doGet(request, response);
    }
}