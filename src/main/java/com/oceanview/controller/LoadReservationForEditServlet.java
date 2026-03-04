package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Reservation;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoadReservationForEditServlet")
public class LoadReservationForEditServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Access control: Ensure only Admin can edit reservations
        if (session == null || !"Admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                ReservationDAO dao = new ReservationDAO();
                Reservation res = dao.getReservationById(id);

                // If reservation exists, forward to the edit page
                if (res != null) {
                    request.setAttribute("reservationToEdit", res);
                    request.getRequestDispatcher("editReservationByAdmin.jsp").forward(request, response);
                    return;
                } else {
                    session.setAttribute("errorMessage", "Reservation not found.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid Reservation ID format.");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "An error occurred while loading the reservation.");
            }
        } else {
            session.setAttribute("errorMessage", "Reservation ID is missing.");
        }

        // Redirect back to the reservation list if any error occurs
        response.sendRedirect("ViewReservationsServlet");
    }
}