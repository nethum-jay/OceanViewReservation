<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.oceanview.model.Reservation" %>
<%
    String loggedUser = (String) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
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
        body { font-family: 'Poppins', sans-serif; margin: 0; background: url('https://images.unsplash.com/photo-1618140052121-39fc6db33972?q=80&w=2070&auto=format&fit=crop') no-repeat center center fixed; background-size: cover; min-height: 100vh; }
        .overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.45); z-index: -1; }
        header { background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(12px); padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; }
        .back-btn { background: var(--primary); color: white; padding: 10px 20px; border-radius: 30px; text-decoration: none; font-size: 14px; font-weight: 500; transition: 0.3s; }
        .back-btn:hover { background: var(--secondary); transform: translateX(-5px); }
        .container { padding: 40px; display: flex; justify-content: center; animation: fadeIn 0.8s; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .table-card { background: rgba(255, 255, 255, 0.95); padding: 35px; border-radius: 20px; width: 100%; max-width: 1050px; box-shadow: 0 15px 40px rgba(0,0,0,0.2); }
        table { width: 100%; border-collapse: collapse; margin-top: 25px; background: white; border-radius: 12px; overflow: hidden; }
        th { background: var(--primary); color: white; padding: 15px; text-align: left; font-size: 14px; text-transform: uppercase; }
        td { padding: 15px; border-bottom: 1px solid #eee; font-size: 14px; color: var(--text-dark); }
        tr:hover { background: #f8fbff; }
        .room-badge { background: #e0fbfc; color: var(--primary); padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; border: 1px solid var(--secondary); }

        /* Action buttons style */
        .action-links a { font-size: 18px; transition: 0.3s; margin: 0 8px; text-decoration: none; }
        .action-links a:hover { transform: scale(1.2); }
    </style>
</head>
<body>
<div class="overlay"></div>
<header>
    <div style="display: flex; align-items: center; gap: 12px; color: var(--primary);">
        <img src="https://cdn-icons-png.flaticon.com/512/3009/3009489.png" height="42">
        <h1 style="font-size: 24px; margin: 0; font-weight: 700;">System Reservations</h1>
    </div>
    <a href="adminDashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
</header>

<main class="container">
    <div class="table-card">
        <h2 style="color: var(--primary); margin: 0; font-size: 20px;"><i class="fa-solid fa-calendar-check"></i> All Bookings List</h2>
        <table>
            <thead>
            <tr>
                <th>Res. ID</th>
                <th>Guest ID</th>
                <th>Room Type</th>
                <th>Check-in Date</th>
                <th>Check-out Date</th>
                <th style="text-align: center;">Persons</th>
                <th style="text-align: center;">Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<Reservation> resList = (List<Reservation>) request.getAttribute("reservationList");
                if (resList != null && !resList.isEmpty()) {
                    for (Reservation r : resList) {
            %>
            <tr>
                <td style="font-weight: 600; color: var(--primary);">#<%= r.getReservationID() %></td>
                <td>G-<%= r.getGuestID() %></td>
                <td><span class="room-badge"><%= r.getRoomType() %></span></td>
                <td><i class="fa-regular fa-calendar-plus" style="color: var(--secondary);"></i> <%= r.getCheckInDate() %></td>
                <td><i class="fa-regular fa-calendar-minus" style="color: var(--danger);"></i> <%= r.getCheckOutDate() %></td>
                <td style="text-align: center;"><%= (r.getNoOfPersons() == 0) ? "-" : r.getNoOfPersons() %></td>

                <td style="text-align: center;" class="action-links">
                    <a href="LoadReservationForEditServlet?id=<%= r.getReservationID() %>" title="Edit Booking" style="color: var(--primary);">
                        <i class="fa-solid fa-pen-to-square"></i>
                    </a>
                    <a href="DeleteReservationServlet?id=<%= r.getReservationID() %>" onclick="return confirm('Are you sure you want to cancel and delete this booking?');" title="Delete Booking" style="color: var(--danger);">
                        <i class="fa-solid fa-trash-can"></i>
                    </a>
                </td>
            </tr>
            <%      }
            } else { %>
            <tr>
                <td colspan="7" style="text-align: center; padding: 30px; color: #888;">
                    <i class="fa-solid fa-folder-open" style="font-size: 24px; display: block; margin-bottom: 10px;"></i>
                    No reservations found in the system.
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</main>
<footer style="text-align: center; padding: 20px; color: white; font-size: 12px; margin-top: auto;">
    &copy; 2026 Ocean View Resort - Reservation System. All Rights Reserved. <br> Developed for Advanced Programming Assignment.
</footer>
</body>
</html>