<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View Resort - Display Reservation</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --primary: #005f73;
            --secondary: #0a9396;
            --accent: #94d2bd;
            --text-dark: #1a1a1a;
            --text-muted: #555;
            --white: #ffffff;
            --danger: #e63946;
        }

        body {
            font-family: 'Poppins', sans-serif;
            margin: 0; padding: 0;
            background: url('https://images.unsplash.com/photo-1618140052121-39fc6db33972?q=80&w=2070&auto=format&fit=crop') no-repeat center center fixed;
            background-size: cover;
            color: var(--text-dark);
            min-height: 100vh;
            display: flex; flex-direction: column;
        }

        .overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.45); z-index: -1; }

        /* Header Styling */
        header {
            background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(12px);
            padding: 15px 50px; display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
        }
        .logo-sec { display: flex; align-items: center; gap: 15px; }
        .logo-sec img { height: 45px; }
        .logo-sec h1 { margin: 0; font-size: 24px; color: var(--primary); font-weight: 700; }

        .back-btn {
            background: var(--primary); color: white; padding: 10px 20px; border-radius: 30px;
            text-decoration: none; font-weight: 500; transition: 0.3s; font-size: 14px;
        }
        .back-btn:hover { background: var(--secondary); transform: translateY(-2px); box-shadow: 0 5px 15px rgba(10,147,150,0.4); }

        main { flex: 1; display: flex; flex-direction: column; align-items: center; padding: 40px 20px; animation: fadeIn 0.6s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        /* Search Container (Glass Effect) */
        .search-container {
            background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(15px);
            padding: 25px 35px; border-radius: 15px; width: 100%; max-width: 550px; text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15); border: 1px solid rgba(255,255,255,0.6);
            margin-bottom: 30px; display: flex; flex-direction: column; gap: 15px;
        }
        .search-container form { display: flex; gap: 10px; }
        .search-container input {
            flex: 1; padding: 12px 15px; border: 1px solid #ccc; border-radius: 8px;
            font-size: 15px; font-family: 'Poppins', sans-serif; transition: 0.3s;
        }
        .search-container input:focus { border-color: var(--secondary); outline: none; box-shadow: 0 0 8px rgba(10,147,150,0.2); }
        .search-container button {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white; border: none; padding: 0 25px; border-radius: 8px; font-size: 15px;
            font-weight: 600; cursor: pointer; transition: 0.3s; font-family: 'Poppins', sans-serif;
        }
        .search-container button:hover { box-shadow: 0 5px 15px rgba(0,95,115,0.3); transform: translateY(-2px); }

        /* Details Card (Glass Effect) */
        .details-card {
            background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(15px);
            padding: 35px; border-radius: 15px; width: 100%; max-width: 600px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.6);
            border-top: 6px solid var(--secondary);
        }
        .details-card h2 { margin-top: 0; color: var(--primary); font-size: 22px; border-bottom: 2px solid #eee; padding-bottom: 15px; margin-bottom: 20px; display: flex; align-items: center; justify-content: space-between; }

        .detail-row { display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px dashed #ddd; align-items: center; }
        .detail-row:last-child { border-bottom: none; }
        .detail-row .label { font-weight: 600; color: var(--text-dark); display: flex; align-items: center; gap: 10px; font-size: 15px; }
        .detail-row .label i { color: var(--secondary); width: 20px; text-align: center; font-size: 16px; }
        .detail-row .value { color: var(--text-muted); font-weight: 500; font-size: 15px; text-align: right; }

        /* Error Alert */
        .error-msg { color: var(--danger); font-weight: 600; font-size: 14px; background: #ffe6e6; padding: 12px; border-radius: 8px; border: 1px solid var(--danger); text-align: center; width: 100%; max-width: 500px; }

        footer { text-align: center; padding: 15px; color: rgba(255,255,255,0.9); font-size: 13px; backdrop-filter: blur(8px); background: rgba(0,0,0,0.6); margin-top: auto; }
    </style>
</head>
<body>

<div class="overlay"></div>

<header>
    <div class="logo-sec">
        <img src="https://cdn-icons-png.flaticon.com/512/3009/3009489.png" alt="Logo">
        <h1>Ocean View Resort</h1>
    </div>
    <a href="staff_dashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
</header>

<main>
    <div class="search-container">
        <h3 style="margin: 0; color: var(--primary);"><i class="fa-solid fa-magnifying-glass"></i> Search Reservation</h3>
        <form action="ViewReservationServlet" method="GET">
            <input type="text" name="guestID" placeholder="Enter Guest ID (e.g. 1)" required>
            <button type="submit">Search</button>
        </form>
    </div>

    <% if(request.getAttribute("errorMessage") != null) { %>
    <div class="error-msg"><i class="fa-solid fa-circle-exclamation"></i> <%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <%
        Map<String, String> details = (Map<String, String>) request.getAttribute("resDetails");
        if(details != null) {
    %>
    <div class="details-card">
        <h2><span>Booking Information</span> <span style="font-size: 16px; color: var(--text-muted);"><i class="fa-solid fa-hashtag"></i> <%= details.get("reservationID") %></span></h2>

        <div class="detail-row">
            <span class="label"><i class="fa-solid fa-user"></i> Guest Full Name:</span>
            <span class="value"><%= details.get("name") %></span>
        </div>
        <div class="detail-row">
            <span class="label"><i class="fa-solid fa-map-location-dot"></i> Guest Address:</span>
            <span class="value"><%= details.get("address") %></span>
        </div>
        <div class="detail-row">
            <span class="label"><i class="fa-solid fa-phone"></i> Contact Number:</span>
            <span class="value"><%= details.get("contactNo") %></span>
        </div>
        <div class="detail-row">
            <span class="label"><i class="fa-solid fa-door-open"></i> Room Type:</span>
            <span class="value"><%= details.get("roomType") %></span>
        </div>
        <div class="detail-row">
            <span class="label"><i class="fa-solid fa-calendar-check"></i> Check-in Date:</span>
            <span class="value"><%= details.get("checkInDate") %></span>
        </div>
        <div class="detail-row">
            <span class="label"><i class="fa-solid fa-calendar-xmark"></i> Check-out Date:</span>
            <span class="value"><%= details.get("checkOutDate") %></span>
        </div>
    </div>
    <% } %>
</main>

<footer>
    &copy; 2026 Ocean View Resort - Reservation System. All Rights Reserved. <br> Developed for Advanced Programming Assignment.
</footer>

</body>
</html>