package com.oceanview.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Get the existing Session (without creating a new one)
        HttpSession session = request.getSession(false);

        if (session != null) {
            // Destroy the session completely (Logout)
            session.invalidate();
        }

        // Then redirect to the exit.jsp page showing that it has been safely logged out
        response.sendRedirect("exit.jsp");
    }
}