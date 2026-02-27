package com.oceanview.dao;

import com.oceanview.model.Guest;
import com.oceanview.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class GuestDAO {

    // Method to insert a new guest into the database
    public boolean registerGuest(Guest guest) {
        boolean isSuccess = false;
        // Using Singleton DBConnection
        Connection conn = DBConnection.getInstance().getConnection();
        String sql = "INSERT INTO guest (name, address, contactNo) VALUES (?, ?, ?)";

        try {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, guest.getName());
            pstmt.setString(2, guest.getAddress());
            pstmt.setString(3, guest.getContactNo());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                isSuccess = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    // Inserting or updating Guest Details into the 'guest' table
    public int saveOrUpdateGuest(String name, String nic, String email, String address, String contactNo) {
        int guestId = -1;
        try {
            Connection conn = DBConnection.getInstance().getConnection();

            // First, check if someone with this NIC already exists in the system.
            String checkSql = "SELECT guestID FROM guest WHERE nic = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, nic);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // If someone is present, update their data and obtain the relevant guestID.
                guestId = rs.getInt("guestID");
                String updateSql = "UPDATE guest SET name=?, email=?, address=?, contactNo=? WHERE guestID=?";
                PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                updateStmt.setString(1, name);
                updateStmt.setString(2, email);
                updateStmt.setString(3, address);
                updateStmt.setString(4, contactNo);
                updateStmt.setInt(5, guestId);
                updateStmt.executeUpdate();
            } else {
                // If it's a new user, insert new data into the 'guest' table and get the new guestID.
                String insertSql = "INSERT INTO guest (name, nic, email, address, contactNo) VALUES (?, ?, ?, ?, ?)";
                // RETURN_GENERATED_KEYS requests the newly generated Auto-Increment ID
                PreparedStatement insertStmt = conn.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS);
                insertStmt.setString(1, name);
                insertStmt.setString(2, nic);
                insertStmt.setString(3, email);
                insertStmt.setString(4, address);
                insertStmt.setString(5, contactNo);
                insertStmt.executeUpdate();

                ResultSet keys = insertStmt.getGeneratedKeys();
                if (keys.next()) {
                    guestId = keys.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return guestId; // Finally, the correct guestID is sent to the Servlet.
    }
}