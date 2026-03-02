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

            // වෙනස් කළ ස්ථානය: දුරකථන අංකය (contactNo) හෝ NIC එක තිබේදැයි පරීක්ෂා කිරීම.
            // මෙය Duplicate Entry Error එක සම්පූර්ණයෙන්ම වළක්වයි.
            String checkSql = "SELECT guestID FROM guest WHERE contactNo = ? OR nic = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, contactNo);
            checkStmt.setString(2, nic);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // If someone is present, update their data and obtain the relevant guestID.
                guestId = rs.getInt("guestID");

                // If a new NIC was provided during the update, it is also added to the nic=? to be updated.
                String updateSql = "UPDATE guest SET name=?, nic=?, email=?, address=?, contactNo=? WHERE guestID=?";
                PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                updateStmt.setString(1, name);
                updateStmt.setString(2, nic);
                updateStmt.setString(3, email);
                updateStmt.setString(4, address);
                updateStmt.setString(5, contactNo);
                updateStmt.setInt(6, guestId);
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