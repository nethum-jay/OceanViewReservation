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
            // Getting Guest Details
            String name = request.getParameter("guestName");
            String nic = request.getParameter("nic");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String contactNo = request.getParameter("contactNo");

            Guest guest = new Guest(name, nic, email, address, contactNo);

            // Getting Booking Details
            String roomType = request.getParameter("roomType");
            String checkIn = request.getParameter("checkInDate");
            String checkOut = request.getParameter("checkOutDate");

            Reservation reservation = new Reservation();
            reservation.setRoomType(roomType);
            reservation.setCheckInDate(checkIn);
            reservation.setCheckOutDate(checkOut);

            // Sending to the Database via DAO
            ReservationDAO dao = new ReservationDAO();
            int generatedId = dao.addCompleteReservation(guest, reservation);

            if (generatedId > 0) {

                EmailUtil.sendBookingEmail(email, name, roomType);

                request.setAttribute("successMessage", "Reservation Successfully Added! Confirmation email sent to " + email);
            } else {
                request.setAttribute("errorMessage", "Failed to add reservation. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            String exactError = (e.getMessage() != null) ? e.getMessage() : "System Error occurred!";
            request.setAttribute("errorMessage", "Database Error: " + exactError);
        }

        request.getRequestDispatcher("booking.jsp").forward(request, response);
    }
}