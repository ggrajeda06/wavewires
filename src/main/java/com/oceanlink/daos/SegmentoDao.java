package com.oceanlink.daos;

import com.oceanlink.beans.Segmento;

import java.sql.*;
import java.util.ArrayList;

public class SegmentoDao extends DaoBase {

    public ArrayList<Segmento> listarSegmentosPorLanding(int idLandingStation) {

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

    public void registrarSegmento(int idOrigen, int idDestino, double capacidadTotal, String estado) {
        String sql = "INSERT INTO segmento (idOrigen, idDestino, capacidadTotal, estado) "
                + "VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idOrigen);
            pstmt.setInt(2, idDestino);
            pstmt.setDouble(3, capacidadTotal);
            pstmt.setString(4, estado);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void actualizarSegmento(int idSegmento, int idOrigen, int idDestino, double capacidadTotal, String estado) {
        String sql = "UPDATE segmento SET idOrigen = ?, idDestino = ?, capacidadTotal = ?, estado = ? "
                + "WHERE idSegmento = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idOrigen);
            pstmt.setInt(2, idDestino);
            pstmt.setDouble(3, capacidadTotal);
            pstmt.setString(4, estado);
            pstmt.setInt(5, idSegmento);
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

    // Buscar segmentos por ruta o nombre
    public ArrayList<Segmento> buscarSegmentos(String texto) {
        ArrayList<Segmento> lista = new ArrayList<>();
        String sql = "SELECT s.*, o.nombre AS nombreOrigen, d.nombre AS nombreDestino "
                + "FROM segmento s "
                + "JOIN landingstation o ON s.idOrigen = o.idLandingStation "
                + "JOIN landingstation d ON s.idDestino = d.idLandingStation "
                + "WHERE CONCAT('Segmento ', s.idSegmento) LIKE ? "
                + "   OR o.nombre LIKE ? "
                + "   OR d.nombre LIKE ? "
                + "   OR CONCAT(o.nombre, ' - ', d.nombre) LIKE ? "
                + "ORDER BY s.idSegmento ASC";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String comodin = "%" + texto.trim() + "%";
            pstmt.setString(1, comodin);
            pstmt.setString(2, comodin);
            pstmt.setString(3, comodin);
            pstmt.setString(4, comodin);

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

    // Obtener segmento por id
    public Segmento obtenerSegmento(int idSegmento) {
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

    // el estado del segmento sale de lo que tiene encima, en este orden:
    // incidencia critica abierta -> Fuera de servicio, mantenimiento activo -> En mantenimiento,
    // otra incidencia abierta -> Degradado, nada -> Operativo
    public void recalcularEstado(int idSegmento) {
        String sqlMantenimiento = "SELECT COUNT(*) FROM mantenimiento WHERE idSegmento = ? AND estado = 'Activo'";
        String sqlCriticas = "SELECT COUNT(*) FROM incidencia i "
                + "JOIN incidencia_has_segmento ihs ON ihs.idIncidencia = i.idIncidencia "
                + "WHERE ihs.idSegmento = ? AND i.estado NOT IN ('Servicio restaurado', 'Cerrada') AND i.severidad = 'Crítica'";
        String sqlAbiertas = "SELECT COUNT(*) FROM incidencia i "
                + "JOIN incidencia_has_segmento ihs ON ihs.idIncidencia = i.idIncidencia "
                + "WHERE ihs.idSegmento = ? AND i.estado NOT IN ('Servicio restaurado', 'Cerrada')";
        String sqlUpdate = "UPDATE segmento SET estado = ? WHERE idSegmento = ?";

        try (Connection conn = getConnection()) {
            String estado = "Operativo";
            if (contar(conn, sqlCriticas, idSegmento) > 0) {
                estado = "Fuera de servicio";
            } else if (contar(conn, sqlMantenimiento, idSegmento) > 0) {
                estado = "En mantenimiento";
            } else if (contar(conn, sqlAbiertas, idSegmento) > 0) {
                estado = "Degradado";
            }

            try (PreparedStatement pstmt = conn.prepareStatement(sqlUpdate)) {
                pstmt.setString(1, estado);
                pstmt.setInt(2, idSegmento);
                pstmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private int contar(Connection conn, String sql, int id) throws SQLException {
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }
}