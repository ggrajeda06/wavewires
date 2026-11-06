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
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ls;
    }

    // true si otra landing ya usa ese nombre (idExcluir = la que se esta editando, 0 al crear)
    public boolean existeNombre(String nombre, int idExcluir) {

        boolean existe = false;
        String sql = "SELECT COUNT(*) FROM landingstation WHERE nombre = ? AND idLandingStation <> ?";
        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, nombre);
            pstmt.setInt(2, idExcluir);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    existe = rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return existe;
    }

    public void crearLandingStation(String nombre, String pais, String ciudad) {

        String sql = "INSERT INTO landingstation (nombre, pais, ciudad) VALUES (?, ?, ?)";
        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, nombre);
            pstmt.setString(2, pais);
            pstmt.setString(3, ciudad);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void actualizarLandingStation(int idLandingStation, String nombre, String pais, String ciudad) {

        String sql = "UPDATE landingstation SET nombre = ?, pais = ?, ciudad = ? WHERE idLandingStation = ?";
        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, nombre);
            pstmt.setString(2, pais);
            pstmt.setString(3, ciudad);
            pstmt.setInt(4, idLandingStation);
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
}