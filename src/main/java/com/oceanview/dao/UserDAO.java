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

    // 5. Retrieving user information by ID
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

    // Updating user data by Admin
    public boolean updateUserDetailsByAdmin(User u) {
        boolean isSuccess = false;
        Connection conn = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            conn.setAutoCommit(false);

            // To find the user's old phone number from the guest table
            String oldPhone = null;
            String getPhoneSql = "SELECT phone FROM users WHERE id=?";
            PreparedStatement psGetPhone = conn.prepareStatement(getPhoneSql);
            psGetPhone.setInt(1, u.getId());
            ResultSet rsPhone = psGetPhone.executeQuery();
            if (rsPhone.next()) {
                oldPhone = rsPhone.getString("phone");
            }

            // Updating the 'users' table
            String sqlUsers = "UPDATE users SET username=?, password=?, role=?, phone=?, fullName=?, email=?, nic=?, address=? WHERE id=?";
            PreparedStatement pstmt = conn.prepareStatement(sqlUsers);
            pstmt.setString(1, u.getUsername());
            pstmt.setString(2, u.getPassword());
            pstmt.setString(3, u.getRole());
            pstmt.setString(4, u.getPhone());
            pstmt.setString(5, u.getFullName());
            pstmt.setString(6, u.getEmail());
            pstmt.setString(7, u.getNic());
            pstmt.setString(8, u.getAddress());
            pstmt.setInt(9, u.getId());
            int usersUpdated = pstmt.executeUpdate();

            // If the person in question exists in the 'guest' table, update it
            if (oldPhone != null && !oldPhone.trim().isEmpty()) {
                String sqlGuest = "UPDATE guest SET name=?, nic=?, email=?, address=?, contactNo=? WHERE contactNo=?";
                PreparedStatement psGuest = conn.prepareStatement(sqlGuest);
                psGuest.setString(1, u.getFullName());
                psGuest.setString(2, u.getNic());
                psGuest.setString(3, u.getEmail());
                psGuest.setString(4, u.getAddress());
                psGuest.setString(5, u.getPhone());
                psGuest.setString(6, oldPhone);
                psGuest.executeUpdate();
            }

            // If everything is successful, save the data commit.
            if (usersUpdated > 0) {
                conn.commit();
                isSuccess = true;
            } else {
                conn.rollback();
            }

        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); } catch (Exception ex) { ex.printStackTrace(); }
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