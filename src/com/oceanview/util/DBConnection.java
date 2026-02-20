package com.oceanview.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

// Private static instance
public class DBConnection {
    private static DBConnection instance;
    private Connection connection;

    // 2. Private constructor
    private String url = "jdbc:mysql://localhost:3306/oceanview_db";
    private String username = "root";
    private String password = "root123";


    private DBConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            this.connection = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }

    public static DBConnection getInstance() {
        if (instance == null) {
            instance = new DBConnection();
        }
        return instance;
    }

    public Connection getConnection() {
        return connection;
    }
}