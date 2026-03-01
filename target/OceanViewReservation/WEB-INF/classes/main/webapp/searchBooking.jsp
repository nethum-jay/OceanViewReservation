<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%
    String dashboardLink = "customerDashboard.jsp";
    String role = (String) session.getAttribute("userRole");
    boolean isCustomer = "Customer".equals(role);

    if ("Admin".equals(role)) dashboardLink = "adminDashboard.jsp";
    else if ("Staff".equals(role)) dashboardLink = "staffDashboard.jsp";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Search Booking & Bill - Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary: #005f73; --secondary: #0a9396; --bg-light: #f4f7f6; }
        body { font-family: 'Poppins', sans-serif; background: url('https://images.unsplash.com/photo-1618140052121-39fc6db33972?q=80&w=2070&auto=format&fit=crop') no-repeat center center fixed; background-size: cover; margin: 0; min-height: 100vh; display: flex; flex-direction: column;}
        .overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.6); z-index: -1; }
        header { background: rgba(255, 255, 255, 0.9); padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; }
        .back-btn { background: var(--primary); color: white; padding: 8px 18px; border-radius: 25px; text-decoration: none; font-weight: 500; font-size: 14px;}
        .container { flex: 1; display: flex; flex-direction: column; align-items: center; padding: 40px 20px; animation: fadeIn 0.5s; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }

        .search-box { background: white; padding: 30px; border-radius: 15px; box-shadow: 0 10px 25px rgba(0,0,0,0.2); width: 100%; max-width: 500px; text-align: center; margin-bottom: 30px; }
        .search-box input { width: 65%; padding: 12px; border: 2px solid #ddd; border-radius: 8px; font-size: 15px; font-family: 'Poppins'; outline: none; margin-right: 5px;}
        .search-box button { width: 28%; padding: 12px; background: var(--primary); color: white; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; transition: 0.3s;}
        .search-box button:hover { background: var(--secondary); }

        /* Bill Card */
        .bill-card { background: white; padding: 40px; border-radius: 15px; width: 100%; max-width: 700px; box-shadow: 0 15px 35px rgba(0,0,0,0.2); position: relative; }
        .bill-header { text-align: center; border-bottom: 2px dashed #eee; padding-bottom: 20px; margin-bottom: 20px; }
        .bill-header h2 { color: var(--primary); margin: 0; font-size: 26px; }
        .bill-details { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; font-size: 14px; color: #444; }
        .bill-details strong { color: var(--primary); }
        .price-section { margin-top: 30px; background: var(--bg-light); padding: 20px; border-radius: 10px; text-align: right; border-left: 5px solid var(--secondary);}
        .price-section h3 { margin: 0; color: #e63946; font-size: 24px; }
        .print-btn { display: block; width: 200px; margin: 30px auto 0; text-align: center; background: var(--secondary); color: white; padding: 12px; border-radius: 8px; text-decoration: none; font-weight: 600; transition: 0.3s; }
        .print-btn:hover { background: var(--primary); transform: translateY(-2px); }

        @media print {
            body { background: white; }
            .overlay, header, .search-box, .print-btn { display: none !important; }
            .bill-card { box-shadow: none; max-width: 100%; border: 1px solid #ddd; padding: 0; }
        }
    </style>
</head>
<body>
<div class="overlay"></div>
<header>
    <h1 style="color: var(--primary); margin:0; font-size: 22px;"><i class="fa-solid fa-hotel"></i> Ocean View Resort</h1>
    <a href="<%= dashboardLink %>" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
</header>

<div class="container">
    <div class="search-box">
        <h3 style="margin-top:0; color: var(--primary);">
            <i class="fa-solid fa-file-invoice-dollar"></i> <%= isCustomer ? "Print My Invoice" : "Search Guest Invoice" %>
        </h3>
        <p style="font-size: 13px; color: #666; margin-bottom: 15px;">
            <%= isCustomer ? "Enter <strong>your</strong> Booking ID to print the bill." : "Enter Guest <strong>Booking ID</strong> to generate the bill." %>
        </p>
        <form action="SearchBookingServlet" method="GET">
            <input type="text" name="bookingId" placeholder="e.g. 5" required>
            <button type="submit"><i class="fa-solid fa-magnifying-glass"></i> Search</button>
        </form>
        <% if(request.getAttribute("errorMessage") != null) { %>
        <p style="color: red; font-size: 13px; margin-top: 15px; font-weight: 600;"><i class="fa-solid fa-triangle-exclamation"></i> <%= request.getAttribute("errorMessage") %></p>
        <% } %>
    </div>

    <%
        Map<String, String> details = (Map<String, String>) request.getAttribute("bookingDetails");
        if(details != null) {
    %>
    <div class="bill-card">
        <div class="bill-header">
            <h2>Booking Invoice</h2>
            <p style="margin: 5px 0 0; color: #666; font-size: 16px;">Booking ID: <strong>#<%= details.get("reservationID") %></strong></p>
        </div>

        <h4 style="color: var(--secondary); border-bottom: 1px solid #eee; padding-bottom: 5px;"><i class="fa-solid fa-user"></i> Guest Details</h4>
        <div class="bill-details">
            <div><strong>Name:</strong> <%= details.get("name") %></div>
            <div><strong>Contact No:</strong> <%= details.get("contactNo") %></div>
            <div><strong>Email:</strong> <%= details.get("email") %></div>
            <div><strong>NIC/Passport:</strong> <%= details.get("nic") %></div>
            <div style="grid-column: span 2;"><strong>Address:</strong> <%= details.get("address") %></div>
        </div>

        <h4 style="color: var(--secondary); border-bottom: 1px solid #eee; padding-bottom: 5px; margin-top: 25px;"><i class="fa-solid fa-bed"></i> Reservation Details</h4>
        <div class="bill-details">
            <div><strong>Room Type:</strong> <%= details.get("roomType") %></div>
            <div><strong>Persons:</strong> <%= details.get("noOfPersons") %></div>
            <div><strong>Check-In:</strong> <%= details.get("checkInDate") %></div>
            <div><strong>Check-Out:</strong> <%= details.get("checkOutDate") %></div>
            <div style="grid-column: span 2; font-size: 16px;"><strong>Total Nights:</strong> <%= details.get("nights") %></div>
        </div>

        <div class="price-section">
            <p style="margin: 0 0 5px 0; font-size: 14px; color: #666; font-weight: 600;">Total Amount Payable</p>
            <h3>LKR <%= details.get("totalAmount") %></h3>
        </div>

        <a href="#" class="print-btn" onclick="window.print();"><i class="fa-solid fa-print"></i> Print Invoice</a>
    </div>
    <% } %>
</div>
</body>
</html>