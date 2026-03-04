package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

@WebServlet("/RoomAvailabilityServlet")
public class RoomAvailabilityServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");

        // Set content type and encoding for JSON response
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            // Validate inputs to prevent empty or whitespace-only dates
            if (checkIn != null && !checkIn.trim().isEmpty() && checkOut != null && !checkOut.trim().isEmpty()) {
                try {
                    ReservationDAO dao = new ReservationDAO();
                    Map<String, Integer> counts = dao.getAvailableRoomCounts(checkIn.trim(), checkOut.trim());

                    // Format the available room counts into a JSON string
                    String json = String.format("{\"Single\": %d, \"Double\": %d, \"Suite\": %d, \"Family\": %d}",
                            counts.getOrDefault("Single", 0),
                            counts.getOrDefault("Double", 0),
                            counts.getOrDefault("Suite", 0),
                            counts.getOrDefault("Family", 0));
                    out.print(json);

                } catch (Exception e) {
                    e.printStackTrace();
                    // Return a safe fallback JSON in case of database errors to prevent UI crash
                    out.print("{\"Single\": \"Error\", \"Double\": \"Error\", \"Suite\": \"Error\", \"Family\": \"Error\"}");
                }
            } else {
                // Return default dashes if dates are missing
                out.print("{\"Single\": \"--\", \"Double\": \"--\", \"Suite\": \"--\", \"Family\": \"--\"}");
            }
            out.flush();
        }
    }
}