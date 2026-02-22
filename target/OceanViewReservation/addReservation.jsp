<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View Resort - Add New Reservation</title>

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

        /* Form Container - Glass Effect */
        main { flex: 1; display: flex; justify-content: center; align-items: center; padding: 40px 20px; animation: fadeIn 0.6s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .form-container {
            background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(15px);
            padding: 40px; border-radius: 20px; width: 100%; max-width: 650px; /* තරමක් විශාල කර ඇත */
            box-shadow: 0 15px 40px rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.6);
        }

        .form-container h2 { text-align: center; color: var(--primary); font-size: 28px; font-weight: 700; margin-top: 0; margin-bottom: 25px; border-bottom: 2px solid #eef2f5; padding-bottom: 15px; }

        /* Section Titles (Guest & Booking) */
        .section-title { font-size: 18px; color: var(--secondary); font-weight: 600; margin-top: 25px; margin-bottom: 15px; display: flex; align-items: center; gap: 8px; border-bottom: 1px dashed #ccc; padding-bottom: 8px; }

        /* Two Column Layout for Dates */
        .two-col { display: flex; gap: 20px; }
        .two-col .input-group { flex: 1; }

        /* Input Fields */
        .input-group { margin-bottom: 20px; position: relative; }
        .input-group label { display: block; font-weight: 600; color: var(--text-dark); font-size: 14px; margin-bottom: 8px; }
        .input-group i { position: absolute; top: 38px; left: 15px; color: var(--secondary); font-size: 16px; z-index: 2; }

        .input-group input, .input-group select {
            width: 100%; padding: 12px 15px 12px 45px; border: 1px solid #ccc; border-radius: 8px;
            font-size: 15px; font-family: 'Poppins', sans-serif; transition: 0.3s; box-sizing: border-box; background: #f9fbfd; position: relative; z-index: 1;
        }
        .input-group input:focus, .input-group select:focus { border-color: var(--secondary); outline: none; box-shadow: 0 0 8px rgba(10,147,150,0.2); background: white; }

        /* Submit Button */
        .submit-btn {
            width: 100%; background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white; border: none; padding: 15px; border-radius: 30px; font-size: 16px;
            font-weight: 600; cursor: pointer; transition: 0.3s; margin-top: 25px; font-family: 'Poppins', sans-serif;
            box-shadow: 0 5px 15px rgba(0,95,115,0.3); letter-spacing: 0.5px;
        }
        .submit-btn:hover { transform: translateY(-3px); box-shadow: 0 8px 20px rgba(0,95,115,0.4); }

        /* Alerts */
        .alert { padding: 12px; border-radius: 8px; font-size: 14px; font-weight: 600; text-align: center; margin-bottom: 20px; }
        .alert.error { background: #ffe6e6; color: var(--error); border: 1px solid var(--error); }
        .alert.success { background: #e6f6f4; color: var(--success); border: 1px solid var(--success); }

        footer { text-align: center; padding: 15px; color: rgba(255,255,255,0.9); font-size: 13px; backdrop-filter: blur(8px); background: rgba(0,0,0,0.6); margin-top: auto; }

        /* Mobile Responsive */
        @media (max-width: 600px) {
            .two-col { flex-direction: column; gap: 0; }
        }
    </style>
</head>
<body>

<div class="overlay"></div>

<header>
    <div class="logo-sec">
        <img src="https://cdn-icons-png.flaticon.com/512/3009/3009489.png" alt="Logo">
        <h1>Ocean View Resort</h1>
    </div>
    <a href="dashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back</a>
</header>

<main>
    <div class="form-container">
        <h2><i class="fa-solid fa-folder-plus"></i> Add New Reservation</h2>

        <% if(request.getAttribute("successMessage") != null) { %>
        <div class="alert success"><i class="fa-solid fa-circle-check"></i> <%= request.getAttribute("successMessage") %></div>
        <% } else if(request.getAttribute("errorMessage") != null) { %>
        <div class="alert error"><i class="fa-solid fa-circle-exclamation"></i> <%= request.getAttribute("errorMessage") %></div>
        <% } %>

        <form action="AddNewReservationServlet" method="POST">

            <h3 class="section-title"><i class="fa-solid fa-address-card"></i> Guest Information</h3>

            <div class="input-group">
                <label>Guest Full Name:</label>
                <i class="fa-solid fa-user"></i>
                <input type="text" name="guestName" required placeholder="E.g. Rajapaksha">
            </div>

            <div class="input-group">
                <label>NIC / Passport No:</label>
                <div class="input-container">
                    <i class="fa-solid fa-id-card"></i>
                    <input type="text" name="nic" placeholder="E.g. 199812345678" required>
                </div>
            </div>

            <div class="input-group">
                <label>Email Address:</label>
                <div class="input-container">
                    <i class="fa-solid fa-envelope"></i>
                    <input type="email" name="email" placeholder="E.g. john@example.com" required>
                </div>
            </div>

            <div class="input-group">
                <label>Address:</label>
                <i class="fa-solid fa-map-location-dot"></i>
                <input type="text" name="address" required placeholder="E.g. 123, Maharagama, Colombo">
            </div>

            <div class="input-group">
                <label>Contact Number:</label>
                <i class="fa-solid fa-phone"></i>
                <input type="text" name="contactNo" required placeholder="07XXXXXXX" pattern="\d{10}">
            </div>

            <h3 class="section-title"><i class="fa-solid fa-hotel"></i> Booking Information</h3>

            <div class="input-group">
                <label>Room Type:</label>
                <i class="fa-solid fa-door-open"></i>
                <select name="roomType" required>
                    <option value="" disabled selected>-- Select Room Type --</option>
                    <option value="Single">Single Room</option>
                    <option value="Double">Double Room</option>
                    <option value="Suite">Luxury Suite</option>
                </select>
            </div>

            <div class="two-col">
                <div class="input-group">
                    <label>Check-in Date:</label>
                    <i class="fa-solid fa-calendar-check"></i>
                    <input type="date" name="checkInDate" required>
                </div>
                <div class="input-group">
                    <label>Check-out Date:</label>
                    <i class="fa-solid fa-calendar-xmark"></i>
                    <input type="date" name="checkOutDate" required>
                </div>
            </div>

            <button type="submit" class="submit-btn"><i class="fa-solid fa-save"></i> Save Complete Reservation</button>
        </form>
    </div>
</main>

<footer>
    &copy; 2026 Ocean View Resort - Reservation System. All Rights Reserved. <br> Developed for Advanced Programming Assignment.
</footer>

</body>
</html>