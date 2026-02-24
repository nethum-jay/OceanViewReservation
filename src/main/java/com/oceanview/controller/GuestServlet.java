package com.oceanview.controller;

import com.oceanview.dao.GuestDAO;
import com.oceanview.model.Guest;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

// WebService Endpoint
@WebServlet("/GuestServlet")
public class GuestServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get user inputs from the interface
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String contactNo = request.getParameter("contactNo");

        // Server-Side Validation (Restricting invalid entries)
        if (name == null || name.trim().isEmpty() || contactNo == null || contactNo.length() < 10) {
            request.setAttribute("errorMessage", "Invalid Input. Please check your details.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Create Model Object
        String nic = request.getParameter("nic");
        String email = request.getParameter("email");

        if (nic == null || nic.isEmpty()) {
            nic = "Temp-" + System.currentTimeMillis();
        }

        Guest newGuest = new Guest(name, nic, email, address, contactNo);

        // Pass to DAO
        GuestDAO guestDAO = new GuestDAO();
        boolean isRegistered = guestDAO.registerGuest(newGuest);

        // Send response back to UI
        if (isRegistered) {
            request.setAttribute("successMessage", "Guest Registered Successfully!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Registration Failed due to a server error.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}