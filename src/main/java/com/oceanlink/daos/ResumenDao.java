package com.oceanlink.daos;

import com.oceanlink.beans.Incidencia;
import com.oceanlink.beans.Mantenimiento;
import com.oceanlink.beans.Segmento;

import java.sql.*;
import java.util.ArrayList;

// RF06: consultas del resumen del Administrador. Cada dato sale de un SELECT simple.
public class ResumenDao extends DaoBase {

    // ejecuta un SELECT COUNT(*) y devuelve el numero
    private int contar(String sql) {
        try (Connection conn = this.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int contarUsuarios() {
        return contar("SELECT COUNT(*) FROM usuario");
    }

    public int contarUsuariosActivos() {
        return contar("SELECT COUNT(*) FROM usuario WHERE estado = 'Activo'");
    }

    public int contarLandings() {
        return contar("SELECT COUNT(*) FROM landingstation");
    }

    public int contarSegmentos() {
        return contar("SELECT COUNT(*) FROM segmento");
    }

    // el estado de los segmentos se recalcula al leer (igual que en el resto del sistema)
    public int contarSegmentosOperativos() {
        new SegmentoDao().recalcularEstados();
        return contar("SELECT COUNT(*) FROM segmento WHERE estado = 'Operativo'");
    }

    public int contarIncidenciasAbiertas() {
        return contar("SELECT COUNT(*) FROM incidencia WHERE estado NOT IN ('Servicio restaurado', 'Cerrada')");
    }

    // cuentas activas de cada rol; cada fila es {rol, cantidad}
    // (LEFT JOIN para que tambien salgan los roles con 0 cuentas activas)
    public ArrayList<String[]> listarCuentasActivasPorRol() {
        ArrayList<String[]> lista = new ArrayList<>();
        String sql = "SELECT r.rol, COUNT(u.idUsuario) AS cantidad "
                + "FROM roles r "
                + "LEFT JOIN usuario u ON u.Roles_idRoles = r.idRoles AND u.estado = 'Activo' "
                + "GROUP BY r.idRoles, r.rol "
                + "ORDER BY r.idRoles";
        try (Connection conn = this.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                lista.add(new String[]{rs.getString("rol"), rs.getString("cantidad")});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // segmentos que no estan Operativos, con el nombre de sus landings
    public ArrayList<Segmento> listarSegmentosNoOperativos() {
        new SegmentoDao().recalcularEstados();
        ArrayList<Segmento> lista = new ArrayList<>();
        String sql = "SELECT s.idSegmento, s.estado, o.nombre AS nombreOrigen, d.nombre AS nombreDestino "
                + "FROM segmento s "
                + "JOIN landingstation o ON s.idOrigen = o.idLandingStation "
                + "JOIN landingstation d ON s.idDestino = d.idLandingStation "
                + "WHERE s.estado <> 'Operativo' "
                + "ORDER BY s.idSegmento";
        try (Connection conn = this.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Segmento s = new Segmento();
                s.setIdSegmento(rs.getInt("idSegmento"));
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

    // las 5 incidencias abiertas mas recientes, con los segmentos que afectan
    public ArrayList<Incidencia> listarUltimasIncidencias() {
        ArrayList<Incidencia> lista = new ArrayList<>();
        String sql = "SELECT idIncidencia, identificador, severidad, estado, fechaRegistro "
                + "FROM incidencia "
                + "WHERE estado NOT IN ('Servicio restaurado', 'Cerrada') "
                + "ORDER BY fechaRegistro DESC, idIncidencia DESC "
                + "LIMIT 5";
        String sqlSegmentos = "SELECT idSegmento FROM incidencia_has_segmento WHERE idIncidencia = ? ORDER BY idSegmento";

        try (Connection conn = this.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Incidencia i = new Incidencia();
                i.setIdIncidencia(rs.getInt("idIncidencia"));
                i.setIdentificador(rs.getString("identificador"));
                i.setSeveridad(rs.getString("severidad"));
                i.setEstado(rs.getString("estado"));
                i.setFechaRegistro(rs.getDate("fechaRegistro"));

                ArrayList<Integer> segmentos = new ArrayList<>();
                try (PreparedStatement pstmt = conn.prepareStatement(sqlSegmentos)) {
                    pstmt.setInt(1, i.getIdIncidencia());
                    try (ResultSet rsSeg = pstmt.executeQuery()) {
                        while (rsSeg.next()) {
                            segmentos.add(rsSeg.getInt("idSegmento"));
                        }
                    }
                }
                i.setIdsSegmentos(segmentos);
                lista.add(i);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // los 5 mantenimientos sin terminar mas cercanos (primero la fecha mas proxima)
    public ArrayList<Mantenimiento> listarProximosMantenimientos() {
        ArrayList<Mantenimiento> lista = new ArrayList<>();
        String sql = "SELECT idMantenimiento, nombre, tipo, estado, fechaRegistrada, idSegmento, idLandingStation "
                + "FROM mantenimiento "
                + "WHERE estado <> 'Finalizado' "
                + "ORDER BY fechaRegistrada ASC, idMantenimiento ASC "
                + "LIMIT 5";
        try (Connection conn = this.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Mantenimiento m = new Mantenimiento();
                m.setIdMantenimiento(rs.getInt("idMantenimiento"));
                m.setNombre(rs.getString("nombre"));
                m.setTipo(rs.getString("tipo"));
                m.setEstado(rs.getString("estado"));
                m.setFechaRegistrada(rs.getDate("fechaRegistrada"));
                m.setIdSegmento(rs.getInt("idSegmento"));
                m.setIdLandingStation(rs.getInt("idLandingStation"));
                lista.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}