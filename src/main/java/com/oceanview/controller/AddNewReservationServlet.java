package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Guest;
import com.oceanview.model.Reservation;

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

            // If the ID is greater than 0, the registration is successful.
            if (generatedId > 0) {
                request.setAttribute("successMessage", "Reservation Successfully Added! Your Guest/Booking ID is: " + generatedId);
            } else {
                request.setAttribute("errorMessage", "Failed to add reservation. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "System Error occurred!");
        }

        request.getRequestDispatcher("addReservation.jsp").forward(request, response);
    }
}