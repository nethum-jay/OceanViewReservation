package com.oceanview.dao;

import com.oceanview.model.Reservation;
import com.oceanview.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ReservationDAO {
    public boolean makeReservation(Reservation res) {
        boolean isSuccess = false;
        // Singleton
        Connection conn = DBConnection.getInstance().getConnection();
        String sql = "INSERT INTO Reservation (guestID, roomType, checkInDate, checkOutDate) VALUES (?, ?, ?, ?)";

        try {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, res.getGuestID());
            pstmt.setString(2, res.getRoomType());
            pstmt.setString(3, res.getCheckInDate());
            pstmt.setString(4, res.getCheckOutDate());

            int result = pstmt.executeUpdate();
            isSuccess = result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSuccess;
    }
}