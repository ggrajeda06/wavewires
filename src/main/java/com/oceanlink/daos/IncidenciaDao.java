package com.oceanlink.daos;

import com.oceanlink.beans.Incidencia;
import com.oceanlink.beans.ServicioAfectado;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class IncidenciaDao extends DaoBase {

    // soloActivas = true: sin las cerradas (incidencias activas); false: todas (historial)
    public ArrayList<Incidencia> listarIncidencias(boolean soloActivas) {
        ArrayList<Incidencia> lista = new ArrayList<>();
        String sql = "SELECT * FROM incidencia ORDER BY fechaRegistro DESC";
        if (soloActivas) {
            sql = "SELECT * FROM incidencia WHERE estado <> 'Cerrada' ORDER BY fechaRegistro DESC";
        }

        try (Connection conn = this.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Incidencia i = mapearIncidencia(rs);
                i.setIdsSegmentos(listarIds(conn, "SELECT idSegmento FROM incidencia_has_segmento WHERE idIncidencia = ?", i.getIdIncidencia()));
                i.setIdsServicios(listarIds(conn, "SELECT idServicio FROM incidencia_has_servicio WHERE idIncidencia = ?", i.getIdIncidencia()));
                lista.add(i);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // incidencias que todavia pueden recibir un mantenimiento correctivo
    public ArrayList<Incidencia> listarIncidenciasAbiertas() {
        ArrayList<Incidencia> lista = new ArrayList<>();
        String sql = "SELECT * FROM incidencia WHERE estado NOT IN ('Servicio restaurado', 'Cerrada') ORDER BY fechaRegistro DESC";

        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Incidencia i = mapearIncidencia(rs);
                i.setIdsSegmentos(listarIds(conn, "SELECT idSegmento FROM incidencia_has_segmento WHERE idIncidencia = ?", i.getIdIncidencia()));
                lista.add(i);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Incidencia obtenerIncidencia(int idIncidencia) {
        Incidencia i = null;
        String sql = "SELECT * FROM incidencia WHERE idIncidencia = ?";

        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idIncidencia);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    i = mapearIncidencia(rs);
                    i.setIdsSegmentos(listarIds(conn, "SELECT idSegmento FROM incidencia_has_segmento WHERE idIncidencia = ?", idIncidencia));
                    i.setIdsServicios(listarIds(conn, "SELECT idServicio FROM incidencia_has_servicio WHERE idIncidencia = ?", idIncidencia));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return i;
    }

    // la primera observacion se guarda despues con agregarObservacion
    public int crearIncidencia(Incidencia incidencia) {
        String sqlInc = "INSERT INTO incidencia (severidad, estado) VALUES (?, 'Detectada')";
        String sqlId = "UPDATE incidencia SET identificador = CONCAT('INC-', YEAR(fechaRegistro), '-', LPAD(idIncidencia, 3, '0')) WHERE idIncidencia = ?";
        String sqlSeg = "INSERT INTO incidencia_has_segmento (idIncidencia, idSegmento) VALUES (?, ?)";
        String sqlServ = "INSERT INTO incidencia_has_servicio (idIncidencia, idServicio) VALUES (?, ?)";
        int idIncidencia = 0;

        try (Connection conn = this.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement p1 = conn.prepareStatement(sqlInc, Statement.RETURN_GENERATED_KEYS);
                 PreparedStatement p2 = conn.prepareStatement(sqlId);
                 PreparedStatement p3 = conn.prepareStatement(sqlSeg);
                 PreparedStatement p4 = conn.prepareStatement(sqlServ)) {

                p1.setString(1, incidencia.getSeveridad());
                p1.executeUpdate();

                try (ResultSet rs = p1.getGeneratedKeys()) {
                    rs.next();
                    idIncidencia = rs.getInt(1);
                }

                p2.setInt(1, idIncidencia);
                p2.executeUpdate();

                for (Integer idSegmento : incidencia.getIdsSegmentos()) {
                    p3.setInt(1, idIncidencia);
                    p3.setInt(2, idSegmento);
                    p3.executeUpdate();
                }

                for (Integer idServicio : incidencia.getIdsServicios()) {
                    p4.setInt(1, idIncidencia);
                    p4.setInt(2, idServicio);
                    p4.executeUpdate();
                }

                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                idIncidencia = 0;
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return idIncidencia;
    }

    public void actualizarSeveridad(int idIncidencia, String severidad) {
        String sql = "UPDATE incidencia SET severidad = ? WHERE idIncidencia = ?";

        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, severidad);
            pstmt.setInt(2, idIncidencia);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // cambia los segmentos y vuelve a guardar los servicios afectados (solo antes de la reparacion)
    public void cambiarSegmentos(int idIncidencia, List<Integer> idsSegmentos, List<Integer> idsServicios) {
        String sqlDelSeg = "DELETE FROM incidencia_has_segmento WHERE idIncidencia = ?";
        String sqlDelServ = "DELETE FROM incidencia_has_servicio WHERE idIncidencia = ?";
        String sqlSeg = "INSERT INTO incidencia_has_segmento (idIncidencia, idSegmento) VALUES (?, ?)";
        String sqlServ = "INSERT INTO incidencia_has_servicio (idIncidencia, idServicio) VALUES (?, ?)";

        try (Connection conn = this.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement p1 = conn.prepareStatement(sqlDelSeg);
                 PreparedStatement p2 = conn.prepareStatement(sqlDelServ);
                 PreparedStatement p3 = conn.prepareStatement(sqlSeg);
                 PreparedStatement p4 = conn.prepareStatement(sqlServ)) {

                p1.setInt(1, idIncidencia);
                p1.executeUpdate();
                p2.setInt(1, idIncidencia);
                p2.executeUpdate();

                for (Integer idSegmento : idsSegmentos) {
                    p3.setInt(1, idIncidencia);
                    p3.setInt(2, idSegmento);
                    p3.executeUpdate();
                }

                for (Integer idServicio : idsServicios) {
                    p4.setInt(1, idIncidencia);
                    p4.setInt(2, idServicio);
                    p4.executeUpdate();
                }

                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // agrega una observacion nueva al final, con la fecha, sin borrar las anteriores
    public void agregarObservacion(int idIncidencia, String observacion) {
        String sql = "UPDATE incidencia SET observaciones = CONCAT_WS('\\n', observaciones, CONCAT('[', DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i'), '] ', ?)) "
                + "WHERE idIncidencia = ?";

        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, observacion);
            pstmt.setInt(2, idIncidencia);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void cambiarEstado(int idIncidencia, String estado) {
        String sql = "UPDATE incidencia SET estado = ? WHERE idIncidencia = ?";
        if (estado.equals("Cerrada")) {
            sql = "UPDATE incidencia SET estado = ?, fechaCierre = NOW() WHERE idIncidencia = ?";
        }

        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, estado);
            pstmt.setInt(2, idIncidencia);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // marca como restaurados los servicios que aun no tenian fecha de restauracion
    public void restaurarServicios(int idIncidencia) {
        String sql = "UPDATE incidencia_has_servicio SET fechaRestauracion = NOW() "
                + "WHERE idIncidencia = ? AND fechaRestauracion IS NULL";

        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idIncidencia);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void eliminarIncidencia(int idIncidencia) {
        String sqlDelSeg = "DELETE FROM incidencia_has_segmento WHERE idIncidencia = ?";
        String sqlDelServ = "DELETE FROM incidencia_has_servicio WHERE idIncidencia = ?";
        String sqlDelInc = "DELETE FROM incidencia WHERE idIncidencia = ?";

        try (Connection conn = this.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement p1 = conn.prepareStatement(sqlDelSeg);
                 PreparedStatement p2 = conn.prepareStatement(sqlDelServ);
                 PreparedStatement p3 = conn.prepareStatement(sqlDelInc)) {

                p1.setInt(1, idIncidencia);
                p1.executeUpdate();
                p2.setInt(1, idIncidencia);
                p2.executeUpdate();
                p3.setInt(1, idIncidencia);
                p3.executeUpdate();

                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // servicios afectados por una incidencia, con su cliente y su fecha de restauracion
    public ArrayList<ServicioAfectado> listarServiciosAfectados(int idIncidencia) {
        ArrayList<ServicioAfectado> lista = new ArrayList<>();
        String sql = "SELECT ihs.idIncidencia, i.identificador AS identificadorIncidencia, sv.idServicio, "
                + "sv.identificador AS identificadorServicio, sv.capacidad, sv.idSegmento, c.razonSocial, ihs.fechaRestauracion "
                + "FROM incidencia_has_servicio ihs "
                + "JOIN incidencia i ON i.idIncidencia = ihs.idIncidencia "
                + "JOIN servicio sv ON sv.idServicio = ihs.idServicio "
                + "JOIN solicitudcapacidad sc ON sc.idSolicitudCapacidad = sv.idSolicitudCapacidad "
                + "JOIN cliente c ON c.idCliente = sc.idCliente "
                + "WHERE ihs.idIncidencia = ? "
                + "ORDER BY sv.idServicio";

        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idIncidencia);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearAfectado(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // todos los servicios que ya fueron restaurados
    public ArrayList<ServicioAfectado> listarRestauraciones() {
        ArrayList<ServicioAfectado> lista = new ArrayList<>();
        String sql = "SELECT ihs.idIncidencia, i.identificador AS identificadorIncidencia, sv.idServicio, "
                + "sv.identificador AS identificadorServicio, sv.capacidad, sv.idSegmento, c.razonSocial, ihs.fechaRestauracion "
                + "FROM incidencia_has_servicio ihs "
                + "JOIN incidencia i ON i.idIncidencia = ihs.idIncidencia "
                + "JOIN servicio sv ON sv.idServicio = ihs.idServicio "
                + "JOIN solicitudcapacidad sc ON sc.idSolicitudCapacidad = sv.idSolicitudCapacidad "
                + "JOIN cliente c ON c.idCliente = sc.idCliente "
                + "WHERE ihs.fechaRestauracion IS NOT NULL "
                + "ORDER BY ihs.fechaRestauracion DESC";

        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                lista.add(mapearAfectado(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    private ServicioAfectado mapearAfectado(ResultSet rs) throws SQLException {
        ServicioAfectado sa = new ServicioAfectado();
        sa.setIdIncidencia(rs.getInt("idIncidencia"));
        sa.setIdentificadorIncidencia(rs.getString("identificadorIncidencia"));
        sa.setIdServicio(rs.getInt("idServicio"));
        sa.setIdentificadorServicio(rs.getString("identificadorServicio"));
        sa.setCapacidad(rs.getBigDecimal("capacidad"));
        sa.setIdSegmento(rs.getInt("idSegmento"));
        sa.setRazonSocial(rs.getString("razonSocial"));
        sa.setFechaRestauracion(rs.getDate("fechaRestauracion"));
        return sa;
    }

    private Incidencia mapearIncidencia(ResultSet rs) throws SQLException {
        Incidencia i = new Incidencia();
        i.setIdIncidencia(rs.getInt("idIncidencia"));
        i.setIdentificador(rs.getString("identificador"));
        i.setSeveridad(rs.getString("severidad"));
        i.setEstado(rs.getString("estado"));
        i.setObservaciones(rs.getString("observaciones"));
        i.setFechaRegistro(rs.getDate("fechaRegistro"));
        i.setFechaCierre(rs.getDate("fechaCierre"));
        return i;
    }

    private ArrayList<Integer> listarIds(Connection conn, String sql, int id) throws SQLException {
        ArrayList<Integer> ids = new ArrayList<>();
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt(1));
                }
            }
        }
        return ids;
    }
}