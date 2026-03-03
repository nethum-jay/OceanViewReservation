package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ViewReservationServlet")
public class ViewReservationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // If not logged in, send to login page
        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String role = (String) session.getAttribute("userRole");
        String loggedUser = (String) session.getAttribute("loggedUser");

        ReservationDAO dao = new ReservationDAO();
        List<Map<String, String>> resList = null;

        try {
            if ("Customer".equals(role)) {
                // If a customer, fetch all bookings related to their username
                resList = dao.getCustomerReservations(loggedUser);
            } else {
                // If Admin or Staff, search for the value (ID or Phone) from the Search Box
                String searchValue = request.getParameter("searchValue");

                if (searchValue != null && !searchValue.trim().isEmpty()) {
                    resList = dao.searchReservations(searchValue.trim());

                    if (resList == null || resList.isEmpty()) {
                        request.setAttribute("errorMessage", "No bookings found for the provided ID or Phone Number.");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while fetching reservations.");
        }

        // Sending the List to the JSP Page
        request.setAttribute("resList", resList);
        request.getRequestDispatcher("viewReservation.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}