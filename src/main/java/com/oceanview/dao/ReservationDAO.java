package com.oceanview.dao;

import com.oceanview.model.Reservation;
import com.oceanview.model.Guest;
import com.oceanview.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;

public class ReservationDAO {

    // To reserve a room only by providing the Guest ID
    public boolean bookRoom(Reservation reservation) {
        boolean isSuccess = false;
        // Connecting to the database through the DBConnection class
        Connection conn = DBConnection.getInstance().getConnection();
        String sql = "INSERT INTO Reservation (guestID, roomType, checkInDate, checkOutDate) VALUES (?, ?, ?, ?)";

        try {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, reservation.getGuestID());
            pstmt.setString(2, reservation.getRoomType());
            pstmt.setString(3, reservation.getCheckInDate());
            pstmt.setString(4, reservation.getCheckOutDate());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                isSuccess = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    public int addCompleteReservation(Guest guest, Reservation reservation) {
        int generatedGuestID = -1;
        Connection conn = null;

        try {
            conn = DBConnection.getInstance().getConnection();
            // Starting the transaction
            conn.setAutoCommit(false);

            // Entering data into the Guest table
            String sqlGuest = "INSERT INTO guest (name, nic, email, address, contactNo) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstmtGuest = conn.prepareStatement(sqlGuest, Statement.RETURN_GENERATED_KEYS);
            pstmtGuest.setString(1, guest.getName());
            pstmtGuest.setString(2, guest.getNic());
            pstmtGuest.setString(3, guest.getEmail());
            pstmtGuest.setString(4, guest.getAddress());
            pstmtGuest.setString(5, guest.getContactNo());
            pstmtGuest.executeUpdate();

            // Obtaining the newly created GuestID
            ResultSet rs = pstmtGuest.getGeneratedKeys();
            if (rs.next()) {
                generatedGuestID = rs.getInt(1); // අලුත් ID එක අල්ලා ගැනීම
            }

            // Insert data into the Reservation table using that GuestID
            String sqlRes = "INSERT INTO Reservation (guestID, roomType, checkInDate, checkOutDate) VALUES (?, ?, ?, ?)";
            PreparedStatement pstmtRes = conn.prepareStatement(sqlRes);
            pstmtRes.setInt(1, generatedGuestID);
            pstmtRes.setString(2, reservation.getRoomType());
            pstmtRes.setString(3, reservation.getCheckInDate());
            pstmtRes.setString(4, reservation.getCheckOutDate());
            pstmtRes.executeUpdate();

            // If everything is successful, save the data in the database (Commit).
            conn.commit();

        } catch (Exception e) {
            e.printStackTrace();
            generatedGuestID = -1; // දෝෂයක් ආවොත් -1 යවයි
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return generatedGuestID; // අලුත් ID අංකය ආපසු යවයි
    }

    // How to get full reservation details
    public java.util.Map<String, String> getCompleteReservationDetails(int guestID) {
        java.util.Map<String, String> details = new java.util.HashMap<>();
        java.sql.Connection conn = null;

        try {
            conn = DBConnection.getInstance().getConnection();
            // JOIN the Guest and Reservation tables
            String sql = "SELECT g.guestID, g.name, g.address, g.contactNo, r.reservationID, r.roomType, r.checkInDate, r.checkOutDate " +
                    "FROM Guest g JOIN Reservation r ON g.guestID = r.guestID " +
                    "WHERE g.guestID = ?";

            java.sql.PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, guestID);
            java.sql.ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                details.put("guestID", String.valueOf(rs.getInt("guestID")));
                details.put("name", rs.getString("name"));
                details.put("address", rs.getString("address"));
                details.put("contactNo", rs.getString("contactNo"));
                details.put("reservationID", String.valueOf(rs.getInt("reservationID")));
                details.put("roomType", rs.getString("roomType"));
                details.put("checkInDate", rs.getString("checkInDate"));
                details.put("checkOutDate", rs.getString("checkOutDate"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // Returns null if no data is available.
        return details.isEmpty() ? null : details;
    }
}