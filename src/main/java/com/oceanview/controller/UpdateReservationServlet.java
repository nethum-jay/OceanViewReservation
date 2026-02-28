package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Reservation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/UpdateReservationServlet")
public class UpdateReservationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int resId = Integer.parseInt(request.getParameter("reservationId"));
            int guestId = Integer.parseInt(request.getParameter("guestId"));
            String roomType = request.getParameter("roomType");
            String checkInDate = request.getParameter("checkInDate");
            String checkOutDate = request.getParameter("checkOutDate");
            int noOfPersons = Integer.parseInt(request.getParameter("noOfPersons"));

            Reservation r = new Reservation();
            r.setReservationId(resId);
            r.setGuestId(guestId);
            r.setRoomType(roomType);
            r.setCheckInDate(checkInDate);
            r.setCheckOutDate(checkOutDate);
            r.setNoOfPersons(noOfPersons);

            ReservationDAO dao = new ReservationDAO();
            boolean isUpdated = dao.updateReservationByAdmin(r);

            if(isUpdated){
                request.setAttribute("successMessage", "Reservation #" + resId + " updated successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to update reservation.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while updating.");
        }

        // Return to list
        request.getRequestDispatcher("ViewReservationsServlet").forward(request, response);
    }
}