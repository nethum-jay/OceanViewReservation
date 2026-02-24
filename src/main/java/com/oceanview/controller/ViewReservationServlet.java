package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@WebServlet("/ViewReservationServlet")
public class ViewReservationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get the phone number sent from the JSP page
            String contactNo = request.getParameter("contactNo");

            ReservationDAO dao = new ReservationDAO();
            // Retrieving details from the database
            Map<String, String> details = dao.getCompleteReservationDetails(contactNo);

            if (details != null) {
                request.setAttribute("resDetails", details);
            } else {
                request.setAttribute("errorMessage", "No reservation found for this Phone Number!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "System Error: " + e.getMessage());
        }

        // Redirect to view_reservation.jsp page
        request.getRequestDispatcher("viewReservation.jsp").forward(request, response);
    }
}