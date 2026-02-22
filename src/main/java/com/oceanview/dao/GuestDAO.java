package com.oceanview.dao;

import com.oceanview.model.Guest;
import com.oceanview.util.DBConnection; // Your Singleton class
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class GuestDAO {

    // Method to insert a new guest into the database
    public boolean registerGuest(Guest guest) {
        boolean isSuccess = false;
        // Using Singleton DBConnection
        Connection conn = DBConnection.getInstance().getConnection();
        String sql = "INSERT INTO Guest (name, address, contactNo) VALUES (?, ?, ?)";

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
}