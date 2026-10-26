package com.oceanlink.daos;

import com.oceanlink.beans.Servicio;

import java.sql.*;
import java.util.ArrayList;

public class ServicioDao extends DaoBase {

    // Listar servicios
    public ArrayList<Servicio> listarServicios() {
        ArrayList<Servicio> lista = new ArrayList<>();
        String sql = "SELECT sv.*, sc.idCliente, c.razonSocial "
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
                sv.setIdCliente(rs.getInt("idCliente"));
                sv.setRazonSocial(rs.getString("razonSocial"));
                lista.add(sv);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    // Buscar servicio
    public ArrayList<Servicio> buscarServicios(String texto) {
        ArrayList<Servicio> lista = new ArrayList<>();
        String sql = "SELECT sv.*, sc.idCliente, c.razonSocial "
                + "FROM servicio sv "
                + "JOIN solicitudcapacidad sc ON sc.idSolicitudCapacidad = sv.idSolicitudCapacidad "
                + "JOIN cliente c ON c.idCliente = sc.idCliente "
                + "WHERE sv.identificador LIKE ? "
                + "   OR CONCAT('Servicio ', sv.idServicio) LIKE ? "
                + "   OR c.razonSocial LIKE ? "
                + "   OR CONCAT('Segmento ', sv.idSegmento) LIKE ? "
                + "ORDER BY sv.idServicio";

        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String comodin = "%" + texto.trim() + "%";
            pstmt.setString(1, comodin);
            pstmt.setString(2, comodin);
            pstmt.setString(3, comodin);
            pstmt.setString(4, comodin);

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
                    sv.setIdCliente(rs.getInt("idCliente"));
                    sv.setRazonSocial(rs.getString("razonSocial"));
                    lista.add(sv);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    // Listar servicios por landing
    public ArrayList<Servicio> listarServiciosPorLanding(int idLandingStation) {
        ArrayList<Servicio> lista = new ArrayList<>();
        String sql = "SELECT sv.*, sc.idCliente, c.razonSocial "
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
                    sv.setIdCliente(rs.getInt("idCliente"));
                    sv.setRazonSocial(rs.getString("razonSocial"));
                    lista.add(sv);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    // Eliminar servicio
    public void eliminarServicio(int idServicio) {
        String sqlSelect = "SELECT capacidad, idSegmento, idSolicitudCapacidad FROM servicio WHERE idServicio = ?";
        String sqlDeleteServicio = "DELETE FROM servicio WHERE idServicio = ?";
        String sqlDeleteSolicitud = "DELETE FROM solicitudcapacidad WHERE idSolicitudCapacidad = ?";
        String sqlUpdateSegmento = "UPDATE segmento SET capacidadUsada = GREATEST(0, capacidadUsada - ?) WHERE idSegmento = ?";

        try (Connection conn = this.getConnection()) {
            double capacidad = 0;
            int idSegmento = 0;
            int idSolicitud = 0;

            try (PreparedStatement pstmtSel = conn.prepareStatement(sqlSelect)) {
                pstmtSel.setInt(1, idServicio);
                try (ResultSet rs = pstmtSel.executeQuery()) {
                    if (rs.next()) {
                        capacidad = rs.getDouble("capacidad");
                        idSegmento = rs.getInt("idSegmento");
                        idSolicitud = rs.getInt("idSolicitudCapacidad");
                    }
                }
            }

            try (PreparedStatement pstmtDelServ = conn.prepareStatement(sqlDeleteServicio)) {
                pstmtDelServ.setInt(1, idServicio);
                pstmtDelServ.executeUpdate();
            }

            if (idSolicitud > 0) {
                try (PreparedStatement pstmtDelSol = conn.prepareStatement(sqlDeleteSolicitud)) {
                    pstmtDelSol.setInt(1, idSolicitud);
                    pstmtDelSol.executeUpdate();
                }
            }

            if (idSegmento > 0 && capacidad > 0) {
                try (PreparedStatement pstmtUpdSeg = conn.prepareStatement(sqlUpdateSegmento)) {
                    pstmtUpdSeg.setDouble(1, capacidad);
                    pstmtUpdSeg.setInt(2, idSegmento);
                    pstmtUpdSeg.executeUpdate();
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}