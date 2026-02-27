package com.oceanview.controller;

import com.oceanview.dao.GuestDAO;
import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Reservation;
import com.oceanview.util.EmailUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@WebServlet("/AddNewReservationServlet")
public class AddNewReservationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Retrieving data from the "Guest Details" section of the JSP
            String name = request.getParameter("guestName");
            String nic = request.getParameter("nic");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String contactNo = request.getParameter("contactNo");

            // Retrieving data from the "Reservation Details" section of the JSP
            String roomType = request.getParameter("roomType");
            int noOfPersons = Integer.parseInt(request.getParameter("noOfPersons"));
            String checkInDate = request.getParameter("checkInDate");
            String checkOutDate = request.getParameter("checkOutDate");

            // Calculating the total amount (Bill Amount)
            double ratePerNight = 0;
            if ("Single".equalsIgnoreCase(roomType)) ratePerNight = 10000.00;
            else if ("Double".equalsIgnoreCase(roomType)) ratePerNight = 15000.00;
            else if ("Family".equalsIgnoreCase(roomType)) ratePerNight = 25000.00;
            else if ("Suite".equalsIgnoreCase(roomType)) ratePerNight = 30000.00;

            LocalDate d1 = LocalDate.parse(checkInDate);
            LocalDate d2 = LocalDate.parse(checkOutDate);
            long nights = ChronoUnit.DAYS.between(d1, d2);
            if (nights <= 0) nights = 1;

            double totalCost = nights * ratePerNight;

            // First, send the Guest's data to the 'guest' table and get his ID.
            GuestDAO guestDAO = new GuestDAO();
            int guestId = guestDAO.saveOrUpdateGuest(name, nic, email, address, contactNo);

            // Only send data to the 'reservation' table if the Guest ID is successfully received.
            if (guestId > 0) {
                Reservation res = new Reservation();
                res.setGuestId(guestId);
                res.setRoomType(roomType);
                res.setNoOfPersons(noOfPersons);
                res.setCheckInDate(checkInDate);
                res.setCheckOutDate(checkOutDate);

                ReservationDAO resDAO = new ReservationDAO();
                boolean isBooked = resDAO.addReservation(res);

                if (isBooked) {
                    // Sending an email if the reservation is successful (via EmailUtil)
                    EmailUtil.sendBookingEmail(email, name, roomType, checkInDate, checkOutDate, noOfPersons, totalCost);

                    request.setAttribute("successMessage", "Reservation confirmed successfully! Digital Invoice sent to " + email);
                } else {
                    request.setAttribute("errorMessage", "Failed to confirm reservation. Room might not be available.");
                }
            } else {
                request.setAttribute("errorMessage", "Failed to save Guest Details in the database.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
        }

        // Redirect to the Booking page
        request.getRequestDispatcher("booking.jsp").forward(request, response);
    }
}