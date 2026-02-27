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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Reservation r = new Reservation();
            r.setReservationID(Integer.parseInt(request.getParameter("reservationID")));
            r.setRoomType(request.getParameter("roomType"));
            r.setCheckInDate(request.getParameter("checkInDate"));
            r.setCheckOutDate(request.getParameter("checkOutDate"));
            r.setNoOfPersons(Integer.parseInt(request.getParameter("noOfPersons")));

            ReservationDAO dao = new ReservationDAO();
            if(dao.updateReservationByAdmin(r)) {
                response.sendRedirect("ViewReservationsServlet?success=BookingUpdated");
            } else {
                response.sendRedirect("ViewReservationsServlet?error=UpdateFailed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ViewReservationsServlet?error=SystemError");
        }
    }
}