package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Reservation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ReservationServlet")
public class ReservationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            String guestIdStr = request.getParameter("guestID");
            String roomType = request.getParameter("roomType");
            String checkInDate = request.getParameter("checkInDate");
            String checkOutDate = request.getParameter("checkOutDate");

            // Server-side validation to ensure inputs are not empty
            if (guestIdStr == null || guestIdStr.trim().isEmpty() ||
                    roomType == null || roomType.trim().isEmpty() ||
                    checkInDate == null || checkInDate.trim().isEmpty() ||
                    checkOutDate == null || checkOutDate.trim().isEmpty()) {

                request.setAttribute("errorMessage", "All fields are required. Please check your inputs.");
                request.getRequestDispatcher("booking.jsp").forward(request, response);
                return;
            }

            int guestID = Integer.parseInt(guestIdStr.trim());

            Reservation newReservation = new Reservation();
            newReservation.setGuestId(guestID);
            newReservation.setRoomType(roomType.trim());
            newReservation.setCheckInDate(checkInDate.trim());
            newReservation.setCheckOutDate(checkOutDate.trim());

            ReservationDAO reservationDAO = new ReservationDAO();
            boolean isBooked = reservationDAO.bookRoom(newReservation);

            if (isBooked) {
                request.setAttribute("successMessage", "Room Booked Successfully!");
            } else {
                request.setAttribute("errorMessage", "Booking Failed. Please check if the Guest ID is valid.");
            }

        } catch (NumberFormatException e) {
            // Handle invalid Guest ID format (e.g., text instead of numbers)
            request.setAttribute("errorMessage", "Invalid Guest ID. Please enter a valid number.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An unexpected error occurred. Please try again.");
        }

        // Forward back to the booking page to display messages
        request.getRequestDispatcher("booking.jsp").forward(request, response);
    }
}