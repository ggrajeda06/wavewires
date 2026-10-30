package com.oceanlink.daos;

import com.oceanlink.beans.LandingStation;

import java.sql.*;
import java.util.ArrayList;

public class LandingStationDao extends DaoBase {

    public ArrayList<LandingStation> listarLandingStations() {

        ArrayList<LandingStation> lista = new ArrayList<>();
        String sql = "SELECT * FROM landingstation";
        try (Connection conn = this.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                LandingStation ls = new LandingStation();
                ls.setIdLandingStation(rs.getInt("idLandingStation"));
                ls.setNombre(rs.getString("nombre"));
                ls.setPais(rs.getString("pais"));
                ls.setCiudad(rs.getString("ciudad"));
                ls.setEstado(rs.getString("estado"));
                lista.add(ls);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    public LandingStation obtenerLandingStation(int idLandingStation) {

        LandingStation ls = null;
        String sql = "SELECT * FROM landingstation WHERE idLandingStation = ?";
        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

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
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ls;
    }

    public void crearLandingStation(String nombre, String pais, String ciudad, String estado) {

        String sql = "INSERT INTO landingstation (nombre, pais, ciudad, estado) VALUES (?, ?, ?, ?)";
        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, nombre);
            pstmt.setString(2, pais);
            pstmt.setString(3, ciudad);
            pstmt.setString(4, estado);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void actualizarLandingStation(int idLandingStation, String nombre, String pais, String ciudad, String estado) {

        String sql = "UPDATE landingstation SET nombre = ?, pais = ?, ciudad = ?, estado = ? WHERE idLandingStation = ?";
        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, nombre);
            pstmt.setString(2, pais);
            pstmt.setString(3, ciudad);
            pstmt.setString(4, estado);
            pstmt.setInt(5, idLandingStation);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean borrarLandingStation(int idLandingStation) {

        boolean borrado = false;
        String sql = "DELETE FROM landingstation WHERE idLandingStation = ?";
        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idLandingStation);
            borrado = pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return borrado;
    }

    // con un mantenimiento activo la landing pasa a En mantenimiento; al terminar vuelve a Operativa
    public void recalcularEstado(int idLandingStation) {
        String sqlContar = "SELECT COUNT(*) FROM mantenimiento WHERE idLandingStation = ? AND estado = 'Activo'";
        String sqlMantenimiento = "UPDATE landingstation SET estado = 'En mantenimiento' WHERE idLandingStation = ?";
        String sqlOperativa = "UPDATE landingstation SET estado = 'Operativa' WHERE idLandingStation = ? AND estado = 'En mantenimiento'";

        try (Connection conn = this.getConnection();
             PreparedStatement pstmtContar = conn.prepareStatement(sqlContar)) {

            pstmtContar.setInt(1, idLandingStation);
            int activos = 0;
            try (ResultSet rs = pstmtContar.executeQuery()) {
                if (rs.next()) {
                    activos = rs.getInt(1);
                }
            }

            String sql = activos > 0 ? sqlMantenimiento : sqlOperativa;
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, idLandingStation);
                pstmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}