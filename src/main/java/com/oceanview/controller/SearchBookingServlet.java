package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Map;

@WebServlet("/SearchBookingServlet")
public class SearchBookingServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchId = request.getParameter("bookingId");

        if (searchId != null && !searchId.trim().isEmpty()) {
            try {
                searchId = searchId.replace("#", "").trim(); // # ලකුණ ගැසුවත් එය ඉවත් කර අංකය පමණක් ගනී
                int id = Integer.parseInt(searchId);

                ReservationDAO dao = new ReservationDAO();
                Map<String, String> details = dao.getReservationDetailsById(id);

                if (details != null) {
                    // Calculating the total amount of the bill
                    String roomType = details.get("roomType");
                    String checkIn = details.get("checkInDate");
                    String checkOut = details.get("checkOutDate");

                    double rate = 0;
                    if ("Single".equalsIgnoreCase(roomType)) rate = 10000;
                    else if ("Double".equalsIgnoreCase(roomType)) rate = 15000;
                    else if ("Family".equalsIgnoreCase(roomType)) rate = 25000;
                    else if ("Suite".equalsIgnoreCase(roomType)) rate = 30000;

                    LocalDate d1 = LocalDate.parse(checkIn);
                    LocalDate d2 = LocalDate.parse(checkOut);
                    long nights = ChronoUnit.DAYS.between(d1, d2);
                    if(nights <= 0) nights = 1;

                    double total = rate * nights;
                    details.put("nights", String.valueOf(nights));
                    details.put("totalAmount", String.format("%,.2f", total));

                    request.setAttribute("bookingDetails", details);
                } else {
                    request.setAttribute("errorMessage", "No booking found for ID: #" + id);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Booking ID. Please enter a valid number.");
            }
        }
        request.getRequestDispatcher("searchBooking.jsp").forward(request, response);
    }
}