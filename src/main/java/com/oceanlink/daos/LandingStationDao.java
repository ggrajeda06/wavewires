package com.oceanlink.daos;

import com.oceanlink.beans.LandingStation;

import java.sql.*;
import java.util.ArrayList;

public class LandingStationDao {

    public ArrayList<LandingStation> listarLandingStations() {

        ArrayList<LandingStation> lista = new ArrayList<>();
        try {
            String user = "oceanlink";
            String pass = "oceanlink123";
            String url = "jdbc:mysql://localhost:3306/db_ocealink?serverTimezone=America/Lima";
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT * FROM landingstation")) {

                while (rs.next()) {
                    LandingStation ls = new LandingStation();
                    ls.setIdLandingStation(rs.getInt("idLandingStation"));
                    ls.setNombre(rs.getString("nombre"));
                    ls.setPais(rs.getString("pais"));
                    ls.setCiudad(rs.getString("ciudad"));
                    ls.setEstado(rs.getString("estado"));
                    lista.add(ls);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return lista;
    }

    public LandingStation obtenerLandingStation(int idLandingStation) {

        LandingStation ls = null;
        try {
            String user = "oceanlink";
            String pass = "oceanlink123";
            String url = "jdbc:mysql://localhost:3306/db_ocealink?serverTimezone=America/Lima";
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM landingstation WHERE idLandingStation = ?");) {
                pstmt.setInt(1, idLandingStation);

                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        ls = new LandingStation();
                        ls.setIdLandingStation(rs.getInt("idLandingStation"));
                        ls.setNombre(rs.getString("nombre"));
                        ls.setPais(rs.getString("pais"));
                        ls.setCiudad(rs.getString("ciudad"));
                        ls.setEstado(rs.getString("estado"));
                    }
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return ls;
    }

    public void crearLandingStation(String nombre, String pais, String ciudad, String estado) {
        try {
            String user = "oceanlink";
            String pass = "oceanlink123";
            String url = "jdbc:mysql://localhost:3306/db_ocealink?serverTimezone=America/Lima";
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);) {
                String sql = "INSERT INTO landingstation (nombre, pais, ciudad, estado) VALUES (?,?,?,?)";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, nombre);
                    pstmt.setString(2, pais);
                    pstmt.setString(3, ciudad);
                    pstmt.setString(4, estado);
                    pstmt.executeUpdate();
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public void actualizarLandingStation(int idLandingStation, String nombre, String pais, String ciudad, String estado) {
        try {
            String user = "oceanlink";
            String pass = "oceanlink123";
            String url = "jdbc:mysql://localhost:3306/db_ocealink?serverTimezone=America/Lima";
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);) {
                String sql = "UPDATE landingstation SET nombre = ?, pais = ?, ciudad = ?, estado = ? "
                        + "WHERE idLandingStation = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, nombre);
                    pstmt.setString(2, pais);
                    pstmt.setString(3, ciudad);
                    pstmt.setString(4, estado);
                    pstmt.setInt(5, idLandingStation);
                    pstmt.executeUpdate();
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public boolean borrarLandingStation(int idLandingStation) {

        boolean borrado = false;
        try {
            String user = "oceanlink";
            String pass = "oceanlink123";
            String url = "jdbc:mysql://localhost:3306/db_ocealink?serverTimezone=America/Lima";
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);) {
                String sql = "DELETE FROM landingstation WHERE idLandingStation = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setInt(1, idLandingStation);
                    borrado = pstmt.executeUpdate() > 0;
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return borrado;
    }
}