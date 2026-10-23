package com.oceanlink.daos;

import com.oceanlink.beans.Incidencia;

import java.sql.*;
import java.util.ArrayList;

public class IncidenciaDao extends DaoBase {

    public ArrayList<Incidencia> listarIncidencias() throws SQLException {
        ArrayList<Incidencia> lista = new ArrayList<>();
        String sqlInc = "SELECT * FROM incidencia ORDER BY fechaRegistro DESC";
        String sqlServ = "SELECT idServicio FROM incidencia_has_servicio WHERE idIncidencia = ?";

        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sqlInc);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Incidencia i = new Incidencia();
                i.setIdIncidencia(rs.getInt("idIncidencia"));
                i.setIdentificador(rs.getString("identificador"));
                i.setSeveridad(rs.getString("severidad"));
                i.setEstado(rs.getString("estado"));
                i.setObservaciones(rs.getString("observaciones"));
                i.setFechaRegistro(rs.getDate("fechaRegistro"));
                i.setIdLandingStation(rs.getInt("idLandingStation"));

                ArrayList<Integer> idsServicios = new ArrayList<>();
                try (PreparedStatement pstmtServ = conn.prepareStatement(sqlServ)) {
                    pstmtServ.setInt(1, i.getIdIncidencia());
                    try (ResultSet rsServ = pstmtServ.executeQuery()) {
                        while (rsServ.next()) {
                            idsServicios.add(rsServ.getInt("idServicio"));
                        }
                    }
                }
                i.setIdsServicios(idsServicios);
                // ---------------------------------------------

