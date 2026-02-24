package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Guest;
import com.oceanview.model.Reservation;
import com.oceanview.util.EmailUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AddNewReservationServlet")
public class AddNewReservationServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Data acquisition
            String name = request.getParameter("guestName");
            String nic = request.getParameter("nic");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String contactNo = request.getParameter("contactNo");

            String roomType = request.getParameter("roomType");
            String checkIn = request.getParameter("checkInDate");
            String checkOut = request.getParameter("checkOutDate");
            int noOfPersons = Integer.parseInt(request.getParameter("noOfPersons"));

            // Calculating the total price (Bill Amount)
            double ratePerNight = 0;
            if ("Single".equalsIgnoreCase(roomType)) ratePerNight = 10000.00;
            else if ("Double".equalsIgnoreCase(roomType)) ratePerNight = 15000.00;
            else if ("Family".equalsIgnoreCase(roomType)) ratePerNight = 25000.00;
            else if ("Suite".equalsIgnoreCase(roomType)) ratePerNight = 30000.00;


            java.time.LocalDate d1 = java.time.LocalDate.parse(checkIn);
            java.time.LocalDate d2 = java.time.LocalDate.parse(checkOut);
            long nights = java.time.temporal.ChronoUnit.DAYS.between(d1, d2);
            if (nights <= 0) nights = 1;

            double totalCost = nights * ratePerNight;

            // Creating Objects
            Guest guest = new Guest(name, nic, email, address, contactNo);
            Reservation reservation = new Reservation();
            reservation.setRoomType(roomType);
            reservation.setCheckInDate(checkIn);
            reservation.setCheckOutDate(checkOut);
            reservation.setNoOfPersons(noOfPersons);

            // Sending to the database
            ReservationDAO dao = new ReservationDAO();
            int generatedId = dao.addCompleteReservation(guest, reservation);

            if (generatedId > 0) {
                // Sending the email
                EmailUtil.sendBookingEmail(email, name, roomType, checkIn, checkOut, noOfPersons, totalCost);

                request.setAttribute("successMessage", "Reservation Added! Digital Invoice sent to " + email);
            } else {
                request.setAttribute("errorMessage", "Failed to add reservation.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
        }
        request.getRequestDispatcher("booking.jsp").forward(request, response);
    }
}