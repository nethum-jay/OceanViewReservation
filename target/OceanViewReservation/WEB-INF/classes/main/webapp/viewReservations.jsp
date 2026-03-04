<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.oceanview.model.Reservation" %>
<%
    // Security measures: Prevent browser from caching this page after logout
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Access control: Ensure only Staff or Admin can access
    String role = (String) session.getAttribute("userRole");
    if (role == null || (!"Staff".equals(role) && !"Admin".equals(role))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String dashboardLink = "Admin".equals(role) ? "adminDashboard.jsp" : "staffDashboard.jsp";

    // Check if the current user is an Admin (to conditionally show the Edit button)
    boolean isAdmin = "Admin".equals(role);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>All Bookings - Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary: #005f73; --secondary: #0a9396; --text-dark: #1a1a1a; --danger: #e63946; }
        body { font-family: 'Poppins', sans-serif; margin: 0; background: url('https://images.unsplash.com/photo-1618140052121-39fc6db33972?q=80&w=2070&auto=format&fit=crop') no-repeat center center fixed; background-size: cover; min-height: 100vh; display: flex; flex-direction: column; }
        .overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.45); z-index: -1; }

        header { background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(12px); padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .logo-sec { display: flex; align-items: center; gap: 12px; color: var(--primary); text-decoration: none; }
        .logo-sec img { height: 42px; }
        .logo-sec h1 { font-size: 24px; margin: 0; font-weight: 700; }

        .back-btn { background: var(--primary); color: white; padding: 10px 20px; border-radius: 30px; text-decoration: none; font-size: 14px; font-weight: 500; transition: 0.3s; }
        .back-btn:hover { background: var(--secondary); transform: translateX(-5px); }

        .container { flex: 1; padding: 40px; display: flex; justify-content: center; animation: fadeIn 0.8s; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .table-card { background: rgba(255, 255, 255, 0.95); padding: 35px; border-radius: 20px; width: 100%; max-width: 950px; box-shadow: 0 15px 40px rgba(0,0,0,0.2); }
        .table-card h2 { color: var(--primary); margin: 0 0 20px 0; font-size: 20px; display: flex; align-items: center; gap: 10px; }

        table { width: 100%; border-collapse: collapse; margin-top: 15px; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        th { background: var(--primary); color: white; padding: 18px 15px; text-align: left; font-size: 14px; text-transform: uppercase; letter-spacing: 0.5px; }
        td { padding: 18px 15px; border-bottom: 1px solid #eee; font-size: 15px; color: var(--text-dark); }
        tr:hover { background: #f8fbff; }

        .room-badge { background: #e0fbfc; color: var(--primary); padding: 6px 15px; border-radius: 20px; font-size: 13px; font-weight: 600; border: 1px solid var(--secondary); display: inline-block; }

        .action-links a { font-size: 18px; transition: 0.3s; margin: 0 10px; text-decoration: none; }
        .action-links a:hover { transform: scale(1.2); }

        .alert { padding: 15px 20px; margin-bottom: 20px; border-radius: 8px; font-size: 14px; font-weight: 500; display: flex; align-items: center; gap: 10px; }
        .alert-success { background: #e6fcf5; color: #0f5132; border: 1px solid #c3fae8; }
        .alert-error { background: #fff5f5; color: #c92a2a; border: 1px solid #ffe3e3; }

        footer { text-align: center; padding: 20px; color: rgba(255,255,255,0.9); font-size: 12px; margin-top: auto; background: rgba(0,0,0,0.5); backdrop-filter: blur(5px); }
    </style>
</head>
<body>
<div class="overlay"></div>

<header>
    <a href="<%= dashboardLink %>" class="logo-sec">
        <img src="https://cdn-icons-png.flaticon.com/512/3009/3009489.png" alt="Logo">
        <h1>System Reservations</h1>
    </a>
    <a href="<%= dashboardLink %>" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
</header>

<main class="container">
    <div class="table-card">
        <h2><i class="fa-solid fa-calendar-check"></i> All Bookings List</h2>

        <% if(request.getAttribute("successMessage") != null) { %>
        <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> <%= request.getAttribute("successMessage") %></div>
        <% } %>
        <% if(request.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-error"><i class="fa-solid fa-triangle-exclamation"></i> <%= request.getAttribute("errorMessage") %></div>
        <% } %>

        <table>
            <thead>
            <tr>
                <th>Booking ID</th>
                <th>Room Type</th>
                <th>Check-in Date</th>
                <th>Check-out Date</th>
                <th style="text-align: center;">Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                @SuppressWarnings("unchecked")
                List<Reservation> resList = (List<Reservation>) request.getAttribute("reservationList");

                if (resList != null && !resList.isEmpty()) {
                    for (Reservation r : resList) {
            %>
            <tr>
                <td style="font-weight: 700; color: var(--primary); font-size: 16px;">#<%= r.getReservationId() %></td>
                <td><span class="room-badge"><%= r.getRoomType() %></span></td>
                <td><i class="fa-regular fa-calendar-plus" style="color: var(--secondary); margin-right: 5px;"></i> <%= r.getCheckInDate() %></td>
                <td><i class="fa-regular fa-calendar-minus" style="color: var(--danger); margin-right: 5px;"></i> <%= r.getCheckOutDate() %></td>

                <td style="text-align: center;" class="action-links">

                    <% if(isAdmin) { %>
                    <a href="LoadReservationForEditServlet?id=<%= r.getReservationId() %>" title="Edit Booking" style="color: var(--primary);">
                        <i class="fa-solid fa-pen-to-square"></i>
                    </a>
                    <% } %>

                    <a href="DeleteReservationServlet?id=<%= r.getReservationId() %>" onclick="return confirm('Are you sure you want to cancel and delete this booking?');" title="Delete Booking" style="color: var(--danger);">
                        <i class="fa-solid fa-trash-can"></i>
                    </a>
                </td>
            </tr>
            <%      }
            } else { %>
            <tr>
                <td colspan="5" style="text-align: center; padding: 40px; color: #888;">
                    <i class="fa-solid fa-folder-open" style="font-size: 28px; display: block; margin-bottom: 15px; color: #ccc;"></i>
                    No reservations found in the system.
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</main>

<footer>
    &copy; 2026 Ocean View Resort - Reservation System. All Rights Reserved. <br> Developed for Advanced Programming Assignment.
</footer>
</body>
</html>