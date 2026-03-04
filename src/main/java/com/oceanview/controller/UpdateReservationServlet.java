package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Reservation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/UpdateReservationServlet")
public class UpdateReservationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Access control: Ensure only Admin can update reservations
        if (session == null || !"Admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int resId = Integer.parseInt(request.getParameter("reservationId"));
            int guestId = Integer.parseInt(request.getParameter("guestId"));
            String roomType = request.getParameter("roomType");
            String checkInDate = request.getParameter("checkInDate");
            String checkOutDate = request.getParameter("checkOutDate");
            int noOfPersons = Integer.parseInt(request.getParameter("noOfPersons"));

            // Server-side validation for empty strings
            if (roomType == null || roomType.trim().isEmpty() ||
                    checkInDate == null || checkInDate.trim().isEmpty() ||
                    checkOutDate == null || checkOutDate.trim().isEmpty()) {

                session.setAttribute("errorMessage", "All fields are required. Please check your inputs.");
                response.sendRedirect("ViewReservationsServlet");
                return;
            }

            // Create and set reservation object
            Reservation r = new Reservation();
            r.setReservationId(resId);
            r.setGuestId(guestId);
            r.setRoomType(roomType.trim());
            r.setCheckInDate(checkInDate.trim());
            r.setCheckOutDate(checkOutDate.trim());
            r.setNoOfPersons(noOfPersons);

            ReservationDAO dao = new ReservationDAO();
            boolean isUpdated = dao.updateReservationByAdmin(r);

            if (isUpdated) {
                session.setAttribute("successMessage", "Reservation #" + resId + " updated successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to update reservation #" + resId + ".");
            }

        } catch (NumberFormatException e) {
            // Handles cases where IDs or Person counts are not valid numbers
            session.setAttribute("errorMessage", "Invalid number format provided for IDs or Persons.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while updating the reservation.");
        }

        // Redirect using Post-Redirect-Get pattern to avoid form resubmission issues on refresh
        response.sendRedirect("ViewReservationsServlet");
    }
}