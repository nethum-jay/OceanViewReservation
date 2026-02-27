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

    // Retrieving user information by username (to update profile)
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

    // User can update their own data
    public boolean updateFullProfile(String oldUname, String newUname, String pass, String phone, String name, String nic, String email, String addr) {
        boolean isSuccess = false;
        Connection conn = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            // Let's disable AutoCommit since we are updating two data tables
            conn.setAutoCommit(false);

            // Retrieving the old phone number from the database
            String oldPhone = null;
            String getPhoneSql = "SELECT phone FROM users WHERE username=?";
            PreparedStatement psGetPhone = conn.prepareStatement(getPhoneSql);
            psGetPhone.setString(1, oldUname);
            ResultSet rsPhone = psGetPhone.executeQuery();
            if (rsPhone.next()) {
                oldPhone = rsPhone.getString("phone");
            }

            // පියවර B: 'users' වගුව අලුත් දත්ත වලින් යාවත්කාලීන කිරීම
            String sqlUsers = "UPDATE users SET username=?, password=?, phone=?, fullName=?, nic=?, email=?, address=? WHERE username=?";
            PreparedStatement psUsers = conn.prepareStatement(sqlUsers);
            psUsers.setString(1, newUname);
            psUsers.setString(2, pass);
            psUsers.setString(3, phone);
            psUsers.setString(4, name);
            psUsers.setString(5, nic);
            psUsers.setString(6, email);
            psUsers.setString(7, addr);
            psUsers.setString(8, oldUname);
            int usersUpdated = psUsers.executeUpdate();

            if (oldPhone != null && !oldPhone.trim().isEmpty()) {
                String sqlGuest = "UPDATE guest SET name=?, nic=?, email=?, address=?, contactNo=? WHERE contactNo=?";
                PreparedStatement psGuest = conn.prepareStatement(sqlGuest);
                psGuest.setString(1, name);
                psGuest.setString(2, nic);
                psGuest.setString(3, email);
                psGuest.setString(4, addr);
                psGuest.setString(5, phone);    // අලුත් දුරකථන අංකය
                psGuest.setString(6, oldPhone); // පැරණි දුරකථන අංකය
                psGuest.executeUpdate();
            }

            // පියවරයන් සාර්ථක නම් Commit කිරීම
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
            pstmt.setString(7, u.getNic());
            pstmt.setString(8, u.getAddress());
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