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
    <title>Ocean View Resort - Generate Bill</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root { --primary: #005f73; --secondary: #0a9396; --text-dark: #1a1a1a; --white: #ffffff; }
        body { font-family: 'Poppins', sans-serif; background: #f0f2f5; margin: 0; padding: 20px; color: var(--text-dark); }

        .container { max-width: 800px; margin: 0 auto; }

        /* Search Section */
        .search-box {
            background: white; padding: 20px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            display: flex; gap: 10px; align-items: center; margin-bottom: 30px;
        }
        .search-box input { flex: 1; padding: 12px; border: 1px solid #ccc; border-radius: 6px; font-size: 15px; }
        .search-box button { background: var(--primary); color: white; border: none; padding: 12px 25px; border-radius: 6px; cursor: pointer; font-weight: 600; }

        /* Invoice Styling */
        .invoice-card {
            background: white; padding: 40px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            animation: slideUp 0.5s ease-out; position: relative;
        }
        @keyframes slideUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .header-sec { text-align: center; border-bottom: 2px solid #eee; padding-bottom: 20px; margin-bottom: 20px; }
        .header-sec h1 { margin: 0; color: var(--primary); font-size: 28px; }
        .header-sec p { margin: 5px 0; color: #666; font-size: 14px; }

        .bill-info { display: flex; justify-content: space-between; margin-bottom: 30px; }
        .info-group h4 { margin: 0 0 5px 0; color: var(--secondary); }
        .info-group p { margin: 0; font-size: 14px; color: #444; }

        .bill-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        .bill-table th { background: #f8f9fa; padding: 12px; text-align: left; border-bottom: 2px solid #ddd; color: #555; }
        .bill-table td { padding: 15px 12px; border-bottom: 1px solid #eee; }
        .total-row td { font-weight: 700; font-size: 18px; color: var(--primary); border-top: 2px solid var(--secondary); }

        .print-btn {
            background: #2a9d8f; color: white; border: none; padding: 12px 30px; border-radius: 50px;
            font-size: 16px; font-weight: 600; cursor: pointer; margin-top: 20px; display: block; margin-left: auto;
        }
        .print-btn:hover { background: #21867a; }

        .error-msg { background: #ffe6e6; color: #e63946; padding: 15px; border-radius: 8px; text-align: center; margin-bottom: 20px; }

        @media print {
            body { background: white; }
            .search-box, .print-btn, .back-link { display: none; }
            .invoice-card { box-shadow: none; border: 1px solid #ddd; }
        }
    </style>
</head>
<body>

<div class="container">
    <a href="staffDashboard.jsp" class="back-link" style="text-decoration: none; color: var(--primary); display: inline-block; margin-bottom: 15px;">
        <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
    </a>

    <div class="search-box">
        <i class="fa-solid fa-magnifying-glass" style="color: var(--secondary);"></i>
        <form action="BillingServlet" method="GET" style="display: flex; flex: 1; gap: 10px;">
            <input type="tel" name="contactNo" placeholder="Enter Customer Phone Number (e.g. 07XXXXXXXX)" required pattern="[0-9]{10}">
            <button type="submit">Generate Bill</button>
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
                <h4>Billed To:</h4>
                <p><strong><%= details.get("name") %></strong></p>
                <p><%= details.get("address") %></p>
                <p><%= details.get("contactNo") %></p>
            </div>
            <div class="info-group" style="text-align: right;">
                <h4>Invoice Details:</h4>
                <p>Invoice #: INV-<%= details.get("reservationID") %></p>
                <p>Date: <%= new java.util.Date() %></p>
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
                <td><%= details.get("roomType") %> Room Charge</td>
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
            <p>Thank you for staying with us!</p>
        </div>

        <button onclick="window.print()" class="print-btn"><i class="fa-solid fa-print"></i> Print Invoice</button>
    </div>
    <% } %>
</div>

</body>
</html>