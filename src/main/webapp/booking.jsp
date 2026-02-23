<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get the logged in user's information (for Auto-fill)
    String loggedUser = (String) session.getAttribute("loggedUser");
    String userRole = (String) session.getAttribute("userRole");

    // Security: Send to login page if not logged in to the system
    if (loggedUser == null) {
        response.sendRedirect("login.jsp?error=Please Login to Book a Room");
        return;
    }

    // Determine the link associated with the Role to return to the Dashboard
    String dashboardLink = "customer_dashboard.jsp";
    if ("Admin".equals(userRole)) { dashboardLink = "admin_dashboard.jsp"; }
    else if ("Staff".equals(userRole)) { dashboardLink = "staff_dashboard.jsp"; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View Resort - Book Your Stay</title>

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
            --error: #e63946;
            --success: #2a9d8f;
            --bg-light: #f9fbfd;
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
            background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(12px);
            padding: 15px 40px; display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }
        .logo-sec { display: flex; align-items: center; gap: 15px; text-decoration: none; }
        .logo-sec img { height: 40px; }
        .logo-sec h1 { margin: 0; font-size: 22px; color: var(--primary); font-weight: 700; letter-spacing: 0.5px; }

        .back-btn {
            background: var(--primary); color: white; padding: 8px 18px; border-radius: 25px;
            text-decoration: none; font-weight: 500; transition: 0.3s; font-size: 14px;
            display: flex; align-items: center; gap: 8px;
        }
        .back-btn:hover { background: var(--secondary); transform: translateY(-2px); box-shadow: 0 5px 15px rgba(10,147,150,0.3); }

        /* Form Container - Glassmorphism */
        main { flex: 1; display: flex; justify-content: center; align-items: center; padding: 40px 20px; animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }

        .form-wrapper {
            background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(20px);
            border-radius: 24px; width: 100%; max-width: 800px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.15); border: 1px solid rgba(255,255,255,0.8);
            overflow: hidden; display: flex; flex-direction: column;
        }

        .form-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 30px; text-align: center; color: white;
        }
        .form-header h2 { margin: 0; font-size: 28px; font-weight: 700; letter-spacing: 1px; }
        .form-header p { margin: 10px 0 0; font-size: 14px; opacity: 0.9; }

        .form-body { padding: 40px; }

        /* Section Titles */
        .section-title {
            font-size: 18px; color: var(--primary); font-weight: 600; margin-top: 0; margin-bottom: 20px;
            display: flex; align-items: center; gap: 10px; border-bottom: 2px solid var(--bg-light); padding-bottom: 10px;
        }
        .section-title i { color: var(--secondary); }

        /* Grid Layout for Inputs */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px; }
        .full-width { grid-column: span 2; }

        /* Input Fields */
        .input-group { position: relative; }
        .input-group label { display: block; font-weight: 500; color: var(--text-dark); font-size: 13px; margin-bottom: 6px; }
        .input-icon { position: absolute; top: 38px; left: 15px; color: var(--secondary); font-size: 16px; z-index: 2; transition: 0.3s; }

        .input-group input, .input-group select {
            width: 100%; padding: 12px 15px 12px 42px; border: 1.5px solid #e0e5e9; border-radius: 12px;
            font-size: 14px; font-family: 'Poppins', sans-serif; transition: all 0.3s ease; box-sizing: border-box;
            background: var(--bg-light); color: var(--text-dark);
        }

        .input-group input:focus, .input-group select:focus {
            border-color: var(--secondary); outline: none; box-shadow: 0 0 0 4px rgba(10,147,150,0.1); background: white;
        }
        .input-group input:focus + .input-icon, .input-group select:focus + .input-icon { color: var(--primary); }

        /* Specific Select Styling */
        select { appearance: none; -webkit-appearance: none; -moz-appearance: none; cursor: pointer; }
        .select-wrapper::after {
            content: '\f107'; font-family: 'Font Awesome 6 Free'; font-weight: 900;
            position: absolute; right: 15px; top: 38px; color: var(--text-muted); pointer-events: none;
        }

        /* Submit Button */
        .submit-btn {
            width: 100%; background: linear-gradient(135deg, var(--secondary), var(--primary));
            color: white; border: none; padding: 16px; border-radius: 12px; font-size: 16px;
            font-weight: 600; cursor: pointer; transition: all 0.3s ease; font-family: 'Poppins', sans-serif;
            box-shadow: 0 8px 20px rgba(0,95,115,0.25); letter-spacing: 0.5px; display: flex; justify-content: center; align-items: center; gap: 10px;
        }
        .submit-btn:hover { transform: translateY(-3px); box-shadow: 0 12px 25px rgba(0,95,115,0.35); }
        .submit-btn:active { transform: translateY(1px); }

        /* Alerts */
        .alert { padding: 15px 20px; border-radius: 12px; font-size: 14px; font-weight: 500; margin-bottom: 25px; display: flex; align-items: center; gap: 12px; animation: slideDown 0.4s ease; }
        @keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
        .alert i { font-size: 18px; }
        .alert.error { background: #fff0f0; color: var(--error); border-left: 4px solid var(--error); }
        .alert.success { background: #f0fdfa; color: var(--success); border-left: 4px solid var(--success); }

        footer { text-align: center; padding: 15px; color: rgba(255,255,255,0.8); font-size: 12px; background: rgba(0,0,0,0.5); backdrop-filter: blur(5px); margin-top: auto; }

        /* Mobile Responsive */
        @media (max-width: 768px) {
            .form-grid { grid-template-columns: 1fr; gap: 15px; }
            .full-width { grid-column: span 1; }
            .form-body { padding: 25px; }
            .form-header { padding: 20px; }
        }
        /* Room Availability Styles */
        .availability-panel {
            background: #e0fbfc; border: 1px solid var(--secondary); border-radius: 12px;
            padding: 20px; margin-bottom: 25px; text-align: center;
        }
        .availability-panel h4 { margin: 0 0 15px 0; color: var(--primary); font-size: 16px; font-weight: 600; }
        .room-stats { display: flex; justify-content: space-around; gap: 15px; flex-wrap: wrap; }
        .stat-box {
            background: white; padding: 12px 20px; border-radius: 10px; flex: 1; min-width: 100px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05); border-bottom: 3px solid var(--secondary);
            display: flex; flex-direction: column; align-items: center; transition: 0.3s;
        }
        .stat-box:hover { transform: translateY(-3px); box-shadow: 0 6px 15px rgba(0,0,0,0.1); }
        .stat-box i { font-size: 24px; color: var(--secondary); margin-bottom: 8px; }
        .stat-box .type { font-size: 13px; font-weight: 600; color: var(--text-dark); }
        .stat-box .count { font-size: 18px; font-weight: 700; color: var(--primary); margin-top: 5px; }
    </style>
</head>
<body>

<div class="overlay"></div>

<header>
    <a href="<%= dashboardLink %>" class="logo-sec">
        <img src="https://cdn-icons-png.flaticon.com/512/3009/3009489.png" alt="Ocean View Logo">
        <h1>Ocean View Resort</h1>
    </a>
    <a href="<%= dashboardLink %>" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Dashboard</a>
</header>

<main>
    <div class="form-wrapper">
        <div class="form-header">
            <h2>Book Your Stay</h2>
            <p>Experience luxury and comfort at Ocean View Resort. Reserve your room today.</p>
        </div>

        <div class="form-body">
            <div class="availability-panel">
                <h4><i class="fa-solid fa-chart-pie"></i> Available Rooms for Selected Dates</h4>
                <div class="room-stats">
                    <div class="stat-box">
                        <i class="fa-solid fa-bed"></i>
                        <span class="type">Single Room</span>
                        <span class="count" id="singleCount">--</span>
                    </div>
                    <div class="stat-box">
                        <i class="fa-solid fa-user-group"></i>
                        <span class="type">Double Room</span>
                        <span class="count" id="doubleCount">--</span>
                    </div>
                    <div class="stat-box">
                        <i class="fa-solid fa-star"></i>
                        <span class="type">Luxury Suite</span>
                        <span class="count" id="suiteCount">--</span>
                    </div>
                </div>
                <p style="font-size: 12px; color: var(--text-muted); margin: 10px 0 0 0;">
                    * Select Check-In and Check-Out dates to see real-time availability.
                </p>
            </div>
            <%-- Alert Messages --%>
            <% if(request.getAttribute("successMessage") != null) { %>
            <div class="alert success"><i class="fa-solid fa-circle-check"></i> <%= request.getAttribute("successMessage") %></div>
            <% } else if(request.getAttribute("errorMessage") != null) { %>
            <div class="alert error"><i class="fa-solid fa-circle-exclamation"></i> <%= request.getAttribute("errorMessage") %></div>
            <% } %>

            <%-- Form Action is directed to AddNewReservationServlet as it handles the combined logic --%>
            <form action="AddNewReservationServlet" method="POST">

                <h3 class="section-title"><i class="fa-solid fa-user-circle"></i> Guest Details</h3>
                <div class="form-grid">
                    <div class="input-group full-width">
                        <label>Full Name</label>
                        <i class="fa-solid fa-user input-icon"></i>
                        <input type="text" name="guestName" value="<%= loggedUser != null ? loggedUser : "" %>" required placeholder="E.g. John Doe">
                    </div>

                    <div class="input-group">
                        <label>NIC / Passport Number</label>
                        <i class="fa-solid fa-id-card input-icon"></i>
                        <input type="text" name="nic" placeholder="Enter NIC or Passport" required>
                    </div>

                    <div class="input-group">
                        <label>Email Address</label>
                        <i class="fa-solid fa-envelope input-icon"></i>
                        <input type="email" name="email" placeholder="john@example.com" required>
                    </div>

                    <div class="input-group full-width">
                        <label>Residential Address</label>
                        <i class="fa-solid fa-map-location-dot input-icon"></i>
                        <input type="text" name="address" required placeholder="Enter full address">
                    </div>

                    <div class="input-group">
                        <label>Contact Number</label>
                        <i class="fa-solid fa-phone input-icon"></i>
                        <input type="tel" name="contactNo" required placeholder="07XXXXXXXX" pattern="[0-9]{10}">
                    </div>
                </div>

                <h3 class="section-title"><i class="fa-solid fa-bed"></i> Reservation Details</h3>
                <div class="form-grid">
                    <div class="input-group full-width select-wrapper">
                        <label>Select Room Type</label>
                        <i class="fa-solid fa-door-open input-icon"></i>
                        <select name="roomType" required>
                            <option value="" disabled selected>-- Choose your preferred room --</option>
                            <option value="Single">Standard Single Room (1 Person)</option>
                            <option value="Double">Deluxe Double Room (2 Persons)</option>
                            <option value="Suite">Ocean View Luxury Suite</option>
                        </select>
                    </div>

                    <div class="input-group">
                        <label>Check-in Date</label>
                        <i class="fa-solid fa-calendar-plus input-icon"></i>
                        <input type="date" name="checkInDate" required id="checkIn">
                    </div>

                    <div class="input-group">
                        <label>Check-out Date</label>
                        <i class="fa-solid fa-calendar-minus input-icon"></i>
                        <input type="date" name="checkOutDate" required id="checkOut">
                    </div>
                </div>

                <button type="submit" class="submit-btn">
                    <i class="fa-solid fa-calendar-check"></i> Confirm Reservation
                </button>
            </form>
        </div>
    </div>
</main>

<footer>
    &copy; 2026 Ocean View Resort - Developed for CIS6003 Advanced Programming.
</footer>

<script>
    // Simple JavaScript code to prevent selecting a date before today's date
    document.addEventListener('DOMContentLoaded', function() {
        const today = new Date().toISOString().split('T')[0];
        const checkIn = document.getElementById('checkIn');
        const checkOut = document.getElementById('checkOut');

        checkIn.setAttribute('min', today);

        checkIn.addEventListener('change', function() {
            checkOut.setAttribute('min', this.value);
            if(checkOut.value && checkOut.value < this.value) {
                checkOut.value = this.value;
            }
        });
    });
</script>

</body>
</html>