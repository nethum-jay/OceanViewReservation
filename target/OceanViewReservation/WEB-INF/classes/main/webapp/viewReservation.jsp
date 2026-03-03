<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>

<%
    String userRole = (String) session.getAttribute("userRole");
    if (userRole == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String dashboardLink = "customerDashboard.jsp";
    boolean isCustomer = "Customer".equals(userRole);

    if ("Staff".equals(userRole)) {
        dashboardLink = "staffDashboard.jsp";
    } else if ("Admin".equals(userRole)) {
        dashboardLink = "adminDashboard.jsp";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View Resort - Search Reservation</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root { --primary: #005f73; --secondary: #0a9396; --text-dark: #1a1a1a; --text-muted: #555; --danger: #e63946; --bg-card: rgba(255, 255, 255, 0.95); }
        body { font-family: 'Poppins', sans-serif; margin: 0; padding: 0; background: url('https://images.unsplash.com/photo-1618140052121-39fc6db33972?q=80&w=2070&auto=format&fit=crop') no-repeat center center fixed; background-size: cover; color: var(--text-dark); min-height: 100vh; display: flex; flex-direction: column; }
        .overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.45); z-index: -1; }

        header { background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(12px); padding: 15px 50px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); }
        .logo-sec { display: flex; align-items: center; gap: 15px; text-decoration: none;}
        .logo-sec img { height: 45px; }
        .logo-sec h1 { margin: 0; font-size: 24px; color: var(--primary); font-weight: 700; }
        .back-btn { background: var(--primary); color: white; padding: 10px 20px; border-radius: 30px; text-decoration: none; font-weight: 500; transition: 0.3s; font-size: 14px; }
        .back-btn:hover { background: var(--secondary); transform: translateY(-2px); box-shadow: 0 5px 15px rgba(10,147,150,0.4); }

        main { flex: 1; display: flex; flex-direction: column; align-items: center; padding: 40px 20px; animation: fadeIn 0.6s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .search-container { background: var(--bg-card); backdrop-filter: blur(15px); padding: 25px 35px; border-radius: 15px; width: 100%; max-width: 550px; text-align: center; box-shadow: 0 10px 30px rgba(0,0,0,0.15); border: 1px solid rgba(255,255,255,0.6); margin-bottom: 30px; display: flex; flex-direction: column; gap: 15px; }
        .search-container form { display: flex; gap: 10px; }
        .search-container input { flex: 1; padding: 12px 15px; border: 1px solid #ccc; border-radius: 8px; font-size: 15px; transition: 0.3s; }
        .search-container input:focus { border-color: var(--secondary); outline: none; box-shadow: 0 0 8px rgba(10,147,150,0.2); }
        .search-container button { background: linear-gradient(135deg, var(--primary), var(--secondary)); color: white; border: none; padding: 0 25px; border-radius: 8px; font-size: 15px; font-weight: 600; cursor: pointer; transition: 0.3s; }
        .search-container button:hover { box-shadow: 0 5px 15px rgba(0,95,115,0.3); transform: translateY(-2px); }

        .list-header { color: white; text-align: center; margin-bottom: 25px; text-shadow: 0 2px 4px rgba(0,0,0,0.5); }

        /* Grid for Multiple Bookings */
        .bookings-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); gap: 25px; width: 100%; max-width: 1100px; justify-content: center; }

        .details-card { background: var(--bg-card); backdrop-filter: blur(15px); padding: 25px; border-radius: 15px; box-shadow: 0 15px 40px rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.6); border-top: 5px solid var(--secondary); transition: 0.3s; }
        .details-card:hover { transform: translateY(-5px); box-shadow: 0 20px 45px rgba(0,0,0,0.3); }
        .details-card h2 { margin-top: 0; color: var(--primary); font-size: 18px; border-bottom: 2px solid #eee; padding-bottom: 15px; margin-bottom: 15px; display: flex; align-items: center; justify-content: space-between; }

        .res-badge { background: #e0fbfc; color: var(--primary); padding: 5px 12px; border-radius: 15px; font-size: 14px; font-weight: 700; border: 1px solid var(--secondary); }

        .detail-row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px dashed #ddd; align-items: center; }
        .detail-row:last-child { border-bottom: none; }
        .detail-row .label { font-weight: 600; color: var(--text-dark); display: flex; align-items: center; gap: 8px; font-size: 14px; }
        .detail-row .label i { color: var(--secondary); width: 18px; text-align: center; font-size: 15px; }
        .detail-row .value { color: var(--text-muted); font-weight: 500; font-size: 14px; text-align: right; }

        .error-msg, .info-msg, .success-msg { font-weight: 600; font-size: 14px; padding: 15px; border-radius: 8px; text-align: center; width: 100%; max-width: 500px; margin-bottom: 20px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .error-msg { background: #fff5f5; color: var(--danger); border-left: 5px solid var(--danger); }
        .success-msg { background: #e6fcf5; color: #0f5132; border-left: 5px solid #c3fae8; }
        .info-msg { background: rgba(255,255,255,0.9); color: var(--primary); border-left: 5px solid var(--secondary); }

        footer { text-align: center; padding: 15px; color: rgba(255,255,255,0.9); font-size: 13px; backdrop-filter: blur(8px); background: rgba(0,0,0,0.6); margin-top: auto; }
    </style>
</head>
<body>

<div class="overlay"></div>

<header>
    <a href="<%= dashboardLink %>" class="logo-sec">
        <img src="https://cdn-icons-png.flaticon.com/512/3009/3009489.png" alt="Logo">
        <h1>Ocean View Resort</h1>
    </a>
    <a href="<%= dashboardLink %>" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
</header>

<main>
    <%-- Show the Search Bar only if you are not a Customer (Admin/Staff). --%>
    <% if (!isCustomer) { %>
    <div class="search-container">
        <h3 style="margin: 0; color: var(--primary); margin-bottom: 10px;">
            <i class="fa-solid fa-magnifying-glass"></i> Search Guest Bookings
        </h3>
        <p style="margin: 0 0 15px; font-size: 13px; color: #666;">Enter <strong>Booking ID</strong> OR <strong>Phone Number</strong></p>
        <form action="ViewReservationServlet" method="GET">
            <input type="text" name="searchValue" placeholder="Booking ID or Phone..." required>
            <button type="submit">Search</button>
        </form>
    </div>
    <% } else { %>
    <div class="list-header">
        <h2><i class="fa-solid fa-suitcase-rolling"></i> My Reservation List</h2>
        <p style="font-size: 14px; opacity: 0.9;">All your past and upcoming stays with us.</p>
    </div>
    <% } %>

    <%-- Success/Error Messages from Cancel Request Servlet --%>
    <% if(request.getAttribute("successMessage") != null) { %>
    <div class="success-msg"><i class="fa-solid fa-circle-check"></i> <%= request.getAttribute("successMessage") %></div>
    <% } %>
    <% if(request.getAttribute("errorMessage") != null) { %>
    <div class="error-msg"><i class="fa-solid fa-circle-exclamation"></i> <%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <div class="bookings-grid">
        <%
            List<Map<String, String>> resList = (List<Map<String, String>>) request.getAttribute("resList");

            if (resList != null && !resList.isEmpty()) {
                for (Map<String, String> details : resList) {
        %>
        <div class="details-card">
            <h2>
                <span><i class="fa-solid fa-bed"></i> Booking Info</span>
                <span class="res-badge">#<%= details.get("reservationID") %></span>
            </h2>

            <div class="detail-row">
                <span class="label"><i class="fa-solid fa-user"></i> Guest Name:</span>
                <span class="value"><%= details.get("name") %></span>
            </div>
            <div class="detail-row">
                <span class="label"><i class="fa-solid fa-phone"></i> Contact No:</span>
                <span class="value"><%= details.get("contactNo") %></span>
            </div>
            <div class="detail-row">
                <span class="label"><i class="fa-solid fa-door-open"></i> Room Type:</span>
                <span class="value" style="font-weight: 700; color: var(--primary);"><%= details.get("roomType") %></span>
            </div>
            <div class="detail-row">
                <span class="label"><i class="fa-solid fa-users"></i> Persons:</span>
                <span class="value"><%= details.get("noOfPersons") != null ? details.get("noOfPersons") : "N/A" %></span>
            </div>
            <div class="detail-row">
                <span class="label"><i class="fa-solid fa-calendar-check"></i> Check-in:</span>
                <span class="value" style="color: var(--secondary); font-weight: 600;"><%= details.get("checkInDate") %></span>
            </div>
            <div class="detail-row" style="border-bottom: none;">
                <span class="label"><i class="fa-solid fa-calendar-xmark"></i> Check-out:</span>
                <span class="value" style="color: var(--danger); font-weight: 600;"><%= details.get("checkOutDate") %></span>
            </div>

            <%-- Status display and Cancel button --%>
            <div style="margin-top: 15px; padding-top: 15px; border-top: 1px dashed #ddd;">
                <% String status = details.get("status") != null ? details.get("status") : "Confirmed"; %>
                <div style="font-size: 13px; font-weight: bold; margin: 0 0 10px; display: flex; justify-content: space-between; align-items: center;">
                    <span style="color: var(--text-dark);">Status:</span>
                    <% if(status.equals("Confirmed")) { %>
                    <span style="color: #0f5132; background: #e6fcf5; padding: 4px 10px; border-radius: 12px;">Confirmed</span>
                    <% } else if(status.equals("Cancel_Requested")) { %>
                    <span style="color: #995e00; background: #fff3cd; padding: 4px 10px; border-radius: 12px;">Cancellation Pending</span>
                    <% } else { %>
                    <span style="color: #842029; background: #f8d7da; padding: 4px 10px; border-radius: 12px;">Cancelled</span>
                    <% } %>
                </div>

                <%-- Only 'Confirmed' status shows the Cancel Request button --%>
                <% if(isCustomer && status.equals("Confirmed")) { %>
                <form action="RequestCancellationServlet" method="POST" style="margin: 0; margin-top: 15px;">
                    <input type="hidden" name="resId" value="<%= details.get("reservationID") %>">
                    <input type="hidden" name="checkInDate" value="<%= details.get("checkInDate") %>">
                    <button type="submit" onclick="return confirm('Are you sure you want to request a cancellation?');"
                            style="background: #e63946; color: white; border: none; padding: 10px 15px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; width: 100%; transition: 0.3s; box-shadow: 0 4px 10px rgba(230,57,70,0.3);">
                        <i class="fa-solid fa-ban"></i> Request Cancellation
                    </button>
                </form>
                <% } %>
            </div>

        </div>
        <%
            }
        } else if (request.getAttribute("resList") != null || isCustomer) {
        %>
        <div class="info-msg" style="grid-column: 1 / -1;">
            <i class="fa-solid fa-folder-open" style="font-size: 24px; display: block; margin-bottom: 10px;"></i>
            No reservations found.
        </div>
        <% } %>
    </div>
</main>

<footer>
    &copy; 2026 Ocean View Resort - Reservation System. All Rights Reserved. <br> Developed for Advanced Programming Assignment.
</footer>

</body>
</html>