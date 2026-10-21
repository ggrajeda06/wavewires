package com.oceanlink.daos;

import com.oceanlink.beans.Segmento;

import java.sql.*;
import java.util.ArrayList;

public class SegmentoDao {

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
}