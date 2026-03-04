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
            String name = request.getParameter("guestName");
            String nic = request.getParameter("nic");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String contactNo = request.getParameter("contactNo");

            String roomType = request.getParameter("roomType");

            // To prevent an error from occurring if a value is entered incorrectly or is empty.
            String personsStr = request.getParameter("noOfPersons");
            int noOfPersons = (personsStr != null && !personsStr.trim().isEmpty()) ? Integer.parseInt(personsStr.trim()) : 1;

            String checkInDate = request.getParameter("checkInDate");
            String checkOutDate = request.getParameter("checkOutDate");

            // Price calculation
            double ratePerNight = 10000.00; // Default price (Single)
            if ("Double".equalsIgnoreCase(roomType)) ratePerNight = 15000.00;
            else if ("Family".equalsIgnoreCase(roomType)) ratePerNight = 25000.00;
            else if ("Suite".equalsIgnoreCase(roomType)) ratePerNight = 30000.00;

            LocalDate d1 = LocalDate.parse(checkInDate);
            LocalDate d2 = LocalDate.parse(checkOutDate);
            long nights = ChronoUnit.DAYS.between(d1, d2);
            if (nights <= 0) nights = 1;

            // The thread is set to final for submission inside.
            final double totalCost = nights * ratePerNight;

            // Saving the guest
            GuestDAO guestDAO = new GuestDAO();
            int guestId = guestDAO.saveOrUpdateGuest(name, nic, email, address, contactNo);

            if (guestId > 0) {
                // Saving the booking
                Reservation res = new Reservation();
                res.setGuestId(guestId);
                res.setRoomType(roomType);
                res.setNoOfPersons(noOfPersons);
                res.setCheckInDate(checkInDate);
                res.setCheckOutDate(checkOutDate);

                ReservationDAO resDAO = new ReservationDAO();
                int generatedResId = resDAO.addReservation(res);

                if (generatedResId > 0) {

                    new Thread(() -> {
                        try {
                            EmailUtil.sendBookingEmail(generatedResId, email, name, roomType, checkInDate, checkOutDate, noOfPersons, totalCost);
                        } catch (Exception e) {
                            System.out.println("Background Email Error: " + e.getMessage());
                        }
                    }).start();

                    request.setAttribute("successMessage", "Reservation confirmed! Your Booking ID is: #" + generatedResId);
                    request.setAttribute("generatedResId", generatedResId);
                } else {
                    request.setAttribute("errorMessage", "Failed to confirm reservation. Database error.");
                }
            } else {
                request.setAttribute("errorMessage", "Failed to save Guest Details.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Providing a general message as it is not safe to show System Errors to the customer
            request.setAttribute("errorMessage", "An error occurred! Please check your details and try again.");
        }

        request.getRequestDispatcher("booking.jsp").forward(request, response);
    }
}