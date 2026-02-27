package com.oceanview.dao;

import com.oceanview.model.User;
import com.oceanview.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // Checking the name and password when the user logs in
    public User authenticateUser(String username, String password) {
        User user = null;
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            String sql = "SELECT * FROM users WHERE username=? AND password=?";
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

    // Get all the user details by username
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
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setPhone(rs.getString("phone"));
                user.setFullName(rs.getString("fullName"));
                user.setNic(rs.getString("nic"));
                user.setEmail(rs.getString("email"));
                user.setAddress(rs.getString("address"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    // Customer updates their details themselves
    public boolean updateFullProfile(String oldUname, String newUname, String pass, String phone, String name, String nic, String email, String addr) {
        boolean isSuccess = false;
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            String sql = "UPDATE users SET username=?, password=?, phone=?, fullName=?, nic=?, email=?, address=? WHERE username=?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newUname);
            pstmt.setString(2, pass);
            pstmt.setString(3, phone);
            pstmt.setString(4, name);
            pstmt.setString(5, nic);
            pstmt.setString(6, email);
            pstmt.setString(7, addr);
            pstmt.setString(8, oldUname);

            if (pstmt.executeUpdate() > 0) isSuccess = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    // Getting a list of all users in the system
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

    // Retrieve all data by ID
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
                user.setPassword(rs.getString("password")); // Password එක ලබා ගැනීම
                user.setRole(rs.getString("role"));
                user.setPhone(rs.getString("phone"));
                user.setFullName(rs.getString("fullName"));
                user.setNic(rs.getString("nic"));
                user.setEmail(rs.getString("email"));
                user.setAddress(rs.getString("address"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    // Method for Admin to Update All Data in MySQL Workbench
    public boolean updateUserDetailsByAdmin(User u) {
        boolean isSuccess = false;
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            String sql = "UPDATE users SET username=?, password=?, role=?, phone=?, fullName=?, email=?, nic=?, address=? WHERE id=?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, u.getUsername());
            pstmt.setString(2, u.getPassword());
            pstmt.setString(3, u.getRole());
            pstmt.setString(4, u.getPhone());
            pstmt.setString(5, u.getFullName());
            pstmt.setString(6, u.getEmail());
            pstmt.setString(7, u.getNic());     // අලුත් දත්ත
            pstmt.setString(8, u.getAddress()); // අලුත් දත්ත
            pstmt.setInt(9, u.getId());

            if (pstmt.executeUpdate() > 0) isSuccess = true;
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
}