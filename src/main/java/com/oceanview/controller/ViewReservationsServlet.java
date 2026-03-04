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
import java.util.List;

@WebServlet("/ViewReservationsServlet")
public class ViewReservationsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Access control: Ensure only Admin or Staff can view all system reservations
        if (session == null || session.getAttribute("userRole") == null || "Customer".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            ReservationDAO dao = new ReservationDAO();
            List<Reservation> resList = dao.getAllReservations();

            request.setAttribute("reservationList", resList);

        } catch (Exception e) {
            e.printStackTrace();
            // Display an error message if database fetching fails
            request.setAttribute("errorMessage", "An error occurred while loading the reservations.");
        }

        request.getRequestDispatcher("viewReservations.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Route POST requests (like updates) back through the GET method to refresh the list
        doGet(request, response);
    }
}