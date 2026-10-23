package com.oceanlink.daos;

import com.oceanlink.beans.Solicitudes;

import java.sql.*;
import java.util.ArrayList;

public class SolicitudesDao extends DaoBase {

    // Listar
    public ArrayList<Solicitudes> listarSolicitudes() {
        ArrayList<Solicitudes> lista = new ArrayList<>();
        String sql = "SELECT * FROM solicitudcapacidad ORDER BY idSolicitudCapacidad ASC";

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

    // Buscador filtrado por cliente, estado y numero de solciitud
    public ArrayList<Solicitudes> buscarSolicitudes(String texto) {
        ArrayList<Solicitudes> lista = new ArrayList<>();
        String sql = "SELECT sc.* FROM solicitudcapacidad sc "
                + "LEFT JOIN cliente c ON sc.idCliente = c.idCliente "
                + "WHERE sc.idSolicitudCapacidad LIKE ? "
                + "   OR CONCAT('Solicitud ', sc.idSolicitudCapacidad) LIKE ? "
                + "   OR c.razonSocial LIKE ? "
                + "   OR sc.estado LIKE ? "
                + "ORDER BY sc.idSolicitudCapacidad ASC";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String comodin = "%" + texto.trim() + "%";
            pstmt.setString(1, comodin);
            pstmt.setString(2, comodin);
            pstmt.setString(3, comodin);
            pstmt.setString(4, comodin);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Solicitudes s = mapearSolicitud(rs);
                    lista.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Obtener una solicitud para editar (con su ID)
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

    // Metodo privado para mapear y no repetir codigo
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