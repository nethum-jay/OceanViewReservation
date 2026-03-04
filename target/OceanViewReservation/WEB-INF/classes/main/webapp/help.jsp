<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Security measures: Prevent browser from caching this page after logout
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String userRole = (String) session.getAttribute("userRole");

    // Immediately redirect to login if the user is not authenticated
    if (userRole == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Determine the correct dashboard link based on the user's role
    String dashboardLink = "customerDashboard.jsp";
    if ("Admin".equals(userRole)) {
        dashboardLink = "adminDashboard.jsp";
    } else if ("Staff".equals(userRole)) {
        dashboardLink = "staffDashboard.jsp";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View Resort - Help & Guidelines</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary: #005f73; --secondary: #0a9396; --accent: #94d2bd; --text-dark: #1a1a1a; --text-muted: #555; --white: #ffffff; }
        body { font-family: 'Poppins', sans-serif; margin: 0; padding: 0; background: url('https://images.unsplash.com/photo-1618140052121-39fc6db33972?q=80&w=2070&auto=format&fit=crop') no-repeat center center fixed; background-size: cover; color: var(--text-dark); min-height: 100vh; display: flex; flex-direction: column; }
        .overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.45); z-index: -1; }

        header { background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(12px); padding: 15px 50px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); }
        .logo-sec { display: flex; align-items: center; gap: 15px; }
        .logo-sec img { height: 45px; }
        .logo-sec h1 { margin: 0; font-size: 24px; color: var(--primary); font-weight: 700; }
        .back-btn { background: var(--primary); color: white; padding: 10px 20px; border-radius: 30px; text-decoration: none; font-weight: 500; transition: 0.3s; font-size: 14px; }
        .back-btn:hover { background: var(--secondary); transform: translateY(-2px); box-shadow: 0 5px 15px rgba(10,147,150,0.4); }

        main { flex: 1; display: flex; justify-content: center; align-items: center; padding: 40px 20px; animation: fadeIn 0.6s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .help-container { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(15px); padding: 40px; border-radius: 20px; width: 100%; max-width: 850px; box-shadow: 0 15px 40px rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.6); }
        .help-container h2 { color: var(--primary); font-size: 28px; font-weight: 700; margin-top: 0; border-bottom: 2px solid #eef2f5; padding-bottom: 15px; margin-bottom: 15px; display: flex; align-items: center; gap: 10px; }
        .help-container p.intro { color: var(--text-muted); font-size: 15px; margin-bottom: 30px; line-height: 1.6; }

        .guide-card { background: rgba(255, 255, 255, 0.6); border-left: 5px solid var(--secondary); padding: 25px; margin-bottom: 20px; border-radius: 12px; transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(0,0,0,0.03); border-top: 1px solid rgba(255,255,255,0.8); border-right: 1px solid rgba(255,255,255,0.8); border-bottom: 1px solid rgba(255,255,255,0.8); }
        .guide-card:hover { transform: translateX(8px); box-shadow: 0 8px 25px rgba(0,95,115,0.1); background: rgba(255, 255, 255, 0.9); border-left-color: var(--primary); }
        .guide-card h3 { margin-top: 0; color: var(--text-dark); font-size: 18px; font-weight: 600; display: flex; align-items: center; margin-bottom: 12px; }
        .guide-card h3 i { margin-right: 12px; font-size: 22px; color: var(--secondary); background: rgba(10, 147, 150, 0.1); padding: 10px; border-radius: 50%; }
        .guide-card p { color: var(--text-muted); line-height: 1.6; margin-bottom: 0; font-size: 14px; font-weight: 500; }
        .guide-card ul { margin-top: 12px; color: var(--text-muted); padding-left: 25px; font-size: 14px; }
        .guide-card ul li { margin-bottom: 8px; line-height: 1.5; }
        .guide-card ul li b { color: var(--text-dark); }

        .contact-info { margin-top: 40px; padding-top: 25px; border-top: 2px dashed #ddd; display: flex; flex-direction: column; align-items: center; text-align: center; }
        .contact-info h3 { color: var(--primary); font-size: 20px; margin: 0 0 15px 0; }
        .contact-grid { display: flex; flex-wrap: wrap; gap: 20px; justify-content: center; width: 100%; }
        .contact-item { background: #f8fbff; padding: 15px 20px; border-radius: 10px; border: 1px solid #e0eaf5; display: flex; flex-direction: column; align-items: center; gap: 8px; min-width: 180px; }
        .contact-item i { font-size: 20px; color: var(--secondary); }
        .contact-item span { font-size: 13px; font-weight: 600; color: var(--text-dark); }
        .contact-item p { margin: 0; font-size: 13px; color: var(--text-muted); }

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
    <a href="<%= dashboardLink %>" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
</header>

<main>
    <div class="help-container">
        <h2><i class="fa-solid fa-circle-info"></i> System User Guidelines</h2>
        <p class="intro">Welcome to the Ocean View Resort Reservation System. This guide provides step-by-step instructions to navigate and manage bookings effectively.</p>

        <div class="guide-card">
            <h3><i class="fa-solid fa-shield-halved"></i> 1. System Access (Login)</h3>
            <p>All users must log in to access the system securely.</p>
            <ul>
                <li>Navigate to the <b>Login Page</b>.</li>
                <li>Enter your assigned <b>Username</b> and <b>Password</b>.</li>
                <li>Ensure you do not share your credentials with unauthorized personnel.</li>
            </ul>
        </div>

        <div class="guide-card">
            <h3><i class="fa-solid fa-calendar-plus"></i> 2. Managing Reservations</h3>
            <p>Use the booking module to create new reservations.</p>
            <ul>
                <li>Go to the <b>New Reservation</b> module.</li>
                <li>Fill in the Guest Details (Name, NIC, Contact Number).</li>
                <li>Select the Room Type and enter Check-in / Check-out dates.</li>
                <li>Click Save. The system will auto-generate the booking ID.</li>
            </ul>
        </div>

        <div class="guide-card">
            <h3><i class="fa-solid fa-magnifying-glass"></i> 3. Displaying Booking Details</h3>
            <p>Use this feature to search for an existing booking in the system.</p>
            <ul>
                <li>Navigate to the <b>Search Bookings</b> page.</li>
                <li>Enter the guest's <b>Booking ID</b> or <b>Phone Number</b> in the search box.</li>
                <li>Click <b>Search</b> to view full details securely from the database.</li>
            </ul>
        </div>

        <div class="guide-card">
            <h3><i class="fa-solid fa-file-invoice-dollar"></i> 4. Generating the Invoice</h3>
            <p>Generate an official bill when a guest is checking out.</p>
            <ul>
                <li>Go to the <b>Print Bills</b> section.</li>
                <li>Search using the Booking ID.</li>
                <li>The system will automatically calculate the total cost.</li>
                <li>Click the <b>Print Invoice</b> button to save or hand over a copy to the guest.</li>
            </ul>
        </div>

        <div class="contact-info">
            <h3><i class="fa-solid fa-headset"></i> Need Further Assistance?</h3>
            <div class="contact-grid">
                <div class="contact-item">
                    <i class="fa-solid fa-hotel"></i>
                    <span>Resort Name</span>
                    <p>Ocean View Resort</p>
                </div>
                <div class="contact-item">
                    <i class="fa-solid fa-envelope"></i>
                    <span>Email Us</span>
                    <p>info@oceanview.com</p>
                </div>
                <div class="contact-item">
                    <i class="fa-solid fa-phone"></i>
                    <span>Call Us</span>
                    <p>+94 11 234 5678</p>
                </div>
                <div class="contact-item" style="min-width: 250px;">
                    <i class="fa-solid fa-map-location-dot"></i>
                    <span>Location</span>
                    <p>463/1G, Athurugiriya Road,<br>Malabe, Sri Lanka</p>
                </div>
            </div>
        </div>

    </div>
</main>

<footer>
    &copy; 2026 Ocean View Resort - Reservation System. All Rights Reserved. <br> Developed for Advanced Programming Assignment.
</footer>

</body>
</html>