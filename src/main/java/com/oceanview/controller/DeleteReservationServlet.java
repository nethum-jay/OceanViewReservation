package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.util.EmailUtil;
import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/DeleteReservationServlet")
public class DeleteReservationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        HttpSession session = request.getSession();

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int resId = Integer.parseInt(idParam);
                ReservationDAO dao = new ReservationDAO();

                // Fetching guest details before deletion to send the email
                Map<String, String> details = dao.getReservationDetailsById(resId);

                // Deleting the booking
                boolean isDeleted = dao.deleteReservation(resId);

                if (isDeleted) {
                    // Send email in a background thread to prevent UI freezing
                    if (details != null && details.get("email") != null) {
                        final String guestEmail = details.get("email");
                        final String guestName = details.get("name");

                        new Thread(() -> {
                            try {
                                EmailUtil.sendCancellationEmail(guestEmail, guestName, idParam);
                            } catch (Exception e) {
                                System.out.println("Background Email Error: " + e.getMessage());
                            }
                        }).start();
                    }

                    // Use session attributes to persist messages across redirects
                    session.setAttribute("successMessage", "Booking successfully cancelled and deleted.");
                } else {
                    session.setAttribute("errorMessage", "Failed to delete the booking.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid Booking ID format.");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "An error occurred while deleting the booking.");
            }
        }

        // Check referer to redirect back to the correct page (Cancel Requests or All Bookings)
        String referer = request.getHeader("referer");
        if (referer != null && referer.contains("CancelRequestsServlet")) {
            response.sendRedirect("CancelRequestsServlet");
        } else {
            response.sendRedirect("ViewReservationsServlet");
        }
    }
}