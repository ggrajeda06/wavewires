package com.oceanlink.daos;

import com.oceanlink.beans.Mantenimiento;

import java.sql.*;
import java.util.ArrayList;

public class MantenimientoDao {

    public ArrayList<Mantenimiento> listarMantenimientos() {

        ArrayList<Mantenimiento> lista = new ArrayList<>();
        try {
            String user = "oceanlink";
            String pass = "oceanlink123";
            String url = "jdbc:mysql://localhost:3306/db_ocealink?serverTimezone=America/Lima";
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT * FROM mantenimiento ORDER BY fechaRegistrada DESC")) {

                while (rs.next()) {
                    Mantenimiento m = new Mantenimiento();
                    m.setIdMantenimiento(rs.getInt("idMantenimiento"));
                    m.setNombre(rs.getString("nombre"));
                    m.setDescripcion(rs.getString("descripcion"));
                    m.setTipo(rs.getString("tipo"));
                    m.setEstado(rs.getString("estado"));
                    m.setFechaRegistrada(rs.getDate("fechaRegistrada"));
                    m.setDuracionHoras(rs.getInt("duracionHoras"));
                    m.setActividadesRealizadas(rs.getString("actividadesRealizadas"));
                    m.setIdLandingStation(rs.getInt("idLandingStation"));
                    lista.add(m);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return lista;
    }

    public Mantenimiento obtenerMantenimiento(int idMantenimiento) {

        Mantenimiento m = null;
        try {
            String user = "oceanlink";
            String pass = "oceanlink123";
            String url = "jdbc:mysql://localhost:3306/db_ocealink?serverTimezone=America/Lima";

            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM mantenimiento WHERE idMantenimiento = ?");) {
                pstmt.setInt(1, idMantenimiento);

                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        m = new Mantenimiento();
                        m.setIdMantenimiento(rs.getInt("idMantenimiento"));
                        m.setNombre(rs.getString("nombre"));
                        m.setDescripcion(rs.getString("descripcion"));
                        m.setTipo(rs.getString("tipo"));
                        m.setEstado(rs.getString("estado"));
                        m.setFechaRegistrada(rs.getDate("fechaRegistrada"));
                        m.setDuracionHoras(rs.getInt("duracionHoras"));
                        m.setActividadesRealizadas(rs.getString("actividadesRealizadas"));
                        m.setIdLandingStation(rs.getInt("idLandingStation"));
                    }
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return m;
    }

    public void crearMantenimiento(String nombre, String descripcion, String tipo, String estado,
                                   String fechaRegistrada, int duracionHoras, int idLandingStation) {
        try {
            String user = "oceanlink";
            String pass = "oceanlink123";
            String url = "jdbc:mysql://localhost:3306/db_ocealink?serverTimezone=America/Lima";
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);) {
                String sql = "INSERT INTO mantenimiento (nombre, descripcion, tipo, estado, fechaRegistrada, duracionHoras, idLandingStation) "
                        + "VALUES (?,?,?,?,?,?,?)";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, nombre);
                    pstmt.setString(2, descripcion);
                    pstmt.setString(3, tipo);
                    pstmt.setString(4, estado);
                    pstmt.setString(5, fechaRegistrada);
                    pstmt.setInt(6, duracionHoras);
                    pstmt.setInt(7, idLandingStation);
                    pstmt.executeUpdate();
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public void actualizarMantenimiento(int idMantenimiento, String nombre, String estado, String actividadesRealizadas) {
        try {
            String user = "oceanlink";
            String pass = "oceanlink123";
            String url = "jdbc:mysql://localhost:3306/db_ocealink?serverTimezone=America/Lima";
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);) {
                String sql = "UPDATE mantenimiento SET nombre = ?, estado = ?, actividadesRealizadas = ? "
                        + "WHERE idMantenimiento = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, nombre);
                    pstmt.setString(2, estado);
                    pstmt.setString(3, actividadesRealizadas);
                    pstmt.setInt(4, idMantenimiento);
                    pstmt.executeUpdate();
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public void borrarMantenimiento(int idMantenimiento) {
        try {
            String user = "oceanlink";
            String pass = "oceanlink123";
            String url = "jdbc:mysql://localhost:3306/db_ocealink?serverTimezone=America/Lima";
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);) {
                String sql = "DELETE FROM mantenimiento WHERE idMantenimiento = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setInt(1, idMantenimiento);
                    pstmt.executeUpdate();
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}