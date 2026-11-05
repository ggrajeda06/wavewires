package com.oceanlink.daos;

import com.oceanlink.beans.IndicadorMensual;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;

public class IndicadorDao extends DaoBase {

    // Anios con algun dato, del mas reciente al mas antiguo
    public ArrayList<Integer> listarAnios() {
        ArrayList<Integer> anios = new ArrayList<>();
        String sql = "SELECT YEAR(fechaRegistro) AS anio FROM incidencia "
                + "UNION SELECT YEAR(fechaCierre) FROM incidencia WHERE fechaCierre IS NOT NULL "
                + "UNION SELECT YEAR(fechaRegistrada) FROM mantenimiento "
                + "UNION SELECT YEAR(fechaRegistroSolicitud) FROM solicitudcapacidad "
                + "UNION SELECT YEAR(fechaActivacion) FROM servicio "
                + "ORDER BY anio DESC";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                anios.add(rs.getInt("anio"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return anios;
    }

    // Siempre devuelve los 12 meses; los que no tienen datos quedan en cero
    public ArrayList<IndicadorMensual> listarPorMes(int anio) {
        ArrayList<IndicadorMensual> meses = new ArrayList<>();
        for (int mes = 1; mes <= 12; mes++) {
            IndicadorMensual indicador = new IndicadorMensual();
            indicador.setMes(mes);
            meses.add(indicador);
        }

        String sql = "SELECT 'detectadas' AS indicador, MONTH(fechaRegistro) AS mes, COUNT(*) AS valor FROM incidencia "
                + "WHERE YEAR(fechaRegistro) = ? GROUP BY mes "
                + "UNION ALL SELECT 'cerradas', MONTH(fechaCierre), COUNT(*) FROM incidencia "
                + "WHERE YEAR(fechaCierre) = ? GROUP BY MONTH(fechaCierre) "
                + "UNION ALL SELECT 'mantenimientos', MONTH(fechaRegistrada), COUNT(*) FROM mantenimiento "
                + "WHERE YEAR(fechaRegistrada) = ? GROUP BY MONTH(fechaRegistrada) "
                + "UNION ALL SELECT 'solicitudes', MONTH(fechaRegistroSolicitud), COUNT(*) FROM solicitudcapacidad "
                + "WHERE YEAR(fechaRegistroSolicitud) = ? GROUP BY MONTH(fechaRegistroSolicitud) "
                + "UNION ALL SELECT 'servicios', MONTH(fechaActivacion), COUNT(*) FROM servicio "
                + "WHERE YEAR(fechaActivacion) = ? GROUP BY MONTH(fechaActivacion) "
                + "UNION ALL SELECT 'capacidad', MONTH(fechaActivacion), SUM(capacidad) FROM servicio "
                + "WHERE YEAR(fechaActivacion) = ? GROUP BY MONTH(fechaActivacion)";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            for (int i = 1; i <= 6; i++) {
                pstmt.setInt(i, anio);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    IndicadorMensual indicador = meses.get(rs.getInt("mes") - 1);
                    BigDecimal valor = rs.getBigDecimal("valor");
                    switch (rs.getString("indicador")) {
                        case "detectadas":
                            indicador.setIncidenciasDetectadas(valor.intValue());
                            break;
                        case "cerradas":
                            indicador.setIncidenciasCerradas(valor.intValue());
                            break;
                        case "mantenimientos":
                            indicador.setMantenimientosProgramados(valor.intValue());
                            break;
                        case "solicitudes":
                            indicador.setSolicitudesRegistradas(valor.intValue());
                            break;
                        case "servicios":
                            indicador.setServiciosActivados(valor.intValue());
                            break;
                        default:
                            indicador.setCapacidadActivada(valor);
                            break;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return meses;
    }
}
