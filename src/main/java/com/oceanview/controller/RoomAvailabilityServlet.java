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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (checkIn != null && checkOut != null && !checkIn.isEmpty() && !checkOut.isEmpty()) {
            ReservationDAO dao = new ReservationDAO();
            Map<String, Integer> counts = dao.getAvailableRoomCounts(checkIn, checkOut);

            String json = String.format("{\"Single\": %d, \"Double\": %d, \"Suite\": %d, \"Family\": %d}",
                    counts.getOrDefault("Single", 0), counts.getOrDefault("Double", 0),
                    counts.getOrDefault("Suite", 0), counts.getOrDefault("Family", 0));
            out.print(json);
        } else {
            out.print("{\"Single\": \"--\", \"Double\": \"--\", \"Suite\": \"--\", \"Family\": \"--\"}");
        }
        out.flush();
    }
}