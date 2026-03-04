package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/SearchBookingServlet")
public class SearchBookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Access control: Ensure user is logged in
        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String role = (String) session.getAttribute("userRole");
        String username = (String) session.getAttribute("loggedUser");
        String bookingId = request.getParameter("bookingId");

        // Process search only if bookingId is provided
        if (bookingId != null && !bookingId.trim().isEmpty()) {
            try {
                ReservationDAO dao = new ReservationDAO();

                // Securely fetch invoice details based on user role
                Map<String, String> details = dao.getInvoiceDetailsSecure(bookingId.trim(), role, username);

                if (details != null && !details.isEmpty()) {
                    request.setAttribute("bookingDetails", details);
                } else {
                    // Display appropriate error message based on the user's role
                    if ("Customer".equals(role)) {
                        request.setAttribute("errorMessage", "Access Denied! This Booking ID does not belong to you or does not exist.");
                    } else {
                        request.setAttribute("errorMessage", "No booking found for ID: " + bookingId.trim());
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                // Handle unexpected database errors gracefully
                request.setAttribute("errorMessage", "An error occurred while searching for the booking. Please try again.");
            }
        }

        // Forward to the search page to display results or errors
        request.getRequestDispatcher("searchBooking.jsp").forward(request, response);
    }
}