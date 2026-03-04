package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/CancelRequestsServlet")
public class CancelRequestsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || !"Admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            ReservationDAO dao = new ReservationDAO();
            List<Map<String, String>> cancelList = dao.getCancellationRequests();
            request.setAttribute("cancelList", cancelList);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("cancelRequests.jsp").forward(request, response);
    }
}