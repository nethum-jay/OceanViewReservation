<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View Resort - Help & Guidelines</title>

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

        /* Main Container - Glass Effect */
        main { flex: 1; display: flex; justify-content: center; align-items: center; padding: 40px 20px; animation: fadeIn 0.6s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .help-container {
            background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(15px);
            padding: 40px; border-radius: 20px; width: 100%; max-width: 850px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.6);
        }

        .help-container h2 { color: var(--primary); font-size: 28px; font-weight: 700; margin-top: 0; border-bottom: 2px solid #eef2f5; padding-bottom: 15px; margin-bottom: 15px; display: flex; align-items: center; gap: 10px; }
        .help-container p.intro { color: var(--text-muted); font-size: 15px; margin-bottom: 30px; line-height: 1.6; }

        /* Guide Cards Styling */
        .guide-card {
            background: rgba(255, 255, 255, 0.6);
            border-left: 5px solid var(--secondary);
            padding: 25px; margin-bottom: 20px; border-radius: 12px;
            transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            border-top: 1px solid rgba(255,255,255,0.8);
            border-right: 1px solid rgba(255,255,255,0.8);
            border-bottom: 1px solid rgba(255,255,255,0.8);
        }
        .guide-card:hover { transform: translateX(8px); box-shadow: 0 8px 25px rgba(0,95,115,0.1); background: rgba(255, 255, 255, 0.9); border-left-color: var(--primary); }

        .guide-card h3 { margin-top: 0; color: var(--text-dark); font-size: 18px; font-weight: 600; display: flex; align-items: center; margin-bottom: 12px; }
        .guide-card h3 i { margin-right: 12px; font-size: 22px; color: var(--secondary); background: rgba(10, 147, 150, 0.1); padding: 10px; border-radius: 50%; }

        .guide-card p { color: var(--text-muted); line-height: 1.6; margin-bottom: 0; font-size: 14px; font-weight: 500; }
        .guide-card ul { margin-top: 12px; color: var(--text-muted); padding-left: 25px; font-size: 14px; }
        .guide-card ul li { margin-bottom: 8px; line-height: 1.5; }
        .guide-card ul li b { color: var(--text-dark); }

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
    <a href="customer_dashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
</header>

<main>
    <div class="help-container">
        <h2><i class="fa-solid fa-circle-info"></i> Staff User Guidelines</h2>
        <p class="intro">Welcome to the Ocean View Resort Reservation System. This guide provides step-by-step instructions for new staff members to navigate and manage bookings effectively.</p>

        <div class="guide-card">
            <h3><i class="fa-solid fa-shield-halved"></i> 1. System Access (Login)</h3>
            <p>All staff members must log in to access the system securely.</p>
            <ul>
                <li>Navigate to the <b>Login Page</b> (`login.jsp`).</li>
                <li>Enter your assigned <b>Username</b> and <b>Password</b>.</li>
                <li>Do not share your credentials with unauthorized personnel.</li>
            </ul>
        </div>

        <div class="guide-card">
            <h3><i class="fa-solid fa-calendar-plus"></i> 2. Adding a New Reservation</h3>
            <p>Use this section when a new guest wishes to book a room.</p>
            <ul>
                <li>Go to the <b>Add Reservation</b> module (`addReservation.jsp`).</li>
                <li>Fill in the <b>Guest Details</b> (Name, Address, Contact Number).</li>
                <li>Select the <b>Room Type</b> and enter the <b>Check-in / Check-out dates</b>.</li>
                <li>Click <b>Save Complete Reservation</b>. The system will auto-generate a Guest ID.</li>
            </ul>
        </div>

        <div class="guide-card">
            <h3><i class="fa-solid fa-magnifying-glass"></i> 3. Display Reservation Details</h3>
            <p>Use this feature to search for an existing booking.</p>
            <ul>
                <li>Navigate to the <b>Display Reservation</b> page (`viewReservation.jsp`).</li>
                <li>Enter the guest's <b>Guest ID</b> in the search box.</li>
                <li>Click <b>Search</b> to view full details including room type and dates.</li>
            </ul>
        </div>

        <div class="guide-card">
            <h3><i class="fa-solid fa-file-invoice-dollar"></i> 4. Calculate and Print Bill</h3>
            <p>Generate an official invoice when a guest is checking out.</p>
            <ul>
                <li>Go to the <b>Billing Section</b> (`printBill.jsp`) and search using the Guest ID.</li>
                <li>The system will automatically compute the <b>Number of Nights</b> and the <b>Total Cost</b> based on our standard room rates.</li>
                <li>Click the <b>Print Official Invoice</b> button to hand over a physical copy to the guest.</li>
            </ul>
        </div>
    </div>
</main>

<footer>
    &copy; 2026 Ocean View Resort - Reservation System. All Rights Reserved. <br> Developed for Advanced Programming Assignment.
</footer>

</body>
</html>