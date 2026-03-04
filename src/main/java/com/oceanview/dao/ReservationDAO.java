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

    public Map<String, Integer> getAvailableRoomCounts(String checkIn, String checkOut) {
        Map<String, Integer> availableRooms = new HashMap<>();
        availableRooms.put("Single", 10);
        availableRooms.put("Double", 10);
        availableRooms.put("Suite", 5);
        availableRooms.put("Family", 5);

        String sql = "SELECT roomType, COUNT(*) as bookedCount FROM reservation WHERE checkInDate < ? AND checkOutDate > ? AND (status IS NULL OR status != 'Cancelled') GROUP BY roomType";

        try {
            Connection conn = DBConnection.getInstance().getConnection();
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, checkOut);
                pstmt.setString(2, checkIn);

                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        String type = rs.getString("roomType");
                        int booked = rs.getInt("bookedCount");
                        if (availableRooms.containsKey(type)) {
                            availableRooms.put(type, availableRooms.get(type) - booked);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return availableRooms;
    }

    public int addCompleteReservation(Guest guest, Reservation reservation) {
        int guestID = -1;
        Connection conn = null;

        try {
            conn = DBConnection.getInstance().getConnection();
            // Start transaction
            conn.setAutoCommit(false);

            String checkSql = "SELECT guestID FROM guest WHERE nic = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, guest.getNic());
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        guestID = rs.getInt("guestID");
                    } else {
                        String sqlGuest = "INSERT INTO guest (name, nic, email, address, contactNo) VALUES (?, ?, ?, ?, ?)";
                        try (PreparedStatement pstmtGuest = conn.prepareStatement(sqlGuest, Statement.RETURN_GENERATED_KEYS)) {
                            pstmtGuest.setString(1, guest.getName());
                            pstmtGuest.setString(2, guest.getNic());
                            pstmtGuest.setString(3, guest.getEmail());
                            pstmtGuest.setString(4, guest.getAddress());
                            pstmtGuest.setString(5, guest.getContactNo());
                            pstmtGuest.executeUpdate();

                            try (ResultSet rsKeys = pstmtGuest.getGeneratedKeys()) {
                                if (rsKeys.next()) guestID = rsKeys.getInt(1);
                            }
                        }
                    }
                }
            }

            if (guestID > 0) {
                String sqlRes = "INSERT INTO reservation (guestID, roomType, checkInDate, checkOutDate, noOfPersons) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement pstmtRes = conn.prepareStatement(sqlRes)) {
                    pstmtRes.setInt(1, guestID);
                    pstmtRes.setString(2, reservation.getRoomType());
                    pstmtRes.setString(3, reservation.getCheckInDate());
                    pstmtRes.setString(4, reservation.getCheckOutDate());
                    pstmtRes.setInt(5, reservation.getNoOfPersons());
                    pstmtRes.executeUpdate();
                }
                // Commit transaction if both insert/updates are successful
                conn.commit();
            } else {
                conn.rollback();
            }

        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            throw new RuntimeException(e.getMessage());
        } finally {
            // Restore default auto-commit behavior
            try { if (conn != null) conn.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
        }
        return guestID;
    }

    public Map<String, String> getCompleteReservationDetails(String contactNo) {
        Map<String, String> details = new HashMap<>();
        String sql = "SELECT g.guestID, g.name, g.address, g.contactNo, r.reservationID, r.roomType, r.checkInDate, r.checkOutDate, r.status " +
                "FROM guest g JOIN reservation r ON g.guestID = r.guestID " +
                "WHERE g.contactNo = ?";

        try {
            Connection conn = DBConnection.getInstance().getConnection();
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, contactNo);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        details.put("guestID", String.valueOf(rs.getInt("guestID")));
                        details.put("name", rs.getString("name"));
                        details.put("address", rs.getString("address"));
                        details.put("contactNo", rs.getString("contactNo"));
                        details.put("reservationID", String.valueOf(rs.getInt("reservationID")));
                        details.put("roomType", rs.getString("roomType"));
                        details.put("checkInDate", rs.getString("checkInDate"));
                        details.put("checkOutDate", rs.getString("checkOutDate"));
                        details.put("status", rs.getString("status"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return details.isEmpty() ? null : details;
    }

    public boolean bookRoom(Reservation reservation) {
        String sql = "INSERT INTO reservation (guestID, roomType, checkInDate, checkOutDate) VALUES (?, ?, ?, ?)";
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, reservation.getGuestId());
                pstmt.setString(2, reservation.getRoomType());
                pstmt.setString(3, reservation.getCheckInDate());
                pstmt.setString(4, reservation.getCheckOutDate());
                return pstmt.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int addReservation(Reservation res) {
        int generatedId = -1;
        String sql = "INSERT INTO reservation (guestID, roomType, checkInDate, checkOutDate, noOfPersons) VALUES (?, ?, ?, ?, ?)";

        try {
            Connection conn = DBConnection.getInstance().getConnection();
            try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                pstmt.setInt(1, res.getGuestId());
                pstmt.setString(2, res.getRoomType());
                pstmt.setString(3, res.getCheckInDate());
                pstmt.setString(4, res.getCheckOutDate());
                pstmt.setInt(5, res.getNoOfPersons());

                if (pstmt.executeUpdate() > 0) {
                    try (ResultSet rs = pstmt.getGeneratedKeys()) {
                        if (rs.next()) {
                            generatedId = rs.getInt(1);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return generatedId;
    }

    public Map<String, String> getReservationDetailsById(int resId) {
        Map<String, String> details = new HashMap<>();
        String sql = "SELECT g.guestID, g.name, g.address, g.contactNo, g.nic, g.email, r.reservationID, r.roomType, r.checkInDate, r.checkOutDate, r.noOfPersons, r.status " +
                "FROM guest g JOIN reservation r ON g.guestID = r.guestID " +
                "WHERE r.reservationID = ?";

        try {
            Connection conn = DBConnection.getInstance().getConnection();
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, resId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        details.put("guestID", String.valueOf(rs.getInt("guestID")));
                        details.put("name", rs.getString("name"));
                        details.put("address", rs.getString("address"));
                        details.put("contactNo", rs.getString("contactNo"));
                        details.put("nic", rs.getString("nic"));
                        details.put("email", rs.getString("email"));
                        details.put("reservationID", String.valueOf(rs.getInt("reservationID")));
                        details.put("roomType", rs.getString("roomType"));
                        details.put("checkInDate", rs.getString("checkInDate"));
                        details.put("checkOutDate", rs.getString("checkOutDate"));
                        details.put("noOfPersons", String.valueOf(rs.getInt("noOfPersons")));
                        details.put("status", rs.getString("status"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return details.isEmpty() ? null : details;
    }

    public List<Reservation> getAllReservations() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM reservation";

        try {
            Connection conn = DBConnection.getInstance().getConnection();
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Reservation r = new Reservation();
                    r.setReservationId(rs.getInt("reservationID"));
                    r.setGuestId(rs.getInt("guestID"));
                    r.setRoomType(rs.getString("roomType"));
                    r.setCheckInDate(rs.getString("checkInDate"));
                    r.setCheckOutDate(rs.getString("checkOutDate"));
                    r.setNoOfPersons(rs.getInt("noOfPersons"));
                    list.add(r);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deleteReservation(int id) {
        String sql = "DELETE FROM reservation WHERE reservationID = ?";
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, id);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Reservation getReservationById(int id) {
        Reservation r = null;
        String sql = "SELECT * FROM reservation WHERE reservationID = ?";

        try {
            Connection conn = DBConnection.getInstance().getConnection();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        r = new Reservation();
                        r.setReservationId(rs.getInt("reservationID"));
                        r.setGuestId(rs.getInt("guestID"));
                        r.setRoomType(rs.getString("roomType"));
                        r.setCheckInDate(rs.getString("checkInDate"));
                        r.setCheckOutDate(rs.getString("checkOutDate"));
                        r.setNoOfPersons(rs.getInt("noOfPersons"));
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return r;
    }

    public boolean updateReservationByAdmin(Reservation r) {
        String sql = "UPDATE reservation SET roomType=?, checkInDate=?, checkOutDate=?, noOfPersons=? WHERE reservationID=?";
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, r.getRoomType());
                ps.setString(2, r.getCheckInDate());
                ps.setString(3, r.getCheckOutDate());
                ps.setInt(4, r.getNoOfPersons());
                ps.setInt(5, r.getReservationId());
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Map<String, String>> getCustomerReservations(String username) {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT r.reservationID, g.name, g.nic, g.contactNo, r.roomType, r.noOfPersons, r.checkInDate, r.checkOutDate, r.status " +
                "FROM reservation r " +
                "JOIN guest g ON r.guestID = g.guestID " +
                "JOIN users u ON g.contactNo = u.phone " +
                "WHERE u.username = ? ORDER BY r.reservationID DESC";

        try {
            Connection conn = DBConnection.getInstance().getConnection();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, username);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> map = new HashMap<>();
                        map.put("reservationID", String.valueOf(rs.getInt("reservationID")));
                        map.put("name", rs.getString("name"));
                        map.put("nic", rs.getString("nic"));
                        map.put("contactNo", rs.getString("contactNo"));
                        map.put("roomType", rs.getString("roomType"));
                        map.put("noOfPersons", String.valueOf(rs.getInt("noOfPersons")));
                        map.put("checkInDate", rs.getDate("checkInDate").toString());
                        map.put("checkOutDate", rs.getDate("checkOutDate").toString());
                        map.put("status", rs.getString("status"));
                        list.add(map);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, String>> searchReservations(String searchValue) {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT r.reservationID, g.name, g.nic, g.contactNo, r.roomType, r.noOfPersons, r.checkInDate, r.checkOutDate, r.status " +
                "FROM reservation r " +
                "JOIN guest g ON r.guestID = g.guestID " +
                "WHERE r.reservationID = ? OR g.contactNo = ? ORDER BY r.reservationID DESC";

        try {
            Connection conn = DBConnection.getInstance().getConnection();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {

                int resId = 0;
                try {
                    resId = Integer.parseInt(searchValue);
                } catch (NumberFormatException e) {
                    // Ignore parsing error; it means the searchValue is not an ID (e.g., a phone number).
                    // resId remains 0, so the ID condition in SQL will naturally fail, and it will search by phone.
                }

                ps.setInt(1, resId);
                ps.setString(2, searchValue);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> map = new HashMap<>();
                        map.put("reservationID", String.valueOf(rs.getInt("reservationID")));
                        map.put("name", rs.getString("name"));
                        map.put("nic", rs.getString("nic"));
                        map.put("contactNo", rs.getString("contactNo"));
                        map.put("roomType", rs.getString("roomType"));
                        map.put("noOfPersons", String.valueOf(rs.getInt("noOfPersons")));
                        map.put("checkInDate", rs.getDate("checkInDate").toString());
                        map.put("checkOutDate", rs.getDate("checkOutDate").toString());
                        map.put("status", rs.getString("status"));
                        list.add(map);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, String> getInvoiceDetailsSecure(String bookingId, String role, String username) {
        Map<String, String> details = null;
        String sql = "SELECT r.reservationID, g.name, g.contactNo, g.email, g.nic, g.address, " +
                "r.roomType, r.noOfPersons, r.checkInDate, r.checkOutDate, r.status, " +
                "DATEDIFF(r.checkOutDate, r.checkInDate) as nights " +
                "FROM reservation r " +
                "JOIN guest g ON r.guestID = g.guestID ";

        if ("Customer".equals(role)) {
            sql += "JOIN users u ON g.contactNo = u.phone WHERE r.reservationID = ? AND u.username = ?";
        } else {
            sql += "WHERE r.reservationID = ?";
        }

        try {
            Connection conn = DBConnection.getInstance().getConnection();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, Integer.parseInt(bookingId));

                if ("Customer".equals(role)) {
                    ps.setString(2, username);
                }

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        details = new HashMap<>();
                        details.put("reservationID", String.valueOf(rs.getInt("reservationID")));
                        details.put("name", rs.getString("name"));
                        details.put("contactNo", rs.getString("contactNo"));
                        details.put("email", rs.getString("email"));
                        details.put("nic", rs.getString("nic") != null ? rs.getString("nic") : "N/A");
                        details.put("address", rs.getString("address"));

                        String roomType = rs.getString("roomType");
                        details.put("roomType", roomType);
                        details.put("noOfPersons", String.valueOf(rs.getInt("noOfPersons")));
                        details.put("checkInDate", rs.getDate("checkInDate").toString());
                        details.put("checkOutDate", rs.getDate("checkOutDate").toString());
                        details.put("status", rs.getString("status"));

                        int nights = rs.getInt("nights");
                        if (nights <= 0) nights = 1;
                        details.put("nights", String.valueOf(nights));

                        double pricePerNight = 0;
                        switch (roomType) {
                            case "Single": pricePerNight = 10000; break;
                            case "Double": pricePerNight = 15000; break;
                            case "Family": pricePerNight = 25000; break;
                            case "Suite":  pricePerNight = 30000; break;
                            default: pricePerNight = 10000;
                        }
                        double totalAmount = pricePerNight * nights;

                        details.put("totalAmount", String.format("%,.2f", totalAmount));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return details;
    }

    public boolean requestCancellation(int resId) {
        String sql = "UPDATE reservation SET status = 'Cancel_Requested' WHERE reservationID = ?";
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, resId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean approveCancellation(int resId) {
        String sql = "UPDATE reservation SET status = 'Cancelled' WHERE reservationID = ?";
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, resId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Map<String, String>> getCancellationRequests() {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT r.reservationID, g.name, r.checkInDate, r.status " +
                "FROM reservation r " +
                "JOIN guest g ON r.guestID = g.guestID " +
                "WHERE r.status = 'Cancel_Requested'";

        try {
            Connection conn = DBConnection.getInstance().getConnection();
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Map<String, String> map = new HashMap<>();
                    map.put("reservationID", String.valueOf(rs.getInt("reservationID")));
                    map.put("name", rs.getString("name"));
                    map.put("checkInDate", rs.getString("checkInDate"));
                    map.put("status", rs.getString("status"));
                    list.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}