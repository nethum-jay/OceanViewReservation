package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Reservation;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/ViewReservationsServlet")
public class ViewReservationsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ReservationDAO dao = new ReservationDAO();
        List<Reservation> list = dao.getAllReservations();

        request.setAttribute("reservationList", list);
        request.getRequestDispatcher("viewReservations.jsp").forward(request, response);
    }
}