<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%
    // Only Staff or Admin can access
    String userRole = (String) session.getAttribute("userRole");
    if (userRole == null || "Customer".equals(userRole)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Generate Bill - Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root { --primary: #005f73; --secondary: #0a9396; --text-dark: #1a1a1a; --white: #ffffff; }

        /* Dashboard Background Applied */
        body {
            font-family: 'Poppins', sans-serif; margin: 0; padding: 0;
            background: url('https://images.unsplash.com/photo-1618140052121-39fc6db33972?q=80&w=2070&auto=format&fit=crop') no-repeat center center fixed;
            background-size: cover; color: var(--text-dark); min-height: 100vh; display: flex; flex-direction: column;
        }
        .overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.45); z-index: -1; }

        header { background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(12px); padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); }
        .logo-sec { display: flex; align-items: center; gap: 15px; color: var(--primary); }
        .logo-sec img { height: 45px; }
        .logo-sec h1 { margin: 0; font-size: 24px; font-weight: 700; }
        .back-btn { background: var(--primary); color: white; padding: 10px 20px; border-radius: 30px; text-decoration: none; font-size: 14px; font-weight: 500; transition: 0.3s; }
        .back-btn:hover { background: var(--secondary); transform: translateX(-5px); }

        main { flex: 1; display: flex; flex-direction: column; align-items: center; padding: 40px 20px; animation: fadeIn 0.6s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .container { width: 100%; max-width: 850px; }

        /* Search Section */
        .search-box {
            background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); padding: 25px;
            border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.15); display: flex; gap: 15px; align-items: center; margin-bottom: 30px; border: 1px solid rgba(255,255,255,0.6);
        }
        .search-box input { flex: 1; padding: 12px 15px; border: 1px solid #ccc; border-radius: 8px; font-size: 15px; font-family: 'Poppins'; }
        .search-box input:focus { border-color: var(--secondary); outline: none; }
        .search-box button { background: linear-gradient(135deg, var(--primary), var(--secondary)); color: white; border: none; padding: 12px 30px; border-radius: 8px; cursor: pointer; font-weight: 600; transition: 0.3s; }
        .search-box button:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(0,95,115,0.3); }

        /* Invoice Styling */
        .invoice-card {
            background: white; padding: 45px; border-radius: 15px; box-shadow: 0 15px 40px rgba(0,0,0,0.2);
            border-top: 8px solid var(--secondary);
        }

        .header-sec { text-align: center; border-bottom: 2px dashed #ddd; padding-bottom: 20px; margin-bottom: 30px; }
        .header-sec h1 { margin: 0; color: var(--primary); font-size: 28px; font-weight: 700; }
        .header-sec p { margin: 5px 0; color: #666; font-size: 14px; }

        .bill-info { display: flex; justify-content: space-between; margin-bottom: 30px; }
        .info-group h4 { margin: 0 0 8px 0; color: var(--secondary); font-size: 16px; }
        .info-group p { margin: 0 0 5px 0; font-size: 14px; color: #444; }

        .bill-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        .bill-table th { background: #f8f9fa; padding: 12px; text-align: left; border-bottom: 2px solid #ddd; color: var(--primary); font-weight: 600; font-size: 14px; }
        .bill-table td { padding: 15px 12px; border-bottom: 1px solid #eee; font-size: 14px; }
        .total-row td { font-weight: 700; font-size: 18px; color: var(--primary); border-top: 2px solid var(--secondary); padding-top: 20px; }

        .print-btn {
            background: #2a9d8f; color: white; border: none; padding: 12px 35px; border-radius: 30px;
            font-size: 15px; font-weight: 600; cursor: pointer; margin-top: 30px; display: block; margin-left: auto; transition: 0.3s;
        }
        .print-btn:hover { background: #21867a; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(42,157,143,0.4); }

        .error-msg { background: #ffe6e6; color: #e63946; padding: 15px; border-radius: 8px; text-align: center; margin-bottom: 20px; font-weight: 600; border: 1px solid #e63946; }

        footer { text-align: center; padding: 20px; color: rgba(255,255,255,0.9); font-size: 13px; backdrop-filter: blur(8px); background: rgba(0,0,0,0.6); margin-top: auto; }

        /* Print Settings */
        @media print {
            body { background: white; min-height: auto; }
            .overlay, header, .search-box, .print-btn, footer { display: none; }
            main { padding: 0; }
            .invoice-card { box-shadow: none; border: none; padding: 0; }
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
    <a href="staffDashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
</header>

<main>
    <div class="container">
        <div class="search-box">
            <i class="fa-solid fa-magnifying-glass" style="color: var(--secondary); font-size: 20px;"></i>
            <form action="BillingServlet" method="GET" style="display: flex; flex: 1; gap: 15px;">
                <input type="tel" name="contactNo" placeholder="Enter Customer Phone (e.g. 07XXXXXXXX)" required pattern="[0-9]{10}">
                <button type="submit"><i class="fa-solid fa-file-invoice-dollar"></i> Generate Bill</button>
            </form>
        </div>

        <% if(request.getAttribute("errorMessage") != null) { %>
        <div class="error-msg"><i class="fa-solid fa-triangle-exclamation"></i> <%= request.getAttribute("errorMessage") %></div>
        <% } %>

        <%
            Map<String, String> details = (Map<String, String>) request.getAttribute("resDetails");
            if(details != null) {
                double rate = (Double) request.getAttribute("ratePerNight");
                long nights = (Long) request.getAttribute("nights");
                double total = (Double) request.getAttribute("totalCost");
        %>
        <div class="invoice-card" id="invoice">
            <div class="header-sec">
                <h1>Ocean View Resort</h1>
                <p>463/1G, Athurugiriya Rd, Malabe</p>
                <p>Tel: +94 11 234 5678 | Email: billing@oceanview.lk</p>
            </div>

            <div class="bill-info">
                <div class="info-group">
                    <h4><i class="fa-solid fa-user"></i> Billed To:</h4>
                    <p><strong><%= details.get("name") %></strong></p>
                    <p><%= details.get("address") %></p>
                    <p>Phone: <%= details.get("contactNo") %></p>
                </div>
                <div class="info-group" style="text-align: right;">
                    <h4><i class="fa-solid fa-file-lines"></i> Invoice Details:</h4>
                    <p><strong>Invoice #:</strong> INV-<%= details.get("reservationID") %></p>
                    <p><strong>Date:</strong> <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(new java.util.Date()) %></p>
                </div>
            </div>

            <table class="bill-table">
                <thead>
                <tr>
                    <th>Description</th>
                    <th>Check-In</th>
                    <th>Check-Out</th>
                    <th>Nights</th>
                    <th>Rate (LKR)</th>
                    <th style="text-align: right;">Amount</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td><strong><%= details.get("roomType") %></strong> Room Charge</td>
                    <td><%= details.get("checkInDate") %></td>
                    <td><%= details.get("checkOutDate") %></td>
                    <td><%= nights %></td>
                    <td><%= String.format("%,.2f", rate) %></td>
                    <td style="text-align: right;"><%= String.format("%,.2f", total) %></td>
                </tr>
                <tr>
                    <td colspan="5" style="text-align: right; color: #777;">Service Charge (10%)</td>
                    <td style="text-align: right; color: #777;"><%= String.format("%,.2f", total * 0.10) %></td>
                </tr>
                <tr class="total-row">
                    <td colspan="5" style="text-align: right;">Total Payable</td>
                    <td style="text-align: right;">LKR <%= String.format("%,.2f", total * 1.10) %></td>
                </tr>
                </tbody>
            </table>

            <div style="text-align: center; margin-top: 40px; font-size: 13px; color: #888;">
                <p><strong>Thank you for staying with us!</strong> <br> Payment is due upon checkout.</p>
            </div>

            <button onclick="window.print()" class="print-btn"><i class="fa-solid fa-print"></i> Print Invoice</button>
        </div>
        <% } %>
    </div>
</main>

<footer>
    &copy; 2026 Ocean View Resort - Reservation System. All Rights Reserved. <br> Developed for Advanced Programming Assignment.
</footer>

</body>
</html>