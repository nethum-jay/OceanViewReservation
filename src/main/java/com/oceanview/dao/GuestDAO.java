package com.oceanview.dao;

import com.oceanview.model.Guest;
import com.oceanview.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class GuestDAO {

    public boolean registerGuest(Guest guest) {
        String sql = "INSERT INTO guest (name, address, contactNo) VALUES (?, ?, ?)";

        try {
            Connection conn = DBConnection.getInstance().getConnection();

            // Using try-with-resources to automatically close the PreparedStatement and prevent memory leaks
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, guest.getName());
                pstmt.setString(2, guest.getAddress());
                pstmt.setString(3, guest.getContactNo());

                return pstmt.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int saveOrUpdateGuest(String name, String nic, String email, String address, String contactNo) {
        int guestId = -1;
        try {
            Connection conn = DBConnection.getInstance().getConnection();

            String checkSql = "SELECT guestID FROM guest WHERE contactNo = ? OR nic = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, contactNo);
                checkStmt.setString(2, nic);

                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {

                        // Update existing guest
                        guestId = rs.getInt("guestID");
                        String updateSql = "UPDATE guest SET name=?, nic=?, email=?, address=?, contactNo=? WHERE guestID=?";

                        try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                            updateStmt.setString(1, name);
                            updateStmt.setString(2, nic);
                            updateStmt.setString(3, email);
                            updateStmt.setString(4, address);
                            updateStmt.setString(5, contactNo);
                            updateStmt.setInt(6, guestId);
                            updateStmt.executeUpdate();
                        }
                    } else {

                        // Insert new guest and return generated ID
                        String insertSql = "INSERT INTO guest (name, nic, email, address, contactNo) VALUES (?, ?, ?, ?, ?)";
                        try (PreparedStatement insertStmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                            insertStmt.setString(1, name);
                            insertStmt.setString(2, nic);
                            insertStmt.setString(3, email);
                            insertStmt.setString(4, address);
                            insertStmt.setString(5, contactNo);
                            insertStmt.executeUpdate();

                            try (ResultSet keys = insertStmt.getGeneratedKeys()) {
                                if (keys.next()) {
                                    guestId = keys.getInt(1);
                                }
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return guestId;
    }
}