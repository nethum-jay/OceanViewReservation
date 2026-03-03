package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/CancelRequestsServlet")
public class CancelRequestsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Checking if you are an admin
        String role = (String) request.getSession().getAttribute("userRole");
        if (role == null || !role.equals("Admin")) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            ReservationDAO dao = new ReservationDAO();
            // Fetch only those in 'Cancel_Requested' status
            List<Map<String, String>> cancelList = dao.getCancellationRequests();
            request.setAttribute("cancelList", cancelList);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Sends data to the new JSP page
        request.getRequestDispatcher("cancelRequests.jsp").forward(request, response);
    }
}