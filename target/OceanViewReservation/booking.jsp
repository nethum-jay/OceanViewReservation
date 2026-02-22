<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View Resort - Book a Room</title>

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

        .overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.4); z-index: -1; }

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
            padding: 40px; border-radius: 20px; width: 100%; max-width: 500px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.6);
        }

        .form-container h2 { text-align: center; color: var(--primary); font-size: 26px; font-weight: 700; margin-top: 0; margin-bottom: 25px; border-bottom: 2px solid #eef2f5; padding-bottom: 15px; }

        /* Input Fields */
        .input-group { margin-bottom: 20px; position: relative; }
        .input-group label { display: block; font-weight: 600; color: var(--text-dark); font-size: 14px; margin-bottom: 8px; }
        .input-group i { position: absolute; top: 38px; left: 15px; color: var(--secondary); font-size: 16px; }

        /* Beautiful Input, Select and Date Pickers */
        .input-group input, .input-group select {
            width: 100%; padding: 12px 15px 12px 45px; border: 1px solid #ccc; border-radius: 8px;
            font-size: 15px; font-family: 'Poppins', sans-serif; transition: 0.3s; box-sizing: border-box; background: #f9fbfd;
        }
        .input-group input:focus, .input-group select:focus { border-color: var(--secondary); outline: none; box-shadow: 0 0 8px rgba(10,147,150,0.2); background: white; }

        /* Submit Button */
        .submit-btn {
            width: 100%; background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white; border: none; padding: 14px; border-radius: 30px; font-size: 16px;
            font-weight: 600; cursor: pointer; transition: 0.3s; margin-top: 15px; font-family: 'Poppins', sans-serif;
            box-shadow: 0 5px 15px rgba(0,95,115,0.3);
        }
        .submit-btn:hover { transform: translateY(-3px); box-shadow: 0 8px 20px rgba(0,95,115,0.4); }

        /* Alerts */
        .alert { padding: 12px; border-radius: 8px; font-size: 14px; font-weight: 600; text-align: center; margin-bottom: 20px; }
        .alert.error { background: #ffe6e6; color: var(--error); border: 1px solid var(--error); }
        .alert.success { background: #e6f6f4; color: var(--success); border: 1px solid var(--success); }

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
    <a href="dashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
</header>

<main>
    <div class="form-container">
        <h2><i class="fa-solid fa-bed"></i> Book a Room</h2>

        <% if(request.getAttribute("errorMessage") != null) { %>
        <div class="alert error"><i class="fa-solid fa-circle-exclamation"></i> <%= request.getAttribute("errorMessage") %></div>
        <% } %>
        <% if(request.getAttribute("successMessage") != null) { %>
        <div class="alert success"><i class="fa-solid fa-circle-check"></i> <%= request.getAttribute("successMessage") %></div>
        <% } %>

        <form action="ReservationServlet" method="post">

            <div class="input-group">
                <label>Guest ID:</label>
                <i class="fa-solid fa-id-badge"></i>
                <input type="text" name="guestID" placeholder="Enter valid Guest ID" required>
            </div>

            <div class="input-group">
                <label>Room Type:</label>
                <i class="fa-solid fa-door-open"></i>
                <select name="roomType" required>
                    <option value="Single">Single Room</option>
                    <option value="Double">Double Room</option>
                    <option value="Luxury">Luxury Suite</option>
                </select>
            </div>

            <div class="input-group">
                <label>Check-In Date:</label>
                <i class="fa-solid fa-calendar-check"></i>
                <input type="date" name="checkInDate" required>
            </div>

            <div class="input-group">
                <label>Check-Out Date:</label>
                <i class="fa-solid fa-calendar-xmark"></i>
                <input type="date" name="checkOutDate" required>
            </div>

            <button type="submit" class="submit-btn"><i class="fa-solid fa-check-circle"></i> Confirm Booking</button>
        </form>
    </div>
</main>

<footer>
    &copy; 2026 Ocean View Resort - Reservation System. All Rights Reserved. <br> Developed for Advanced Programming Assignment.
</footer>

</body>
</html>