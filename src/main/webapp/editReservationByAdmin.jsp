<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanview.model.Reservation" %>
<%
    Reservation r = (Reservation) request.getAttribute("resToEdit");
    if (r == null) { response.sendRedirect("ViewReservationsServlet"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Booking - Admin Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; background: #f4f7fc; display: flex; justify-content: center; padding: 40px; }
        .form-card { background: white; padding: 35px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); width: 100%; max-width: 500px; }
        h2 { color: #005f73; margin-bottom: 25px; text-align: center; font-weight: 700; }
        .input-row { display: flex; gap: 15px; }
        .input-col { flex: 1; }
        label { font-size: 13px; font-weight: 600; color: #555; display: block; margin-top: 15px; }
        input, select { width: 100%; padding: 12px; margin-top: 5px; border: 1.5px solid #eef2f5; border-radius: 10px; box-sizing: border-box; background: #f9fbfd; font-family: 'Poppins'; }
        input:focus { border-color: #0a9396; outline: none; background: white; }
        button { width: 100%; padding: 14px; background: #005f73; color: white; border: none; border-radius: 10px; cursor: pointer; font-weight: 600; margin-top: 30px; transition: 0.3s; }
        button:hover { background: #0a9396; transform: translateY(-2px); }
        .cancel-link { display: block; text-align: center; margin-top: 15px; color: #888; text-decoration: none; font-size: 14px; }
    </style>
</head>
<body>
<div class="form-card">
    <h2>Edit Booking Info</h2>
    <form action="UpdateReservationServlet" method="POST">
        <input type="hidden" name="reservationID" value="<%= r.getReservationID() %>">

        <label>Guest ID (Read-only)</label>
        <input type="text" value="G-<%= r.getGuestID() %>" readonly style="background: #eef2f5; color: #888; cursor: not-allowed;">

        <label>Room Type</label>
        <select name="roomType">
            <option value="Single" <%= "Single".equals(r.getRoomType())?"selected":"" %>>Single Room</option>
            <option value="Double" <%= "Double".equals(r.getRoomType())?"selected":"" %>>Double Room</option>
            <option value="Suite" <%= "Suite".equals(r.getRoomType())?"selected":"" %>>Luxury Suite</option>
            <option value="Family" <%= "Family".equals(r.getRoomType())?"selected":"" %>>Family Room</option>
        </select>

        <div class="input-row">
            <div class="input-col">
                <label>Check-in Date</label>
                <input type="date" name="checkInDate" value="<%= r.getCheckInDate() %>" required>
            </div>
            <div class="input-col">
                <label>Check-out Date</label>
                <input type="date" name="checkOutDate" value="<%= r.getCheckOutDate() %>" required>
            </div>
        </div>

        <label>Number of Persons</label>
        <input type="number" name="noOfPersons" value="<%= r.getNoOfPersons() %>" min="1" required>

        <button type="submit">Save Booking Changes</button>
    </form>
    <a href="ViewReservationsServlet" class="cancel-link">Cancel and Go Back</a>
</div>
</body>
</html>