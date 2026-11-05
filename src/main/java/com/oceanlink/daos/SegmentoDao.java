package com.oceanlink.daos;

import com.oceanlink.beans.Segmento;

import java.sql.*;
import java.util.ArrayList;

public class SegmentoDao extends DaoBase {

    public void recalcularEstados() {
        String sql = "UPDATE segmento s SET s.estado = CASE "
                + "WHEN EXISTS (SELECT 1 FROM mantenimiento m WHERE m.estado = 'Activo' "
                + "  AND (m.idSegmento = s.idSegmento OR m.idLandingStation IN (s.idOrigen, s.idDestino))) "
                + "  THEN 'En mantenimiento' "
                + "WHEN (SELECT COUNT(*) FROM servicio sv WHERE sv.idSegmento = s.idSegmento "
                + "  AND sv.fechaCaducidad >= CURDATE() AND sv.estado = 'Caído') = 0 "
                + "  THEN 'Operativo' "
                + "WHEN (SELECT COUNT(*) FROM servicio sv WHERE sv.idSegmento = s.idSegmento "
                + "  AND sv.fechaCaducidad >= CURDATE() AND sv.estado = 'Funcionando') = 0 "
                + "  THEN 'Fuera de servicio' "
                + "ELSE 'Degradado' END";

        try (Connection conn = this.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public ArrayList<Segmento> listarSegmentosPorLanding(int idLandingStation) {
        recalcularEstados();

        ArrayList<Segmento> lista = new ArrayList<>();
        String sql = "SELECT * FROM segmento WHERE idOrigen = ? OR idDestino = ? ORDER BY idSegmento";
        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

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
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    public ArrayList<Segmento> listarSegmentos() {
        recalcularEstados();

        ArrayList<Segmento> lista = new ArrayList<>();
        String sql = "SELECT s.*, o.nombre AS nombreOrigen, d.nombre AS nombreDestino "
                + "FROM segmento s "
                + "JOIN landingstation o ON s.idOrigen = o.idLandingStation "
                + "JOIN landingstation d ON s.idDestino = d.idLandingStation "
                + "ORDER BY s.idSegmento ASC";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Segmento s = new Segmento();
                s.setIdSegmento(rs.getInt("idSegmento"));
                s.setIdOrigen(rs.getInt("idOrigen"));
                s.setIdDestino(rs.getInt("idDestino"));
                s.setCapacidadTotal(rs.getBigDecimal("capacidadTotal"));
                s.setCapacidadUsada(rs.getBigDecimal("capacidadUsada"));
                s.setCapacidadReservada(rs.getBigDecimal("capacidadReservada"));
                s.setEstado(rs.getString("estado"));
                s.setNombreOrigen(rs.getString("nombreOrigen"));
                s.setNombreDestino(rs.getString("nombreDestino"));
                lista.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // el segmento nace Operativo (valor por defecto en la BD); despues su estado se calcula solo
    public void registrarSegmento(int idOrigen, int idDestino, double capacidadTotal) {
        String sql = "INSERT INTO segmento (idOrigen, idDestino, capacidadTotal) VALUES (?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idOrigen);
            pstmt.setInt(2, idDestino);
            pstmt.setDouble(3, capacidadTotal);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void actualizarSegmento(int idSegmento, int idOrigen, int idDestino, double capacidadTotal) {
        String sql = "UPDATE segmento SET idOrigen = ?, idDestino = ?, capacidadTotal = ? WHERE idSegmento = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idOrigen);
            pstmt.setInt(2, idDestino);
            pstmt.setDouble(3, capacidadTotal);
            pstmt.setInt(4, idSegmento);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean borrarSegmento(int idSegmento) {
        String sql = "DELETE FROM segmento WHERE idSegmento = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idSegmento);
            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Obtener segmento por id
    public Segmento obtenerSegmento(int idSegmento) {
        recalcularEstados();

        Segmento s = null;
        String sql = "SELECT s.*, o.nombre AS nombreOrigen, d.nombre AS nombreDestino "
                + "FROM segmento s "
                + "JOIN landingstation o ON s.idOrigen = o.idLandingStation "
                + "JOIN landingstation d ON s.idDestino = d.idLandingStation "
                + "WHERE s.idSegmento = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idSegmento);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    s = new Segmento();
                    s.setIdSegmento(rs.getInt("idSegmento"));
                    s.setIdOrigen(rs.getInt("idOrigen"));
                    s.setIdDestino(rs.getInt("idDestino"));
                    s.setCapacidadTotal(rs.getBigDecimal("capacidadTotal"));
                    s.setCapacidadUsada(rs.getBigDecimal("capacidadUsada"));
                    s.setCapacidadReservada(rs.getBigDecimal("capacidadReservada"));
                    s.setEstado(rs.getString("estado"));
                    s.setNombreOrigen(rs.getString("nombreOrigen"));
                    s.setNombreDestino(rs.getString("nombreDestino"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return s;
    }

    // Actualizar capacidad reservada
    public boolean actualizarCapacidadReservada(int idSegmento, double nuevaReserva) {
        String sql = "UPDATE segmento SET capacidadReservada = ? WHERE idSegmento = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setDouble(1, nuevaReserva);
            pstmt.setInt(2, idSegmento);
            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // segmentos asociados a una incidencia, con el nombre de sus landings
    public ArrayList<Segmento> listarSegmentosPorIncidencia(int idIncidencia) {
        recalcularEstados();

        ArrayList<Segmento> lista = new ArrayList<>();
        String sql = "SELECT s.*, o.nombre AS nombreOrigen, d.nombre AS nombreDestino "
                + "FROM incidencia_has_segmento ihs "
                + "JOIN segmento s ON s.idSegmento = ihs.idSegmento "
                + "JOIN landingstation o ON s.idOrigen = o.idLandingStation "
                + "JOIN landingstation d ON s.idDestino = d.idLandingStation "
                + "WHERE ihs.idIncidencia = ? "
                + "ORDER BY s.idSegmento ASC";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idIncidencia);
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
                    s.setNombreOrigen(rs.getString("nombreOrigen"));
                    s.setNombreDestino(rs.getString("nombreDestino"));
                    lista.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}