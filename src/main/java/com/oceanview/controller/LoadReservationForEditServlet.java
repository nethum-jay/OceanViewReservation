package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Reservation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/LoadReservationForEditServlet")
public class LoadReservationForEditServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            ReservationDAO dao = new ReservationDAO();
            Reservation res = dao.getReservationById(id);

            if (res != null) {
                request.setAttribute("reservationToEdit", res);
                request.getRequestDispatcher("editReservationByAdmin.jsp").forward(request, response);
            } else {
                response.sendRedirect("ViewReservationsServlet");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ViewReservationsServlet");
        }
    }
}