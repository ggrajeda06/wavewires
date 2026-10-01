package com.oceanlink.daos;

import com.oceanlink.beans.SolicitudCapacidad;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class SolicitudCapacidadDao extends DaoBase {

    // Listar todas las solicitudes para el Capacity Planner
    public ArrayList<SolicitudCapacidad> listarSolicitudes() {
        ArrayList<SolicitudCapacidad> lista = new ArrayList<>();
        String sql = "SELECT * FROM solicitudcapacidad";

        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                SolicitudCapacidad s = new SolicitudCapacidad();
                s.setIdSolicitudCapacidad(rs.getInt("idSolicitudCapacidad"));
                s.setCapacidad(rs.getBigDecimal("capacidad"));
                s.setOrigen(rs.getString("origen"));
                s.setDestino(rs.getString("destino"));
                s.setEstado(rs.getString("estado"));
                s.setObservaciones(rs.getString("observaciones"));
                s.setFechaRegistroSolicitud(rs.getTimestamp("fechaRegistroSolicitud"));
                s.setDuracionMeses(rs.getInt("duracionMeses"));
                s.setIdSegmentos(rs.getInt("idSegmentos"));
                s.setIdCliente(rs.getInt("idCliente"));
                lista.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Actualizar estado de una solicitud (Aprobada / Rechazada)
    public void actualizarEstado(int idSolicitud, String nuevoEstado) {
        String sql = "UPDATE solicitudcapacidad SET estado = ? WHERE idSolicitudCapacidad = ?";

        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, nuevoEstado);
            pstmt.setInt(2, idSolicitud);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}