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
            // Get the Guest ID provided by the user
            int guestID = Integer.parseInt(request.getParameter("guestID"));

            ReservationDAO dao = new ReservationDAO();
            Map<String, String> details = dao.getCompleteReservationDetails(guestID);

            if (details != null) {
                // If data is found, send it to the JSP page
                request.setAttribute("resDetails", details);
            } else {
                request.setAttribute("errorMessage", "No reservation found for Guest ID: " + guestID);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid Guest ID format. Please enter a valid number.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "System Error occurred!");
        }

        request.getRequestDispatcher("viewReservation.jsp").forward(request, response);
    }
}