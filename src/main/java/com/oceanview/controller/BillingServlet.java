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
            int guestID = Integer.parseInt(request.getParameter("guestID"));

            // Retrieving data using a previously created method
            ReservationDAO dao = new ReservationDAO();
            Map<String, String> details = dao.getCompleteReservationDetails(guestID);

            if (details != null) {
                // Calculate Number of Nights
                LocalDate checkIn = LocalDate.parse(details.get("checkInDate"));
                LocalDate checkOut = LocalDate.parse(details.get("checkOutDate"));
                long nights = ChronoUnit.DAYS.between(checkIn, checkOut);

                if (nights <= 0) nights = 1; // To be counted for at least one day

                // Determining room rates by room type
                String roomType = details.get("roomType");
                double ratePerNight = 0;

                if ("Single".equalsIgnoreCase(roomType)) {
                    ratePerNight = 10000.00; // For a single room Rs. 10,000
                } else if ("Double".equalsIgnoreCase(roomType)) {
                    ratePerNight = 15000.00; // For a double room Rs. 15,000
                } else if ("Suite".equalsIgnoreCase(roomType)) {
                    ratePerNight = 30000.00; // For a Suite room Rs. 30,000
                }

                // Calculating the total cost
                double totalCost = nights * ratePerNight;

                // Passing values to the JSP page
                request.setAttribute("resDetails", details);
                request.setAttribute("nights", nights);
                request.setAttribute("ratePerNight", ratePerNight);
                request.setAttribute("totalCost", totalCost);

            } else {
                request.setAttribute("errorMessage", "No reservation found for Guest ID: " + guestID);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error generating bill. Please check inputs.");
        }

        request.getRequestDispatcher("printBill.jsp").forward(request, response);
    }
}