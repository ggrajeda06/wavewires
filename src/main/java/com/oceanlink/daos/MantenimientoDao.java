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
    public void crearMantenimiento(Mantenimiento m) {

        String sql = "INSERT INTO mantenimiento (nombre, descripcion, tipo, estado, fechaRegistrada, duracionHoras, "
                + "idLandingStation, idSegmento, idIncidencia) VALUES (?, ?, ?, 'Pendiente', ?, ?, ?, ?, ?)";
        try (Connection conn = this.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, m.getNombre());
            pstmt.setString(2, m.getDescripcion());
            pstmt.setString(3, m.getTipo());
            pstmt.setDate(4, m.getFechaRegistrada());
            pstmt.setInt(5, m.getDuracionHoras());

            if (m.getIdLandingStation() == 0) {
                pstmt.setNull(6, Types.INTEGER);
            } else {
                pstmt.setInt(6, m.getIdLandingStation());
            }

            if (m.getIdSegmento() == 0) {
                pstmt.setNull(7, Types.INTEGER);
            } else {
                pstmt.setInt(7, m.getIdSegmento());
            }

            if (m.getIdIncidencia() == 0) {
                pstmt.setNull(8, Types.INTEGER);
            } else {
                pstmt.setInt(8, m.getIdIncidencia());
            }

            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // el servlet decide que campos se pueden cambiar segun el estado; los ids en 0 se guardan como NULL
    public void actualizarMantenimiento(Mantenimiento m) {

        String sql = "UPDATE mantenimiento SET nombre = ?, descripcion = ?, tipo = ?, fechaRegistrada = ?, duracionHoras = ?, "
                + "estado = ?, actividadesRealizadas = ?, idLandingStation = ?, idSegmento = ?, idIncidencia = ? "
                + "WHERE idMantenimiento = ?";
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
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
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
}