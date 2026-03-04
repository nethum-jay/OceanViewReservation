package com.oceanview.controller;

import com.oceanview.dao.GuestDAO;
import com.oceanview.model.Guest;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/GuestServlet")
public class GuestServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get user inputs from the interface
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String contactNo = request.getParameter("contactNo");
        String nic = request.getParameter("nic");
        String email = request.getParameter("email");

        // Server-Side Validation (Restricting invalid or empty entries)
        if (name == null || name.trim().isEmpty() || contactNo == null || contactNo.trim().length() < 10) {
            request.setAttribute("errorMessage", "Invalid Input. Please check your details.");
        } else {
            // Handle empty NIC dynamically
            if (nic == null || nic.trim().isEmpty()) {
                nic = "Temp-" + System.currentTimeMillis();
            }

            // Create Model Object
            Guest newGuest = new Guest(
                    name.trim(),
                    nic.trim(),
                    email != null ? email.trim() : "",
                    address != null ? address.trim() : "",
                    contactNo.trim()
            );

            // Pass to DAO
            GuestDAO guestDAO = new GuestDAO();
            boolean isRegistered = guestDAO.registerGuest(newGuest);

            if (isRegistered) {
                request.setAttribute("successMessage", "Guest Registered Successfully!");
            } else {
                request.setAttribute("errorMessage", "Registration Failed due to a server error.");
            }
        }

        // Send response back to UI centrally
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}