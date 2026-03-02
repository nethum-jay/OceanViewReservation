package com.oceanview.dao;

import com.oceanview.model.User;
import com.oceanview.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // Checking the name and password when logging into the system
    public User authenticateUser(String username, String password) {
        User user = null;
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            String sql = "SELECT * FROM users WHERE BINARY username=? AND BINARY password=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getString("role"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    // Registering new users
    public boolean registerUser(User user) {
        boolean isSuccess = false;
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            String sql = "INSERT INTO users (username, password, role, phone) VALUES (?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getRole());
            pstmt.setString(4, user.getPhone());

            if (pstmt.executeUpdate() > 0) {
                isSuccess = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
        return isSuccess;
    }

    // Retrieving user information by username
    public User getUserByUsername(String username) {
        User user = null;
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            String sql = "SELECT * FROM users WHERE username = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setPhone(rs.getString("phone"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    // Getting a list of all users in the system (for Admin)
    public List<User> getAllUsers() {
        List<User> userList = new ArrayList<>();
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            String sql = "SELECT id, username, role, phone FROM users ORDER BY id ASC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getString("role"));
                user.setPhone(rs.getString("phone") != null ? rs.getString("phone") : "Not Set");
                userList.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userList;
    }

    // Retrieving user information by ID
    public User getUserById(int id) {
        User user = null;
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            String sql = "SELECT * FROM users WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setPhone(rs.getString("phone"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    // Updating user account details by Admin
    public boolean updateUserDetailsByAdmin(User u) {
        boolean isSuccess = false;
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            String sql = "UPDATE users SET username=?, password=?, role=?, phone=? WHERE id=?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, u.getUsername());
            pstmt.setString(2, u.getPassword());
            pstmt.setString(3, u.getRole());
            pstmt.setString(4, u.getPhone());
            pstmt.setInt(5, u.getId());

            if (pstmt.executeUpdate() > 0) {
                isSuccess = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    // Removing a user from the system
    public boolean deleteUser(int id) {
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            String sql = "DELETE FROM users WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Checking if only the phone number is available in the system
    public boolean isUserExists(String phone) {
        boolean exists = false;
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            // Only checks the phone number.
            String sql = "SELECT * FROM users WHERE phone = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, phone);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                exists = true; // Someone from this number is already there
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return exists;
    }
}