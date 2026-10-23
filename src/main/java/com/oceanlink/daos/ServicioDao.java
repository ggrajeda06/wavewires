package com.oceanlink.daos;

import com.oceanlink.beans.Servicio;

import java.sql.*;
import java.util.ArrayList;

public class ServicioDao extends DaoBase {

    public ArrayList<Servicio> listarServicios() {

        ArrayList<Servicio> lista = new ArrayList<>();
        String sql = "SELECT sv.*, c.razonSocial "
                + "FROM servicio sv "
                + "JOIN solicitudcapacidad sc ON sc.idSolicitudCapacidad = sv.idSolicitudCapacidad "
                + "JOIN cliente c ON c.idCliente = sc.idCliente "
                + "ORDER BY sv.idServicio";
        try (Connection conn = this.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Servicio sv = new Servicio();
                sv.setIdServicio(rs.getInt("idServicio"));
                sv.setIdentificador(rs.getString("identificador"));
                sv.setCapacidad(rs.getBigDecimal("capacidad"));
                sv.setEstado(rs.getString("estado"));
                sv.setFechaCaducidad(rs.getDate("fechaCaducidad"));
                sv.setIdSegmento(rs.getInt("idSegmento"));
                sv.setIdSolicitudCapacidad(rs.getInt("idSolicitudCapacidad"));
                sv.setRazonSocial(rs.getString("razonSocial"));
                lista.add(sv);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    public ArrayList<Servicio> listarServiciosPorLanding(int idLandingStation) {

        ArrayList<Servicio> lista = new ArrayList<>();
        String sql = "SELECT sv.*, c.razonSocial "
                + "FROM servicio sv "
                + "JOIN segmento s ON s.idSegmento = sv.idSegmento "
                + "JOIN solicitudcapacidad sc ON sc.idSolicitudCapacidad = sv.idSolicitudCapacidad "
                + "JOIN cliente c ON c.idCliente = sc.idCliente "
                + "WHERE (s.idOrigen = ? OR s.idDestino = ?) "
                + "AND sv.estado = 'Activo' "
                + "AND sv.fechaCaducidad >= CURDATE() "
                + "ORDER BY sv.idServicio";
        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idLandingStation);
            pstmt.setInt(2, idLandingStation);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Servicio sv = new Servicio();
                    sv.setIdServicio(rs.getInt("idServicio"));
                    sv.setIdentificador(rs.getString("identificador"));
                    sv.setCapacidad(rs.getBigDecimal("capacidad"));
                    sv.setEstado(rs.getString("estado"));
                    sv.setFechaCaducidad(rs.getDate("fechaCaducidad"));
                    sv.setIdSegmento(rs.getInt("idSegmento"));
                    sv.setIdSolicitudCapacidad(rs.getInt("idSolicitudCapacidad"));
                    sv.setRazonSocial(rs.getString("razonSocial"));
                    lista.add(sv);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }
}