<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanview.model.Reservation" %>
<%
    // Security measures: Prevent browser from caching this page after logout
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String role = (String) session.getAttribute("userRole");

    // Access control: Ensure only Staff or Admin can access the edit page
    if (role == null || (!"Staff".equals(role) && !"Admin".equals(role))) {
        response.sendRedirect("login.jsp");
        return;
    }

    Reservation r = (Reservation) request.getAttribute("reservationToEdit");
    if (r == null) {
        response.sendRedirect("ViewReservationsServlet");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Booking - Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #005f73; --bg-light: #f4f7f6; }
        body { font-family: 'Poppins', sans-serif; background: var(--bg-light); display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .card { background: white; padding: 40px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.08); width: 100%; max-width: 500px; }
        h2 { color: var(--primary); text-align: center; margin-bottom: 30px; font-size: 22px; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .form-group { margin-bottom: 15px; }
        .form-group.full-width { grid-column: span 2; }
        label { display: block; font-size: 13px; font-weight: 600; margin-bottom: 8px; color: #333; }
        input, select { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-family: 'Poppins'; box-sizing: border-box; font-size: 14px; transition: 0.3s; }
        input:focus, select:focus { border-color: var(--primary); outline: none; box-shadow: 0 0 0 3px rgba(0,95,115,0.1); }
        .readonly { background: #e9ecef; color: #666; cursor: not-allowed; border-color: #ced4da; }
        .btn { width: 100%; background: var(--primary); color: white; padding: 12px; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; transition: 0.3s; margin-top: 15px; font-family: 'Poppins', sans-serif;}
        .btn:hover { background: #0a9396; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(10,147,150,0.3);}
        .back-link { display: block; text-align: center; margin-top: 20px; text-decoration: none; color: #666; font-size: 13px; transition: 0.3s;}
        .back-link:hover { color: var(--primary); font-weight: 600;}
    </style>
</head>
<body>
<div class="card">
    <h2>Edit Reservation Details</h2>
    <form action="UpdateReservationServlet" method="POST">
        <input type="hidden" name="reservationId" value="<%= r.getReservationId() %>">
        <input type="hidden" name="guestId" value="<%= r.getGuestId() %>">

        <div class="form-grid">
            <div class="form-group">
                <label>Reservation ID</label>
                <input type="text" value="#<%= r.getReservationId() %>" readonly class="readonly">
            </div>
            <div class="form-group">
                <label>Guest ID</label>
                <input type="text" value="G-<%= r.getGuestId() %>" readonly class="readonly">
            </div>

            <div class="form-group full-width">
                <label>Room Type</label>
                <select name="roomType" required>
                    <option value="Single" <%= "Single".equals(r.getRoomType()) ? "selected" : "" %>>Single Room</option>
                    <option value="Double" <%= "Double".equals(r.getRoomType()) ? "selected" : "" %>>Double Room</option>
                    <option value="Family" <%= "Family".equals(r.getRoomType()) ? "selected" : "" %>>Family Room</option>
                    <option value="Suite" <%= "Suite".equals(r.getRoomType()) ? "selected" : "" %>>Suite</option>
                </select>
            </div>

            <div class="form-group">
                <label>Check-in Date</label>
                <input type="date" name="checkInDate" id="checkInDate" value="<%= r.getCheckInDate() %>" required>
            </div>
            <div class="form-group">
                <label>Check-out Date</label>
                <input type="date" name="checkOutDate" id="checkOutDate" value="<%= r.getCheckOutDate() %>" required>
            </div>

            <div class="form-group full-width">
                <label>Number of Persons</label>
                <input type="number" name="noOfPersons" min="1" value="<%= r.getNoOfPersons() > 0 ? r.getNoOfPersons() : 1 %>" required>
            </div>
        </div>

        <button type="submit" class="btn">Save Changes</button>
        <a href="ViewReservationsServlet" class="back-link">Cancel and Go Back</a>
    </form>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const checkIn = document.getElementById('checkInDate');
        const checkOut = document.getElementById('checkOutDate');

        // Ensure Check-out date is automatically adjusted if Check-in date is changed
        checkIn.addEventListener('change', function() {
            checkOut.setAttribute('min', this.value);

            if (checkOut.value && checkOut.value <= this.value) {
                let nextDay = new Date(this.value);
                nextDay.setDate(nextDay.getDate() + 1);
                checkOut.value = nextDay.toISOString().split('T')[0];
            }
        });
    });
</script>
</body>
</html>