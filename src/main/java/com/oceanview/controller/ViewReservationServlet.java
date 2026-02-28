package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ViewReservationServlet")
public class ViewReservationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchValue = request.getParameter("searchValue");

        if (searchValue != null && !searchValue.trim().isEmpty()) {
            ReservationDAO dao = new ReservationDAO();
            Map<String, String> details = null;

            searchValue = searchValue.trim().replace("#", "");

            try {
                // If it's an ID (numbers only and short)
                if(searchValue.matches("\\d+") && searchValue.length() < 8) {
                    details = dao.getReservationDetailsById(Integer.parseInt(searchValue));
                } else {
                    // Else, try to search by Phone Number
                    details = dao.getCompleteReservationDetails(searchValue);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            if (details != null) {
                request.setAttribute("resDetails", details);
            } else {
                request.setAttribute("errorMessage", "No active booking found for the provided details.");
            }
        }
        request.getRequestDispatcher("viewReservation.jsp").forward(request, response);
    }
}