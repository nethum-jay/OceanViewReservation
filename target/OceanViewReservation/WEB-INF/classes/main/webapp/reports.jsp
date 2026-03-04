<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Security measures: Prevent browser from caching this page after logout
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String loggedUser = (String) session.getAttribute("loggedUser");
    String role = (String) session.getAttribute("userRole");

    // Access control: Ensure only Admin can view system reports
    if (loggedUser == null || !"Admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Handle potential null values if the page is accessed directly bypassing the Servlet
    Object totalUsers = request.getAttribute("totalUsers");
    Object totalBookings = request.getAttribute("totalBookings");

    String displayUsers = (totalUsers != null) ? totalUsers.toString() : "0";
    String displayBookings = (totalBookings != null) ? totalBookings.toString() : "0";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>System Reports - Ocean View</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary: #005f73; --secondary: #0a9396; --text-dark: #1a1a1a; --white: #ffffff; }
        body { font-family: 'Poppins', sans-serif; margin: 0; background: url('https://images.unsplash.com/photo-1618140052121-39fc6db33972?q=80&w=2070&auto=format&fit=crop') no-repeat center center fixed; background-size: cover; min-height: 100vh; display: flex; flex-direction: column; }
        .overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.45); z-index: -1; }

        header { background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(12px); padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .header-title { display: flex; align-items: center; gap: 12px; color: var(--primary); }
        .header-title img { height: 42px; }
        .header-title h1 { font-size: 24px; margin: 0; font-weight: 700; }

        .back-btn { background: var(--primary); color: white; padding: 10px 20px; border-radius: 30px; text-decoration: none; font-size: 14px; font-weight: 500; transition: 0.3s; }
        .back-btn:hover { background: var(--secondary); transform: translateX(-5px); }

        .container { flex: 1; padding: 40px; display: flex; justify-content: center; align-items: center; animation: fadeIn 0.8s; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .report-card { background: rgba(255, 255, 255, 0.95); padding: 40px; border-radius: 20px; width: 100%; max-width: 800px; box-shadow: 0 15px 40px rgba(0,0,0,0.2); text-align: center; }
        .report-card h2 { color: var(--primary); margin-top: 0; font-size: 24px; border-bottom: 2px solid #eee; padding-bottom: 15px; margin-bottom: 30px; }

        .stat-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 30px; }
        .stat-box { background: #f8fbff; border: 1px solid var(--secondary); padding: 30px; border-radius: 15px; transition: 0.3s; }
        .stat-box:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,95,115,0.1); }
        .stat-box i { font-size: 40px; color: var(--secondary); margin-bottom: 15px; }
        .stat-box h3 { margin: 0; font-size: 16px; color: #555; }
        .stat-box .number { font-size: 36px; font-weight: 700; color: var(--primary); margin-top: 10px; }

        footer { text-align: center; padding: 20px; color: rgba(255,255,255,0.9); font-size: 12px; margin-top: auto; background: rgba(0,0,0,0.5); backdrop-filter: blur(5px); }
    </style>
</head>
<body>
<div class="overlay"></div>

<header>
    <div class="header-title">
        <img src="https://cdn-icons-png.flaticon.com/512/3009/3009489.png" alt="Logo">
        <h1>System Performance</h1>
    </div>
    <a href="adminDashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
</header>

<main class="container">
    <div class="report-card">
        <h2><i class="fa-solid fa-chart-line"></i> Summary Report</h2>

        <div class="stat-grid">
            <div class="stat-box">
                <i class="fa-solid fa-users"></i>
                <h3>Total Registered Users</h3>
                <div class="number"><%= displayUsers %></div>
            </div>

            <div class="stat-box">
                <i class="fa-solid fa-bed"></i>
                <h3>Total Room Bookings</h3>
                <div class="number"><%= displayBookings %></div>
            </div>
        </div>

        <p style="color: #888; margin-top: 30px; font-size: 13px;">Data is live from MySQL Database. Generated by Ocean View Reporting System.</p>
    </div>
</main>

<footer>
    &copy; 2026 Ocean View Resort - Reservation System. All Rights Reserved. <br> Developed for Advanced Programming Assignment.
</footer>
</body>
</html>