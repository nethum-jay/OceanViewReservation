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
        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String role = (String) session.getAttribute("userRole");
        String username = (String) session.getAttribute("loggedUser");
        String bookingId = request.getParameter("bookingId");

        if (bookingId != null && !bookingId.trim().isEmpty()) {
            ReservationDAO dao = new ReservationDAO();

            Map<String, String> details = dao.getInvoiceDetailsSecure(bookingId.trim(), role, username);

            if (details != null) {
                request.setAttribute("bookingDetails", details);
            } else {
                if ("Customer".equals(role)) {
                    request.setAttribute("errorMessage", "Access Denied! This Booking ID does not belong to you.");
                } else {
                    request.setAttribute("errorMessage", "No booking found for ID: " + bookingId);
                }
            }
        }

        request.getRequestDispatcher("searchBooking.jsp").forward(request, response);
    }
}