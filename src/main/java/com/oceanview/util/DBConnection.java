package com.oceanview.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // Volatile keyword ensures changes made by one thread are immediately visible to others
    private static volatile DBConnection instance;
    private Connection connection;

    // Database credentials made 'final' as they shouldn't change
    private final String url = "jdbc:mysql://localhost:3306/oceanview_db";
    private final String username = "root";
    private final String password = "root";

    // Private constructor prevents instantiation from other classes
    private DBConnection() {
        createConnection();
    }

    // Extracted connection logic to reuse when connection drops
    private void createConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            this.connection = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to connect to the database.");
        }
    }

    // Thread-safe Singleton implementation using Double-Checked Locking
    public static DBConnection getInstance() {
        if (instance == null) {
            synchronized (DBConnection.class) {
                if (instance == null) {
                    instance = new DBConnection();
                }
            }
        }
        return instance;
    }

    // Returns the connection, ensuring it is active and not closed by timeout
    public Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                createConnection(); // Re-establish connection if it was closed
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return connection;
    }
}