package com.oceanlink.daos;

import com.oceanlink.beans.LandingStation;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class LandingStationDao extends DaoBase {

    // Listar Landings
    public ArrayList<LandingStation> listarLandingStations() {
        ArrayList<LandingStation> lista = new ArrayList<>();
        String sql = "SELECT * FROM landingstations";

        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                LandingStation ls = new LandingStation();
                ls.setIdLandingStations(rs.getInt("idLandingStations"));
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
}