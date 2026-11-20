package com.oceanlink.daos;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public abstract class DaoBase {

    public Connection getConnection() throws SQLException {
        try {
            DataSource ds = (DataSource) new InitialContext().lookup("java:comp/env/jdbc/MyDB");
            return ds.getConnection();
        } catch (NamingException e) {
            throw new SQLException("No se encontró el recurso jdbc/MyDB en Tomcat", e);
        }
    }
}
