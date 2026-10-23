package com.oceanlink.daos;

import com.oceanlink.beans.Segmento;

import java.sql.*;
import java.util.ArrayList;

public class SegmentoDao extends DaoBase {
    //este es metodo propio de segmento en la vist de landing ARLES NO LO QUITES PORFAVOOOOR
    public ArrayList<Segmento> listarSegmentosPorLanding(int idLandingStation) {

        ArrayList<Segmento> lista = new ArrayList<>();
        try {
            String user = "oceanlink";
            String pass = "oceanlink123";
            String url = "jdbc:mysql://localhost:3306/db_ocealink?serverTimezone=America/Lima";
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM segmento WHERE idOrigen = ? OR idDestino = ? ORDER BY idSegmento");) {
                pstmt.setInt(1, idLandingStation);
                pstmt.setInt(2, idLandingStation);

                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        Segmento s = new Segmento();
                        s.setIdSegmento(rs.getInt("idSegmento"));
                        s.setIdOrigen(rs.getInt("idOrigen"));
                        s.setIdDestino(rs.getInt("idDestino"));
                        s.setCapacidadTotal(rs.getBigDecimal("capacidadTotal"));
                        s.setCapacidadUsada(rs.getBigDecimal("capacidadUsada"));
                        s.setCapacidadReservada(rs.getBigDecimal("capacidadReservada"));
                        s.setEstado(rs.getString("estado"));
                        lista.add(s);
                    }
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return lista;
    }

    public ArrayList<Segmento> listarSegmentos() {
        ArrayList<Segmento> lista = new ArrayList<>();
        String sql = "SELECT s.*, o.nombre AS nombreOrigen, d.nombre AS nombreDestino "
                + "FROM segmento s "
                + "JOIN landingstation o ON s.idOrigen = o.idLandingStation "
                + "JOIN landingstation d ON s.idDestino = d.idLandingStation "
                + "ORDER BY s.idSegmento ASC";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Segmento s = new Segmento();
                s.setIdSegmento(rs.getInt("idSegmento"));
                s.setIdOrigen(rs.getInt("idOrigen"));
                s.setIdDestino(rs.getInt("idDestino"));
                s.setCapacidadTotal(rs.getBigDecimal("capacidadTotal"));
                s.setCapacidadUsada(rs.getBigDecimal("capacidadUsada"));
                s.setCapacidadReservada(rs.getBigDecimal("capacidadReservada"));
                s.setEstado(rs.getString("estado"));
                s.setNombreOrigen(rs.getString("nombreOrigen"));
                s.setNombreDestino(rs.getString("nombreDestino"));
                lista.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public void registrarSegmento(int idOrigen, int idDestino, double capacidadTotal, String estado) {
        String sql = "INSERT INTO segmento (idOrigen, idDestino, capacidadTotal, estado) "
                + "VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idOrigen);
            pstmt.setInt(2, idDestino);
            pstmt.setDouble(3, capacidadTotal);
            pstmt.setString(4, estado);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void actualizarSegmento(int idSegmento, int idOrigen, int idDestino, double capacidadTotal, String estado) {
        String sql = "UPDATE segmento SET idOrigen = ?, idDestino = ?, capacidadTotal = ?, estado = ? "
                + "WHERE idSegmento = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idOrigen);
            pstmt.setInt(2, idDestino);
            pstmt.setDouble(3, capacidadTotal);
            pstmt.setString(4, estado);
            pstmt.setInt(5, idSegmento);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean borrarSegmento(int idSegmento) {
        String sql = "DELETE FROM segmento WHERE idSegmento = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idSegmento);
            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}