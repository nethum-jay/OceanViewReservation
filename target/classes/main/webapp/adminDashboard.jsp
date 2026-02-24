<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String loggedUser = (String) session.getAttribute("loggedUser");
    String userRole = (String) session.getAttribute("userRole");
    Integer userId = (Integer) session.getAttribute("userId");

    // Security Check Admin
    if (userRole == null || !"Admin".equals(userRole)) {
        response.sendRedirect("login.jsp?error=Unauthorized Access!");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Premium</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary: #005f73; --secondary: #0a9396; --accent: #94d2bd; --text-dark: #1a1a1a; --text-muted: #555; --white: #ffffff; --danger: #e63946; }
        body { font-family: 'Poppins', sans-serif; margin: 0; padding: 0; background: url('https://images.unsplash.com/photo-1618140052121-39fc6db33972?q=80&w=2070&auto=format&fit=crop') no-repeat center center fixed; background-size: cover; color: var(--text-dark); min-height: 100vh; display: flex; flex-direction: column; }
        .overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.4); z-index: -1; }
        header { background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(12px); padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); }
        .logo-sec { display: flex; align-items: center; gap: 15px; }
        .logo-sec img { height: 45px; }
        .logo-sec h1 { margin: 0; font-size: 24px; color: var(--primary); font-weight: 700; }
        .header-buttons { display: flex; gap: 15px; align-items: center; }
        .nav-btn { padding: 10px 20px; border-radius: 30px; text-decoration: none; font-weight: 600; font-size: 14px; transition: all 0.3s ease; display: flex; align-items: center; gap: 8px; }
        .logout-btn { background: var(--danger); color: white; }
        .logout-btn:hover { background: #d90429; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(230,57,70,0.4); }
        main { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 40px 20px; animation: fadeIn 0.8s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .dashboard-wrapper { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(15px); padding: 40px; border-radius: 20px; width: 100%; max-width: 1000px; box-shadow: 0 15px 40px rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.6); }
        .welcome-header { text-align: center; margin-bottom: 40px; }
        .welcome-header h2 { color: var(--primary); font-size: 32px; font-weight: 700; margin-bottom: 8px; margin-top: 0; }
        .welcome-header p { color: var(--text-muted); font-size: 15px; margin: 0; }
        .user-badge { display: inline-block; background: #e0fbfc; color: var(--primary); padding: 5px 15px; border-radius: 20px; font-size: 14px; font-weight: 600; margin-top: 10px; border: 1px solid var(--secondary); }
        .grid-container { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; justify-content: center; }
        .card { background: var(--white); padding: 30px 15px; border-radius: 16px; text-align: center; text-decoration: none; color: var(--text-dark); transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); border: 1px solid #eef2f5; box-shadow: 0 5px 15px rgba(0,0,0,0.04); display: flex; flex-direction: column; align-items: center; }
        .card:hover { transform: translateY(-8px); box-shadow: 0 15px 30px rgba(0,95,115,0.15); border-color: var(--accent); }
        .icon-box { width: 60px; height: 60px; background: linear-gradient(135deg, var(--primary), var(--secondary)); color: var(--white); border-radius: 50%; display: flex; justify-content: center; align-items: center; font-size: 24px; margin-bottom: 15px; transition: 0.4s; box-shadow: 0 8px 20px rgba(10,147,150,0.3); }
        .card:hover .icon-box { transform: scale(1.1) rotate(5deg); }
        .card h3 { font-size: 16px; font-weight: 600; margin-bottom: 10px; margin-top: 0; }
        .card p { font-size: 12px; color: var(--text-muted); line-height: 1.5; margin: 0; }
        footer { text-align: center; padding: 20px; color: rgba(255,255,255,0.9); font-size: 13px; backdrop-filter: blur(8px); background: rgba(0,0,0,0.6); margin-top: auto; }
    </style>
</head>
<body>

<div class="overlay"></div>

<header>
    <div class="logo-sec">
        <img src="https://cdn-icons-png.flaticon.com/512/3009/3009489.png" alt="Logo">
        <h1>Ocean View Resort</h1>
    </div>
    <div class="header-buttons">
        <span style="font-weight: 600; color: var(--primary); margin-right: 15px; font-size: 15px;">
            <i class="fa-solid fa-user-shield" style="color: var(--secondary); font-size: 18px; margin-right: 5px;"></i>
            <span style="text-transform: capitalize;"><%= loggedUser %></span>
        </span>
        <a href="LogoutServlet" class="nav-btn logout-btn"><i class="fa-solid fa-power-off"></i> Logout</a>
    </div>
</header>

<main>
    <div class="dashboard-wrapper">
        <div class="welcome-header">
            <h2>Welcome back, <span style="text-transform: capitalize; color: var(--secondary);"><%= loggedUser %></span>!</h2>
            <div class="user-badge" style="background: #eef2f5; color: #333; margin-right: 10px;">
                <i class="fa-solid fa-id-badge"></i> Your ID: <%= userId %>
            </div>
            <div class="user-badge"><i class="fa-solid fa-shield"></i> Role: <%= userRole %></div>
            <p style="margin-top: 15px;">System Overview and Management Panel.</p>
        </div>

        <div class="grid-container">
            <a href="ManageUsersServlet" class="card">
                <div class="icon-box"><i class="fa-solid fa-users-gear"></i></div>
                <h3>Manage Users</h3>
                <p>Add, edit or remove users.</p>
            </a>
            <a href="viewReservations.jsp" class="card">
                <div class="icon-box"><i class="fa-solid fa-calendar-alt"></i></div>
                <h3>All Bookings</h3>
                <p>View all system reservations.</p>
            </a>
            <a href="reports.jsp" class="card">
                <div class="icon-box"><i class="fa-solid fa-chart-pie"></i></div>
                <h3>View Reports</h3>
                <p>Analyze system performance.</p>
            </a>
            <a href="settings.jsp" class="card">
                <div class="icon-box"><i class="fa-solid fa-cogs"></i></div>
                <h3>System Settings</h3>
                <p>Configure application details.</p>
            </a>
        </div>
    </div>
</main>

<footer>
    &copy; 2026 Ocean View Resort - Reservation System. All Rights Reserved. <br> Developed for Advanced Programming Assignment.
</footer>

</body>
</html>