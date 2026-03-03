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

@WebServlet("/DeleteReservationServlet")
public class DeleteReservationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam != null) {
            int resId = Integer.parseInt(idParam);
            ReservationDAO dao = new ReservationDAO();

            // Fetching the guest's details (Email, Name) from the database to send the email before deleting
            Map<String, String> details = dao.getReservationDetailsById(resId);

            // Deleting the booking completely
            boolean isDeleted = dao.deleteReservation(resId);

            if (isDeleted) {
                // Send an email to the customer only if the deletion is successful.
                if (details != null && details.get("email") != null) {
                    String guestEmail = details.get("email");
                    String guestName = details.get("name");

                    // Sending Email via EmailUtil
                    EmailUtil.sendCancellationEmail(guestEmail, guestName, idParam);
                }
                request.setAttribute("successMessage", "Booking successfully cancelled and deleted.");
            } else {
                request.setAttribute("errorMessage", "Failed to delete the booking.");
            }
        }

        // Check which page the admin came from and send them back to that page
        String referer = request.getHeader("referer");
        if (referer != null && referer.contains("CancelRequestsServlet")) {
            response.sendRedirect("CancelRequestsServlet");
        } else {
            response.sendRedirect("ViewReservationsServlet");
        }
    }
}