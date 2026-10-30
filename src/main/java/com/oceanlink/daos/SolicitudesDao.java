package com.oceanlink.daos;

import com.oceanlink.beans.Solicitudes;

import java.sql.*;
import java.util.ArrayList;

public class SolicitudesDao extends DaoBase {

    // Listar solicitudes
    public ArrayList<Solicitudes> listarSolicitudes() {
        ArrayList<Solicitudes> lista = new ArrayList<>();
        String sql = "SELECT * FROM solicitudcapacidad WHERE estado != 'Activo' ORDER BY idSolicitudCapacidad ASC";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Solicitudes s = mapearSolicitud(rs);
                lista.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Obtener una solicitud para editar por ID
    public Solicitudes obtenerSolicitud(int idSolicitudCapacidad) {
        Solicitudes s = null;
        String sql = "SELECT * FROM solicitudcapacidad WHERE idSolicitudCapacidad = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idSolicitudCapacidad);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    s = mapearSolicitud(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return s;
    }

    // Crear nueva solicitud
    public void crearSolicitud(double capacidad, String origen, String destino, String estado,
                               String observaciones, int duracionMeses, int idCliente) {
        String sql = "INSERT INTO solicitudcapacidad (capacidad, origen, destino, estado, "
                + "observaciones, fechaRegistroSolicitud, duracionMeses, idSegmento, idCliente) "
                + "VALUES (?, ?, ?, ?, ?, NOW(), ?, NULL, ?)";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setDouble(1, capacidad);
            pstmt.setString(2, origen);
            pstmt.setString(3, destino);
            pstmt.setString(4, estado);
            pstmt.setString(5, observaciones);
            pstmt.setInt(6, duracionMeses);
            pstmt.setInt(7, idCliente);

            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Actualizar solicitud
    public void actualizarSolicitud(int idSolicitudCapacidad, double capacidad, String origen,
                                    String destino, String estado, String observaciones,
                                    int duracionMeses, Integer idSegmento, int idCliente) {
        String sql = "UPDATE solicitudcapacidad SET capacidad = ?, origen = ?, destino = ?, "
                + "estado = ?, observaciones = ?, duracionMeses = ?, idSegmento = ?, idCliente = ? "
                + "WHERE idSolicitudCapacidad = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setDouble(1, capacidad);
            pstmt.setString(2, origen);
            pstmt.setString(3, destino);
            pstmt.setString(4, estado);
            pstmt.setString(5, observaciones);
            pstmt.setInt(6, duracionMeses);

            if (idSegmento == null || idSegmento == 0) {
                pstmt.setNull(7, Types.INTEGER);
            } else {
                pstmt.setInt(7, idSegmento);
            }

            pstmt.setInt(8, idCliente);
            pstmt.setInt(9, idSolicitudCapacidad);

            pstmt.executeUpdate();

            // Registrar servicio y actualizar capacidades del segmento al activar
            if ("Activo".equalsIgnoreCase(estado)) {
                String sqlServicio = "INSERT INTO servicio (identificador, capacidad, estado, fechaCaducidad, idSegmento, idSolicitudCapacidad) "
                        + "VALUES (CONCAT('SRV-', ?), ?, 'Activo', DATE_ADD(CURDATE(), INTERVAL ? MONTH), ?, ?)";
                try (PreparedStatement pstmtServ = conn.prepareStatement(sqlServicio)) {
                    pstmtServ.setInt(1, idSolicitudCapacidad);
                    pstmtServ.setDouble(2, capacidad);
                    pstmtServ.setInt(3, duracionMeses);
                    if (idSegmento == null || idSegmento == 0) {
                        pstmtServ.setNull(4, Types.INTEGER);
                    } else {
                        pstmtServ.setInt(4, idSegmento);
                    }
                    pstmtServ.setInt(5, idSolicitudCapacidad);
                    pstmtServ.executeUpdate();
                }

                // Traspasar capacidad reservada a capacidad usada en el segmento
                if (idSegmento != null && idSegmento > 0) {
                    String sqlSeg = "UPDATE segmento SET capacidadReservada = GREATEST(0, capacidadReservada - ?), "
                            + "capacidadUsada = capacidadUsada + ? WHERE idSegmento = ?";
                    try (PreparedStatement pstmtSeg = conn.prepareStatement(sqlSeg)) {
                        pstmtSeg.setDouble(1, capacidad);
                        pstmtSeg.setDouble(2, capacidad);
                        pstmtSeg.setInt(3, idSegmento);
                        pstmtSeg.executeUpdate();
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Eliminar solicitud
    public void borrarSolicitud(int idSolicitudCapacidad) {
        String sql = "DELETE FROM solicitudcapacidad WHERE idSolicitudCapacidad = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idSolicitudCapacidad);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Mapear resultado SQL a bean
    private Solicitudes mapearSolicitud(ResultSet rs) throws SQLException {
        Solicitudes s = new Solicitudes();
        s.setIdSolicitudCapacidad(rs.getInt("idSolicitudCapacidad"));
        s.setCapacidad(rs.getDouble("capacidad"));
        s.setOrigen(rs.getString("origen"));
        s.setDestino(rs.getString("destino"));
        s.setEstado(rs.getString("estado"));
        s.setObservaciones(rs.getString("observaciones"));
        s.setFechaRegistroSolicitud(rs.getTimestamp("fechaRegistroSolicitud"));
        s.setDuracionMeses(rs.getInt("duracionMeses"));

        int idSeg = rs.getInt("idSegmento");
        if (rs.wasNull()) {
            s.setIdSegmento(null);
        } else {
            s.setIdSegmento(idSeg);
        }

        s.setIdCliente(rs.getInt("idCliente"));
        return s;
    }
}