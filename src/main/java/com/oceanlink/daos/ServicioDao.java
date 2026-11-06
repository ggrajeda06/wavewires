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
                sv.setFechaActivacion(rs.getDate("fechaActivacion"));
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

    // =====================================================================
    // vigente = todavia no caduca (lo usan los reportes del Supervisor)
    // es el mismo criterio que Servicio.isVigente(): solo depende de la fecha de caducidad
    // =====================================================================
    public static boolean esVigente(Servicio sv) {
        return sv.isVigente();
    }

    // servicios en curso (Servicios del Capacity Planner): los que no aparecen en el historial de caducados
    public ArrayList<Servicio> listarServiciosVigentes() {
        ArrayList<Servicio> lista = new ArrayList<>();
        for (Servicio sv : listarServicios()) {
            if (esVigente(sv)) {
                lista.add(sv);
            }
        }
        return lista;
    }

    // servicios vigentes que pasan por alguno de los segmentos de una landing
    public ArrayList<Servicio> listarServiciosPorLanding(int idLandingStation) {
        ArrayList<Servicio> lista = new ArrayList<>();
        String sql = "SELECT sv.*, sc.idCliente, c.razonSocial "
                + "FROM servicio sv "
                + "JOIN segmento s ON s.idSegmento = sv.idSegmento "
                + "JOIN solicitudcapacidad sc ON sc.idSolicitudCapacidad = sv.idSolicitudCapacidad "
                + "JOIN cliente c ON c.idCliente = sc.idCliente "
                + "WHERE (s.idOrigen = ? OR s.idDestino = ?) "
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
    // devuelve false si no se pudo borrar (por ejemplo, porque el servicio esta en una incidencia) y no cambia nada
    public boolean eliminarServicio(int idServicio) {
        String sqlSelect = "SELECT capacidad, idSegmento, idSolicitudCapacidad FROM servicio WHERE idServicio = ?";
        String sqlDeleteServicio = "DELETE FROM servicio WHERE idServicio = ?";
        String sqlDeleteSolicitud = "DELETE FROM solicitudcapacidad WHERE idSolicitudCapacidad = ?";
        String sqlUpdateSegmento = "UPDATE segmento SET capacidadUsada = GREATEST(0, capacidadUsada - ?) WHERE idSegmento = ?";

        try (Connection conn = this.getConnection()) {
            conn.setAutoCommit(false);
            double capacidad = 0;
            int idSegmento = 0;
            int idSolicitud = 0;

            try {

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
                conn.commit();
                return true;

            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // servicios vigentes (todavia no caducan) que usan un segmento, esten Funcionando o Caídos
    public ArrayList<Servicio> listarServiciosPorSegmento(int idSegmento) {
        ArrayList<Servicio> lista = new ArrayList<>();
        String sql = "SELECT sv.*, sc.idCliente, c.razonSocial "
                + "FROM servicio sv "
                + "JOIN solicitudcapacidad sc ON sc.idSolicitudCapacidad = sv.idSolicitudCapacidad "
                + "JOIN cliente c ON c.idCliente = sc.idCliente "
                + "WHERE sv.idSegmento = ? "
                + "AND sv.fechaCaducidad >= CURDATE() "
                + "ORDER BY sv.idServicio";
        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idSegmento);
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

    // servicios vencidos: su fecha de caducidad ya paso (historial de segmentos)
    public ArrayList<Servicio> listarServiciosCaducados() {
        ArrayList<Servicio> lista = new ArrayList<>();
        String sql = "SELECT sv.*, sc.idCliente, c.razonSocial "
                + "FROM servicio sv "
                + "JOIN solicitudcapacidad sc ON sc.idSolicitudCapacidad = sv.idSolicitudCapacidad "
                + "JOIN cliente c ON c.idCliente = sc.idCliente "
                + "WHERE sv.fechaCaducidad < CURDATE() "
                + "ORDER BY sv.fechaCaducidad DESC";
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

    // borrar un servicio vencido desde el historial: hace lo mismo que eliminarServicio
    // (borra el servicio y su solicitud y devuelve la capacidad al segmento)
    public boolean eliminarServicioPermanente(int idServicio) {
        return eliminarServicio(idServicio);
    }
}