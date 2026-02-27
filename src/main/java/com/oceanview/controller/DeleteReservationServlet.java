package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/DeleteReservationServlet")
public class DeleteReservationServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            ReservationDAO dao = new ReservationDAO();
            dao.deleteReservation(id);
            // Returning to the reservation list after deletion
            response.sendRedirect("ViewReservationsServlet?success=BookingDeleted");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ViewReservationsServlet?error=DeleteFailed");
        }
    }
}