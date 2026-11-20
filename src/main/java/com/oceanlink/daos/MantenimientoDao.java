package com.oceanlink.daos;

import com.oceanlink.beans.Mantenimiento;

import java.sql.*;
import java.util.ArrayList;

public class MantenimientoDao extends DaoBase {

    public ArrayList<Mantenimiento> listarMantenimientos() {

        ArrayList<Mantenimiento> lista = new ArrayList<>();
        String sql = "SELECT * FROM mantenimiento ORDER BY fechaRegistrada DESC";
        try (Connection conn = this.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                lista.add(mapearMantenimiento(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    public Mantenimiento obtenerMantenimiento(int idMantenimiento) {

        Mantenimiento m = null;
        String sql = "SELECT * FROM mantenimiento WHERE idMantenimiento = ?";
        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idMantenimiento);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    m = mapearMantenimiento(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return m;
    }

    // correctivos ligados a una incidencia
    public ArrayList<Mantenimiento> listarPorIncidencia(int idIncidencia) {

        ArrayList<Mantenimiento> lista = new ArrayList<>();
        String sql = "SELECT * FROM mantenimiento WHERE idIncidencia = ? ORDER BY fechaRegistrada";
        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idIncidencia);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearMantenimiento(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    // cuantos correctivos de la incidencia aun no estan finalizados
    public int contarPendientesDeIncidencia(int idIncidencia) {

        int total = 0;
        String sql = "SELECT COUNT(*) FROM mantenimiento WHERE idIncidencia = ? AND estado <> 'Finalizado'";
        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idIncidencia);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return total;
    }

    // todo mantenimiento nuevo empieza en Pendiente; los ids en 0 se guardan como NULL
    public int crearMantenimiento(Mantenimiento m) throws SQLException {

        String sql = """
        INSERT INTO mantenimiento
        (nombre, descripcion, tipo, estado, fechaRegistrada,
         duracionHoras, idLandingStation, idSegmento, idIncidencia)
        VALUES (?, ?, ?, 'Pendiente', ?, ?, ?, ?, ?)
        """;

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(
                    sql, Statement.RETURN_GENERATED_KEYS)) {

                ps.setString(1, m.getNombre());
                ps.setString(2, m.getDescripcion());
                ps.setString(3, m.getTipo());
                ps.setDate(4, m.getFechaRegistrada());
                ps.setInt(5, m.getDuracionHoras());

                if (m.getIdLandingStation() == 0) {
                    ps.setNull(6, Types.INTEGER);
                } else {
                    ps.setInt(6, m.getIdLandingStation());
                }

                if (m.getIdSegmento() == 0) {
                    ps.setNull(7, Types.INTEGER);
                } else {
                    ps.setInt(7, m.getIdSegmento());
                }

                if (m.getIdIncidencia() == 0) {
                    ps.setNull(8, Types.INTEGER);
                } else {
                    ps.setInt(8, m.getIdIncidencia());
                }

                if (ps.executeUpdate() != 1) {
                    throw new SQLException("No se pudo registrar el mantenimiento.");
                }

                int idGenerado;

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (!rs.next()) {
                        throw new SQLException("No se obtuvo el ID del mantenimiento.");
                    }

                    idGenerado = rs.getInt(1);
                }

                conn.commit();
                return idGenerado;

            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    // el servlet decide que campos se pueden cambiar segun el estado; los ids en 0 se guardan como NULL
    public boolean actualizarMantenimiento(Mantenimiento m, String estadoAnterior)
            throws SQLException {

        String sql = "UPDATE mantenimiento SET nombre = ?, descripcion = ?, tipo = ?, fechaRegistrada = ?, duracionHoras = ?, "
                + "estado = ?, actividadesRealizadas = ?, idLandingStation = ?, idSegmento = ?, idIncidencia = ? "
                + "WHERE idMantenimiento = ? AND estado = ?";
        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, m.getNombre());
            pstmt.setString(2, m.getDescripcion());
            pstmt.setString(3, m.getTipo());
            pstmt.setDate(4, m.getFechaRegistrada());
            pstmt.setInt(5, m.getDuracionHoras());
            pstmt.setString(6, m.getEstado());
            pstmt.setString(7, m.getActividadesRealizadas());

            if (m.getIdLandingStation() == 0) {
                pstmt.setNull(8, Types.INTEGER);
            } else {
                pstmt.setInt(8, m.getIdLandingStation());
            }

            if (m.getIdSegmento() == 0) {
                pstmt.setNull(9, Types.INTEGER);
            } else {
                pstmt.setInt(9, m.getIdSegmento());
            }

            if (m.getIdIncidencia() == 0) {
                pstmt.setNull(10, Types.INTEGER);
            } else {
                pstmt.setInt(10, m.getIdIncidencia());
            }

            pstmt.setInt(11, m.getIdMantenimiento());
            pstmt.setString(12, estadoAnterior);
            return pstmt.executeUpdate() == 1;
        }
    }


    public void borrarMantenimiento(int idMantenimiento) {

        String sql = "DELETE FROM mantenimiento WHERE idMantenimiento = ?";
        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idMantenimiento);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Mantenimiento mapearMantenimiento(ResultSet rs) throws SQLException {
        Mantenimiento m = new Mantenimiento();
        m.setIdMantenimiento(rs.getInt("idMantenimiento"));
        m.setNombre(rs.getString("nombre"));
        m.setDescripcion(rs.getString("descripcion"));
        m.setTipo(rs.getString("tipo"));
        m.setEstado(rs.getString("estado"));
        m.setFechaRegistrada(rs.getDate("fechaRegistrada"));
        m.setDuracionHoras(rs.getInt("duracionHoras"));
        m.setActividadesRealizadas(rs.getString("actividadesRealizadas"));
        m.setIdLandingStation(rs.getInt("idLandingStation"));
        m.setIdSegmento(rs.getInt("idSegmento"));
        m.setIdIncidencia(rs.getInt("idIncidencia"));
        return m;
    }

    public boolean finalizarCorrectivo(Mantenimiento m) throws SQLException {
        int idIncidencia = m.getIdIncidencia();

        String bloquearIncidencia = """
        SELECT idIncidencia
        FROM incidencia
        WHERE idIncidencia = ?
        FOR UPDATE
        """;

        String finalizarCorrectivo = """
        UPDATE mantenimiento
        SET nombre = ?, descripcion = ?, actividadesRealizadas = ?,
            estado = 'Finalizado'
        WHERE idMantenimiento = ?
          AND idIncidencia = ?
          AND tipo = 'Correctivo'
          AND estado = 'Activo'
        """;

        String restaurarIncidencia = """
        UPDATE incidencia
        SET estado = 'Servicio restaurado'
        WHERE idIncidencia = ?
          AND estado NOT IN ('Servicio restaurado', 'Cerrada')
         AND NOT EXISTS (
              SELECT 1 FROM mantenimiento
              WHERE idIncidencia = ? AND estado <> 'Finalizado'
          )
          AND NOT EXISTS (
              SELECT 1 FROM incidencia_has_segmento ihs
              JOIN segmento sg ON sg.idSegmento = ihs.idSegmento
              WHERE ihs.idIncidencia = ?
                AND NOT EXISTS (
                    SELECT 1 FROM mantenimiento mt
                    WHERE mt.idIncidencia = ihs.idIncidencia
                      AND mt.tipo = 'Correctivo'
                      AND mt.estado = 'Finalizado'
                      AND (mt.idSegmento = ihs.idSegmento
                           OR mt.idLandingStation IN (sg.idOrigen, sg.idDestino))
                )
          )
        """;

        String restaurarServicios = """
        UPDATE incidencia_has_servicio h
        JOIN servicio s ON s.idServicio = h.idServicio
        LEFT JOIN (
            incidencia_has_servicio otro
            JOIN incidencia i ON i.idIncidencia = otro.idIncidencia
              AND i.estado NOT IN ('Servicio restaurado', 'Cerrada')
        ) ON otro.idServicio = h.idServicio
         AND otro.idIncidencia <> h.idIncidencia
        SET h.fechaRestauracion = COALESCE(h.fechaRestauracion, NOW()),
            s.estado = 'Funcionando'
        WHERE h.idIncidencia = ?
          AND s.estado = 'Caído'
          AND otro.idIncidencia IS NULL
        """;

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);

            try {
                // Procesa en orden los cierres de una misma incidencia.
                try (PreparedStatement ps = conn.prepareStatement(bloquearIncidencia)) {
                    ps.setInt(1, idIncidencia);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            throw new SQLException("La incidencia ya no existe.");
                        }
                    }
                }

                try (PreparedStatement ps = conn.prepareStatement(finalizarCorrectivo)) {
                    ps.setString(1, m.getNombre());
                    ps.setString(2, m.getDescripcion());
                    ps.setString(3, m.getActividadesRealizadas());
                    ps.setInt(4, m.getIdMantenimiento());
                    ps.setInt(5, idIncidencia);

                    if (ps.executeUpdate() != 1) {
                        throw new SQLException("El correctivo ya no está activo.");
                    }
                }

                boolean restaurada;
                try (PreparedStatement ps = conn.prepareStatement(restaurarIncidencia)) {
                    ps.setInt(1, idIncidencia);
                    ps.setInt(2, idIncidencia);
                    ps.setInt(3, idIncidencia);
                    restaurada = ps.executeUpdate() == 1;
                }

                if (restaurada) {
                    try (PreparedStatement ps = conn.prepareStatement(restaurarServicios)) {
                        ps.setInt(1, idIncidencia);
                        ps.executeUpdate();
                    }
                }

                conn.commit();
                return restaurada;

            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }
}