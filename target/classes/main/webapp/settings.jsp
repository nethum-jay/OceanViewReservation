<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Security measures: Prevent browser from caching this page after logout
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Security Check: Admin data verification
    String loggedUser = (String) session.getAttribute("loggedUser");
    String userRole = (String) session.getAttribute("userRole");

    // Access control: Ensure only Admin can view and edit system settings
    if (userRole == null || !"Admin".equals(userRole)) {
        response.sendRedirect("login.jsp?error=Unauthorized Access!");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>System Settings - Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary: #005f73; --secondary: #0a9396; --accent: #94d2bd; --text-dark: #1a1a1a; --white: #ffffff; }
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

        .settings-card { background: rgba(255, 255, 255, 0.95); padding: 40px; border-radius: 20px; width: 100%; max-width: 600px; box-shadow: 0 15px 40px rgba(0,0,0,0.2); }
        .settings-card h2 { color: var(--primary); margin: 0 0 25px 0; font-size: 22px; border-bottom: 2px solid #eee; padding-bottom: 15px; }

        .form-group { margin-bottom: 20px; text-align: left; }
        .form-group label { display: block; font-size: 14px; font-weight: 600; color: #555; margin-bottom: 8px; }
        .form-group input { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 10px; box-sizing: border-box; font-family: 'Poppins'; transition: 0.3s; }
        .form-group input:focus { border-color: var(--secondary); outline: none; box-shadow: 0 0 8px rgba(10,147,150,0.2); }

        .save-btn { width: 100%; padding: 14px; background: linear-gradient(135deg, var(--primary), var(--secondary)); color: white; border: none; border-radius: 10px; font-weight: 600; cursor: pointer; transition: 0.3s; margin-top: 10px; font-family: 'Poppins', sans-serif;}
        .save-btn:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(0,95,115,0.3); }

        footer { text-align: center; padding: 20px; color: rgba(255,255,255,0.9); font-size: 12px; margin-top: auto; background: rgba(0,0,0,0.5); backdrop-filter: blur(5px); }
    </style>
</head>
<body>
<div class="overlay"></div>

<header>
    <div class="header-title">
        <img src="https://cdn-icons-png.flaticon.com/512/3009/3009489.png" alt="Logo">
        <h1>System Settings</h1>
    </div>
    <a href="adminDashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
</header>

<main class="container">
    <div class="settings-card">
        <h2><i class="fa-solid fa-sliders"></i> General Configuration</h2>

        <form action="#" method="POST" onsubmit="event.preventDefault(); alert('Settings Saved Successfully! (Simulation)');">
            <div class="form-group">
                <label>Resort Name</label>
                <input type="text" name="resortName" value="Ocean View Resort" required>
            </div>

            <div class="form-group">
                <label>Contact Email</label>
                <input type="email" name="contactEmail" value="info@oceanview.com" required>
            </div>

            <div class="form-group">
                <label>Contact Number</label>
                <input type="tel" name="contactNo" value="+94 11 234 5678" required>
            </div>

            <div class="form-group">
                <label>Resort Address</label>
                <input type="text" name="address" value="463/1G, Athurugiriya Road, Malabe, Sri Lanka" required>
            </div>

            <button type="submit" class="save-btn">
                <i class="fa-solid fa-cloud-arrow-up"></i> Update System Settings
            </button>
        </form>

        <p style="color: #888; font-size: 12px; margin-top: 20px; text-align: center;">
            Last Updated: 2026-03-04 | Version 1.0.4
        </p>
    </div>
</main>

<footer>
    &copy; 2026 Ocean View Resort - Reservation System. All Rights Reserved. <br> Developed for Advanced Programming Assignment.
</footer>
</body>
</html>