                lista.add(i);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Incidencia obtenerIncidencia(int idIncidencia) throws SQLException {
        Incidencia i = null;
        String sqlInc = "SELECT * FROM incidencia WHERE idIncidencia = ?";
        String sqlServ = "SELECT idServicio FROM incidencia_has_servicio WHERE idIncidencia = ?";

        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sqlInc)) {

            pstmt.setInt(1, idIncidencia);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    i = new Incidencia();
                    i.setIdIncidencia(rs.getInt("idIncidencia"));
                    i.setIdentificador(rs.getString("identificador"));
                    i.setSeveridad(rs.getString("severidad"));
                    i.setEstado(rs.getString("estado"));
                    i.setObservaciones(rs.getString("observaciones"));
                    i.setFechaRegistro(rs.getDate("fechaRegistro"));
                    i.setIdLandingStation(rs.getInt("idLandingStation"));

                    // --- CARGAR LOS IDS DE SERVICIOS PARA LA EDICIÓN ---
                    ArrayList<Integer> idsServicios = new ArrayList<>();
                    try (PreparedStatement pstmtServ = conn.prepareStatement(sqlServ)) {
                        pstmtServ.setInt(1, idIncidencia);
                        try (ResultSet rsServ = pstmtServ.executeQuery()) {
                            while (rsServ.next()) {
                                idsServicios.add(rsServ.getInt("idServicio"));
                            }
                        }
                    }
                    i.setIdsServicios(idsServicios);
                    // --------------------------------------------------
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return i;
    }

    // Ahora recibe el objeto Incidencia completo, aprovechando su List<Integer>
    public void crearIncidencia(Incidencia incidencia) throws SQLException {
        String sqlInc = "INSERT INTO incidencia (identificador, severidad, estado, observaciones, idLandingStation) VALUES (?,?,?,?,?)";
        String sqlHas = "INSERT INTO incidencia_has_servicio (idIncidencia, idServicio) VALUES (?,?)";

        try (Connection conn = this.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement p1 = conn.prepareStatement(sqlInc, Statement.RETURN_GENERATED_KEYS);
                 PreparedStatement p2 = conn.prepareStatement(sqlHas)) {

                p1.setString(1, incidencia.getIdentificador());
                p1.setString(2, incidencia.getSeveridad());
                p1.setString(3, incidencia.getEstado());
                p1.setString(4, incidencia.getObservaciones());
                p1.setInt(5, incidencia.getIdLandingStation());
                p1.executeUpdate();

                int idIncidencia;
                try (ResultSet rs = p1.getGeneratedKeys()) {
                    rs.next();
                    idIncidencia = rs.getInt(1);
                }

                // Recorremos la lista de enteros del Bean directamente
                if (incidencia.getIdsServicios() != null) {
                    for (Integer idServicio : incidencia.getIdsServicios()) {
                        p2.setInt(1, idIncidencia);
                        p2.setInt(2, idServicio);
                        p2.addBatch();
                    }
                    p2.executeBatch();
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

    public void editarIncidencia(Incidencia incidencia) throws SQLException {
        String sqlUpdateInc = "UPDATE incidencia SET identificador = ?, severidad = ?, estado = ?, observaciones = ?, idLandingStation = ? WHERE idIncidencia = ?";
        String sqlDeleteHas = "DELETE FROM incidencia_has_servicio WHERE idIncidencia = ?";
        String sqlInsertHas = "INSERT INTO incidencia_has_servicio (idIncidencia, idServicio) VALUES (?, ?)";

        try (Connection conn = this.getConnection()) {
            conn.setAutoCommit(false); // Iniciamos transacción por seguridad

            try {
                // 1. Actualizar los datos principales de la incidencia
                try (PreparedStatement pstmtUpd = conn.prepareStatement(sqlUpdateInc)) {
                    pstmtUpd.setString(1, incidencia.getIdentificador());
                    pstmtUpd.setString(2, incidencia.getSeveridad());
                    pstmtUpd.setString(3, incidencia.getEstado());
                    pstmtUpd.setString(4, incidencia.getObservaciones());
                    pstmtUpd.setInt(5, incidencia.getIdLandingStation());
                    pstmtUpd.setInt(6, incidencia.getIdIncidencia());
                    pstmtUpd.executeUpdate();
                }

                // 2. Borrar los servicios anteriores de la tabla intermedia
                try (PreparedStatement pstmtDel = conn.prepareStatement(sqlDeleteHas)) {
                    pstmtDel.setInt(1, incidencia.getIdIncidencia());
                    pstmtDel.executeUpdate();
                }

                // 3. Insertar los nuevos servicios seleccionados (si hay alguno)
                if (incidencia.getIdsServicios() != null && !incidencia.getIdsServicios().isEmpty()) {
                    try (PreparedStatement pstmtIns = conn.prepareStatement(sqlInsertHas)) {
                        for (Integer idServicio : incidencia.getIdsServicios()) {
                            pstmtIns.setInt(1, incidencia.getIdIncidencia());
                            pstmtIns.setInt(2, idServicio);
                            pstmtIns.addBatch();
                        }
                        pstmtIns.executeBatch();
                    }
                }

                conn.commit(); // Si todo sale bien, guardamos cambios permanentemente
            } catch (SQLException e) {
                conn.rollback(); // Si algo falla, deshacemos todo
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void eliminarIncidencia(int idIncidencia) throws SQLException {
        String sqlDeleteHas = "DELETE FROM incidencia_has_servicio WHERE idIncidencia = ?";
        String sqlDeleteInc = "DELETE FROM incidencia WHERE idIncidencia = ?";

        try (Connection conn = this.getConnection()) {
            conn.setAutoCommit(false); // Iniciamos transacción

            try {
                // 1. Primero eliminamos los enlaces en la tabla intermedia
                try (PreparedStatement pstmtHas = conn.prepareStatement(sqlDeleteHas)) {
                    pstmtHas.setInt(1, idIncidencia);
                    pstmtHas.executeUpdate();
                }

                // 2. Luego eliminamos la incidencia principal
                try (PreparedStatement pstmtInc = conn.prepareStatement(sqlDeleteInc)) {
                    pstmtInc.setInt(1, idIncidencia);
                    pstmtInc.executeUpdate();
                }

                conn.commit(); // Si todo sale bien, confirmamos los cambios
            } catch (SQLException e) {
                conn.rollback(); // Si algo falla, revertimos todo
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}