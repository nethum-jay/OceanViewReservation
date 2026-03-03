package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RequestCancellationServlet")
public class RequestCancellationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String resIdStr = request.getParameter("resId");
        String checkInDateStr = request.getParameter("checkInDate");

        if (resIdStr != null && checkInDateStr != null) {
            LocalDate checkInDate = LocalDate.parse(checkInDateStr);
            LocalDate today = LocalDate.now();

            // Checking if 24 hours (1 day) ago
            long daysBetween = ChronoUnit.DAYS.between(today, checkInDate);

            if (daysBetween >= 1) {
                int resId = Integer.parseInt(resIdStr);
                ReservationDAO dao = new ReservationDAO();
                boolean isRequested = dao.requestCancellation(resId);

                if (isRequested) {
                    request.setAttribute("successMessage", "Cancellation request sent to Admin successfully.");
                } else {
                    request.setAttribute("errorMessage", "Failed to send cancellation request.");
                }
            } else {
                request.setAttribute("errorMessage", "You can only cancel a booking 24 hours prior to the check-in date.");
            }
        }

        request.getRequestDispatcher("ViewReservationServlet").forward(request, response);
    }
}