package com.oceanview.dao;

import com.oceanview.model.Reservation;
import com.oceanview.model.Guest;
import com.oceanview.util.DBConnection;
import java.util.Map;
import java.util.HashMap;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    // The method for finding the number of rooms
    public Map<String, Integer> getAvailableRoomCounts(String checkIn, String checkOut) {
        Map<String, Integer> availableRooms = new HashMap<>();
        availableRooms.put("Single", 10);
        availableRooms.put("Double", 10);
        availableRooms.put("Suite", 5);
        availableRooms.put("Family", 5);

        try {
            Connection conn = DBConnection.getInstance().getConnection();
            String sql = "SELECT roomType, COUNT(*) as bookedCount FROM Reservation WHERE checkInDate < ? AND checkOutDate > ? GROUP BY roomType";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, checkOut);
            pstmt.setString(2, checkIn);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                String type = rs.getString("roomType");
                int booked = rs.getInt("bookedCount");
                if (availableRooms.containsKey(type)) {
                    availableRooms.put(type, availableRooms.get(type) - booked);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return availableRooms;
    }

    // Method for saving a booking
    public int addCompleteReservation(Guest guest, Reservation reservation) {
        int guestID = -1;
        Connection conn = null;

        try {
            conn = DBConnection.getInstance().getConnection();
            conn.setAutoCommit(false);

            // NIC check
            String checkSql = "SELECT guestID FROM guest WHERE nic = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, guest.getNic());
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                guestID = rs.getInt("guestID");
            } else {
                String sqlGuest = "INSERT INTO guest (name, nic, email, address, contactNo) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement pstmtGuest = conn.prepareStatement(sqlGuest, Statement.RETURN_GENERATED_KEYS);
                pstmtGuest.setString(1, guest.getName());
                pstmtGuest.setString(2, guest.getNic());
                pstmtGuest.setString(3, guest.getEmail());
                pstmtGuest.setString(4, guest.getAddress());
                pstmtGuest.setString(5, guest.getContactNo());
                pstmtGuest.executeUpdate();
                ResultSet rsKeys = pstmtGuest.getGeneratedKeys();
                if (rsKeys.next()) guestID = rsKeys.getInt(1);
            }

            if (guestID > 0) {
                String sqlRes = "INSERT INTO Reservation (guestID, roomType, checkInDate, checkOutDate, noOfPersons) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement pstmtRes = conn.prepareStatement(sqlRes);
                pstmtRes.setInt(1, guestID);
                pstmtRes.setString(2, reservation.getRoomType());
                pstmtRes.setString(3, reservation.getCheckInDate());
                pstmtRes.setString(4, reservation.getCheckOutDate());
                pstmtRes.setInt(5, reservation.getNoOfPersons());
                pstmtRes.executeUpdate();

                conn.commit();
            } else {
                conn.rollback();
            }

        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            throw new RuntimeException(e.getMessage());
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
        }
        return guestID;
    }

    // Method to get Reservation Details
    public Map<String, String> getCompleteReservationDetails(String contactNo) {
        Map<String, String> details = new HashMap<>();
        try {
            Connection conn = DBConnection.getInstance().getConnection();

            String sql = "SELECT g.guestID, g.name, g.address, g.contactNo, r.reservationID, r.roomType, r.checkInDate, r.checkOutDate " +
                    "FROM Guest g JOIN Reservation r ON g.guestID = r.guestID " +
                    "WHERE g.contactNo = ?";

            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, contactNo);
            ResultSet rs = pstmt.executeQuery();

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
        return details.isEmpty() ? null : details;
    }

    // Method for reserving a room for an existing guest
    public boolean bookRoom(Reservation reservation) {
        boolean isSuccess = false;
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            String sql = "INSERT INTO Reservation (guestID, roomType, checkInDate, checkOutDate) VALUES (?, ?, ?, ?)";

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

    // Method for getting all bookings
    public List<Reservation> getAllReservations() {
        List<Reservation> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            String sql = "SELECT * FROM reservation";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Reservation r = new Reservation();
                r.setReservationID(rs.getInt("reservationID"));
                r.setGuestID(rs.getInt("guestID"));
                r.setRoomType(rs.getString("roomType"));
                r.setCheckInDate(rs.getString("checkInDate"));
                r.setCheckOutDate(rs.getString("checkOutDate"));
                r.setNoOfPersons(rs.getInt("noOfPersons"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Delete Booking
    public boolean deleteReservation(int id) {
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            String sql = "DELETE FROM reservation WHERE reservationID = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Retrieving Edit Form data by ID
    public Reservation getReservationById(int id) {
        Reservation r = null;
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            String sql = "SELECT * FROM reservation WHERE reservationID = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                r = new Reservation();
                r.setReservationID(rs.getInt("reservationID"));
                r.setGuestID(rs.getInt("guestID"));
                r.setRoomType(rs.getString("roomType"));
                r.setCheckInDate(rs.getString("checkInDate"));
                r.setCheckOutDate(rs.getString("checkOutDate"));
                r.setNoOfPersons(rs.getInt("noOfPersons"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return r;
    }

    // Sending update booking data to the database
    public boolean updateReservationByAdmin(Reservation r) {
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            String sql = "UPDATE reservation SET roomType=?, checkInDate=?, checkOutDate=?, noOfPersons=? WHERE reservationID=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, r.getRoomType());
            ps.setString(2, r.getCheckInDate());
            ps.setString(3, r.getCheckOutDate());
            ps.setInt(4, r.getNoOfPersons());
            ps.setInt(5, r.getReservationID());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}