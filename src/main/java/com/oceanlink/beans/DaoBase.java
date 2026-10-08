package com.oceanlink.beans;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public abstract class DaoBase {

    public Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        String user = "oceanlink";
        String pass = "oceanlink123";
        String url = "jdbc:mysql://localhost:3306/db_ocealink?serverTimezone=America/Lima";

        return DriverManager.getConnection(url, user, pass);
    }
}