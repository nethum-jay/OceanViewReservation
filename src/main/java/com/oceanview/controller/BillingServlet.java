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

@WebServlet("/BillingServlet")
public class BillingServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Getting the phone number
            String contactNo = request.getParameter("contactNo");

            ReservationDAO dao = new ReservationDAO();
            // Search for details via phone number
            Map<String, String> details = dao.getCompleteReservationDetails(contactNo);

            if (details != null) {
                // Calculating the number of days (Nights)
                LocalDate checkIn = LocalDate.parse(details.get("checkInDate"));
                LocalDate checkOut = LocalDate.parse(details.get("checkOutDate"));
                long nights = ChronoUnit.DAYS.between(checkIn, checkOut);

                if (nights <= 0) nights = 1; // Must be at least 1 day old

                // Determining the price by room type
                String roomType = details.get("roomType");
                double ratePerNight = 0;

                if ("Single".equalsIgnoreCase(roomType)) {
                    ratePerNight = 10000.00;
                } else if ("Double".equalsIgnoreCase(roomType)) {
                    ratePerNight = 15000.00;
                } else if ("Family".equalsIgnoreCase(roomType)) {
                    ratePerNight = 25000.00;
                } else if ("Suite".equalsIgnoreCase(roomType)) {
                    ratePerNight = 30000.00;
                }

                // Calculating the total
                double totalCost = nights * ratePerNight;

                // Sending data to the JSP page
                request.setAttribute("resDetails", details);
                request.setAttribute("nights", nights);
                request.setAttribute("ratePerNight", ratePerNight);
                request.setAttribute("totalCost", totalCost);

            } else {
                request.setAttribute("errorMessage", "No reservation found for Contact No: " + contactNo);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error generating bill. Please check inputs.");
        }

        request.getRequestDispatcher("printBill.jsp").forward(request, response);
    }
}