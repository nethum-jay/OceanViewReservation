<div class="form-container">
    <h2>Book a Room</h2>
    <form action="ReservationServlet" method="post">
        <label>Guest ID:</label>
        <input type="text" name="guestID" required>

        <label>Room Type:</label>
        <select name="roomType">
            <option value="Single">Single</option>
            <option value="Double">Double</option>
            <option value="Luxury">Luxury</option>
        </select>

        <label>Check-In Date:</label>
        <input type="date" name="checkIn" required>

        <label>Check-Out Date:</label>
        <input type="date" name="checkOut" required>

        <input type="submit" value="Confirm Booking">
    </form>
</div>