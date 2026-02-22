<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View Resort - Invoice & Billing</title>

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
            --danger: #e63946;
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

        main { flex: 1; display: flex; flex-direction: column; align-items: center; padding: 40px 20px; animation: fadeIn 0.6s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        /* Search Container (Glass Effect) */
        .search-container {
            background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(15px);
            padding: 25px 35px; border-radius: 15px; width: 100%; max-width: 550px; text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15); border: 1px solid rgba(255,255,255,0.6);
            margin-bottom: 30px; display: flex; flex-direction: column; gap: 15px;
        }
        .search-container form { display: flex; gap: 10px; }
        .search-container input {
            flex: 1; padding: 12px 15px; border: 1px solid #ccc; border-radius: 8px;
            font-size: 15px; font-family: 'Poppins', sans-serif; transition: 0.3s;
        }
        .search-container input:focus { border-color: var(--secondary); outline: none; box-shadow: 0 0 8px rgba(10,147,150,0.2); }
        .search-container button {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white; border: none; padding: 0 25px; border-radius: 8px; font-size: 15px;
            font-weight: 600; cursor: pointer; transition: 0.3s; font-family: 'Poppins', sans-serif;
        }
        .search-container button:hover { box-shadow: 0 5px 15px rgba(0,95,115,0.3); transform: translateY(-2px); }

        /* Invoice Container (Solid White for better printing) */
        .invoice-box {
            background: var(--white); padding: 50px; border-radius: 12px; width: 100%; max-width: 800px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.2); border-top: 8px solid var(--secondary);
            font-size: 15px; color: #444; position: relative;
        }
        .invoice-box table { width: 100%; line-height: 1.6; text-align: left; border-collapse: collapse; }
        .invoice-box table td { padding: 10px; vertical-align: top; }
        .invoice-box table tr.top table td.title { font-size: 32px; font-weight: 700; color: var(--primary); letter-spacing: 1px; }
        .invoice-box table tr.information td { padding-bottom: 30px; }
        .invoice-box table tr.heading td { background: #f8f9fa; border-bottom: 2px solid #ddd; font-weight: 600; color: var(--text-dark); }
        .invoice-box table tr.details td { padding-bottom: 20px; }
        .invoice-box table tr.item td { border-bottom: 1px solid #eee; }
        .invoice-box table tr.total td:nth-child(2) { border-top: 2px solid var(--secondary); font-weight: 700; font-size: 1.4em; color: var(--danger); padding-top: 15px; }

        /* Print Button */
        .print-btn {
            background: var(--secondary); color: white; border: none; padding: 12px 30px; border-radius: 30px;
            font-size: 16px; font-weight: 600; cursor: pointer; transition: 0.3s; display: block; margin: 30px auto 0;
            font-family: 'Poppins', sans-serif; box-shadow: 0 5px 15px rgba(10,147,150,0.3);
        }
        .print-btn:hover { background: var(--primary); transform: translateY(-3px); }

        .error-msg { color: var(--danger); font-weight: 600; font-size: 14px; background: #ffe6e6; padding: 10px; border-radius: 5px; }

        footer { text-align: center; padding: 15px; color: rgba(255,255,255,0.9); font-size: 13px; backdrop-filter: blur(8px); background: rgba(0,0,0,0.6); margin-top: auto; }

        /* MAGIC TRICK: Settings for Printer */
        @media print {
            .no-print, .overlay, header, footer { display: none !important; }
            body { background: none !important; background-color: white !important; }
            main { padding: 0 !important; }
            .invoice-box { box-shadow: none !important; border: none !important; border-top: none !important; margin: 0 !important; padding: 0 !important; width: 100% !important; max-width: 100% !important; }
        }
    </style>
</head>
<body>

<div class="overlay no-print"></div>

<header class="no-print">
    <div class="logo-sec">
        <img src="https://cdn-icons-png.flaticon.com/512/3009/3009489.png" alt="Logo">
        <h1>Ocean View Resort</h1>
    </div>
    <a href="dashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
</header>

<main>
    <div class="search-container no-print">
        <h3 style="margin: 0; color: var(--primary);"><i class="fa-solid fa-file-invoice-dollar"></i> Generate Invoice</h3>
        <form action="BillingServlet" method="GET">
            <input type="text" name="guestID" placeholder="Enter valid Guest ID (e.g. 1)" required>
            <button type="submit"><i class="fa-solid fa-magnifying-glass"></i> Search</button>
        </form>
        <% if(request.getAttribute("errorMessage") != null) { %>
        <div class="error-msg"><i class="fa-solid fa-circle-exclamation"></i> <%= request.getAttribute("errorMessage") %></div>
        <% } %>
    </div>

    <%
        Map<String, String> details = (Map<String, String>) request.getAttribute("resDetails");
        if(details != null) {
    %>
    <div class="invoice-box">
        <table cellpadding="0" cellspacing="0">
            <tr class="top">
                <td colspan="2">
                    <table>
                        <tr>
                            <td class="title">INVOICE</td>
                            <td style="text-align: right;">
                                <strong>Invoice #:</strong> INV-00<%= details.get("reservationID") %><br>
                                <strong>Date Issued:</strong> <%= java.time.LocalDate.now() %><br>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <tr class="information">
                <td colspan="2">
                    <table>
                        <tr>
                            <td>
                                <strong>Ocean View Resort.</strong><br>
                                123 Coastal Drive<br>
                                Galle, Sri Lanka<br>
                                info@oceanview.lk
                            </td>
                            <td style="text-align: right;">
                                <strong>Billed To:</strong><br>
                                <%= details.get("name") %><br>
                                <%= details.get("address") %><br>
                                Tel: <%= details.get("contactNo") %>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <tr class="heading">
                <td>Description</td>
                <td style="text-align: right;">Amount (LKR)</td>
            </tr>

            <tr class="item">
                <td><strong>Room Type:</strong> <%= details.get("roomType") %></td>
                <td style="text-align: right;"><%= request.getAttribute("ratePerNight") %> per night</td>
            </tr>

            <tr class="item details">
                <td><strong>Duration:</strong> <%= details.get("checkInDate") %> to <%= details.get("checkOutDate") %></td>
                <td style="text-align: right;"><%= request.getAttribute("nights") %> Nights</td>
            </tr>

            <tr class="total">
                <td></td>
                <td style="text-align: right;">Total Cost: LKR <%= request.getAttribute("totalCost") %></td>
            </tr>
        </table>

        <button class="print-btn no-print" onclick="window.print()"><i class="fa-solid fa-print"></i> Print Official Invoice</button>
    </div>
    <% } %>
</main>

<footer class="no-print">
    &copy; 2026 Ocean View Resort - Reservation System. All Rights Reserved. <br> Developed for Advanced Programming Assignment.
</footer>

</body>
</html>