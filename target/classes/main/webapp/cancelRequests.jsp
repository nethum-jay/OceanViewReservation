<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    // Security measures: Prevent browser from caching this page after logout
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Access control: Ensure only Admin can view cancellation requests
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"Admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cancel Requests - Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary: #005f73; --secondary: #0a9396; --text-dark: #1a1a1a; --danger: #e63946; --warning: #ff9f1c; }
        body { font-family: 'Poppins', sans-serif; margin: 0; background: url('https://images.unsplash.com/photo-1618140052121-39fc6db33972?q=80&w=2070&auto=format&fit=crop') no-repeat center center fixed; background-size: cover; min-height: 100vh; display: flex; flex-direction: column; }
        .overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.5); z-index: -1; }

        header { background: rgba(255, 255, 255, 0.9); padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; }
        .logo-sec { display: flex; align-items: center; gap: 12px; color: var(--primary); text-decoration: none; font-weight: bold; font-size: 20px;}
        .back-btn { background: var(--primary); color: white; padding: 8px 18px; border-radius: 25px; text-decoration: none; font-size: 14px; font-weight: 500; }

        .container { flex: 1; padding: 40px; display: flex; justify-content: center; animation: fadeIn 0.5s; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .table-card { background: rgba(255, 255, 255, 0.95); padding: 35px; border-radius: 20px; width: 100%; max-width: 800px; box-shadow: 0 15px 40px rgba(0,0,0,0.2); }
        .table-card h2 { color: #d47e00; margin: 0 0 20px 0; display: flex; align-items: center; gap: 10px; }

        table { width: 100%; border-collapse: collapse; margin-top: 15px; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        th { background: #ff9f1c; color: white; padding: 15px; text-align: left; font-size: 14px; }
        td { padding: 15px; border-bottom: 1px solid #eee; font-size: 14px; color: var(--text-dark); }
        tr:hover { background: #fffdf5; }

        .approve-btn { background: var(--danger); color: white; padding: 8px 15px; border-radius: 8px; text-decoration: none; font-size: 13px; font-weight: 600; transition: 0.3s; display: inline-block;}
        .approve-btn:hover { background: #d90429; box-shadow: 0 4px 10px rgba(230,57,70,0.3); }

        .empty-msg { text-align: center; padding: 40px; color: #888; }
    </style>
</head>
<body>
<div class="overlay"></div>

<header>
    <a href="adminDashboard.jsp" class="logo-sec">
        <i class="fa-solid fa-hotel"></i> Ocean View Resort
    </a>
    <a href="adminDashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
</header>

<main class="container">
    <div class="table-card">
        <h2><i class="fa-solid fa-ban"></i> Pending Cancellation Requests</h2>
        <p style="font-size: 14px; color: #555; margin-bottom: 20px;">Customers have requested to cancel the following bookings.</p>

        <table>
            <thead>
            <tr>
                <th>Booking ID</th>
                <th>Guest Name</th>
                <th>Check-in Date</th>
                <th>Status</th>
                <th style="text-align: center;">Action</th>
            </tr>
            </thead>
            <tbody>
            <%
                @SuppressWarnings("unchecked")
                List<Map<String, String>> cancelList = (List<Map<String, String>>) request.getAttribute("cancelList");

                if (cancelList != null && !cancelList.isEmpty()) {
                    for (Map<String, String> req : cancelList) {
            %>
            <tr>
                <td style="font-weight: bold; color: var(--primary);">#<%= req.get("reservationID") %></td>
                <td><%= req.get("name") %></td>
                <td style="color: var(--secondary); font-weight: 600;"><%= req.get("checkInDate") %></td>
                <td><span style="color: #995e00; background: #fff3cd; padding: 5px 10px; border-radius: 10px; font-size: 12px; font-weight: 600;">Requested</span></td>

                <td style="text-align: center;">
                    <a href="DeleteReservationServlet?id=<%= req.get("reservationID") %>"
                       onclick="return confirm('Are you sure you want to approve this cancellation and delete the booking?');"
                       class="approve-btn">
                        <i class="fa-solid fa-check"></i> Approve & Delete
                    </a>
                </td>
            </tr>
            <%      }
            } else { %>
            <tr>
                <td colspan="5" class="empty-msg">
                    <i class="fa-regular fa-face-smile-wink" style="font-size: 30px; display: block; margin-bottom: 10px; color: #ccc;"></i>
                    Great! There are no pending cancellation requests.
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</main>
</body>
</html>