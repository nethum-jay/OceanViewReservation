package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Reservation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

// WebService Endpoint
@WebServlet("/ReservationServlet")
public class ReservationServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            // Getting interface (UI) data
            int guestID = Integer.parseInt(request.getParameter("guestID"));
            String roomType = request.getParameter("roomType");
            String checkInDate = request.getParameter("checkInDate");
            String checkOutDate = request.getParameter("checkOutDate");

            // Creating a Model object
            Reservation newReservation = new Reservation();

            newReservation.setGuestId(guestID);
            newReservation.setRoomType(roomType);
            newReservation.setCheckInDate(checkInDate);
            newReservation.setCheckOutDate(checkOutDate);

            // Providing the DAO class to send to the database
            ReservationDAO reservationDAO = new ReservationDAO();
            boolean isBooked = reservationDAO.bookRoom(newReservation);

            // Providing a message (Response) to the user
            if (isBooked) {
                request.setAttribute("successMessage", "Room Booked Successfully!");
            } else {
                request.setAttribute("errorMessage", "Booking Failed. Please check if the Guest ID is valid.");
            }

        } catch (NumberFormatException e) {
            // When letters or incorrect data are provided for the Guest ID
            request.setAttribute("errorMessage", "Invalid Guest ID. Please enter a valid number.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An unexpected error occurred.");
        }

        // Finally, redirecting back to the booking.jsp page
        request.getRequestDispatcher("booking.jsp").forward(request, response);
    }
}