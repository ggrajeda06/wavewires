package com.oceanlink.daos;

import com.oceanlink.beans.Cliente;

import java.sql.*;
import java.util.ArrayList;

public class ClienteDao extends DaoBase {

    // Listar todos los clientes
    public ArrayList<Cliente> listarClientes() {
        ArrayList<Cliente> lista = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(sv.idServicio) AS totalServicios "
                + "FROM cliente c "
                + "LEFT JOIN solicitudcapacidad sc ON c.idCliente = sc.idCliente "
                + "LEFT JOIN servicio sv ON sv.idSolicitudCapacidad = sc.idSolicitudCapacidad AND sv.fechaCaducidad >= CURDATE() "
                + "GROUP BY c.idCliente "
                + "ORDER BY c.idCliente ASC";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Cliente c = new Cliente();
                c.setIdCliente(rs.getInt("idCliente"));
                c.setIdentificador(rs.getString("identificador"));
                c.setFechaRegistro(rs.getDate("fechaRegistro"));
                c.setRazonSocial(rs.getString("razonSocial"));

                int total = rs.getInt("totalServicios");
                c.setEstado(total > 0 ? "Activo" : "Inactivo");

                lista.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Buscar por cliente o razon social
    public ArrayList<Cliente> buscarClientes(String texto) {
        ArrayList<Cliente> lista = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(sv.idServicio) AS totalServicios "
                + "FROM cliente c "
                + "LEFT JOIN solicitudcapacidad sc ON c.idCliente = sc.idCliente "
                + "LEFT JOIN servicio sv ON sv.idSolicitudCapacidad = sc.idSolicitudCapacidad AND sv.fechaCaducidad >= CURDATE() "
                + "GROUP BY c.idCliente, c.identificador, c.razonSocial "
                + "HAVING c.identificador LIKE ? OR c.razonSocial LIKE ? "
                + "   OR (IF(COUNT(sv.idServicio) > 0, 'Activo', 'Inactivo')) LIKE ? "
                + "ORDER BY c.idCliente ASC";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String comodin = "%" + texto.trim() + "%";
            pstmt.setString(1, comodin);
            pstmt.setString(2, comodin);
            pstmt.setString(3, comodin);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Cliente c = new Cliente();
                    c.setIdCliente(rs.getInt("idCliente"));
                    c.setIdentificador(rs.getString("identificador"));
                    c.setFechaRegistro(rs.getDate("fechaRegistro"));
                    c.setRazonSocial(rs.getString("razonSocial"));

                    int total = rs.getInt("totalServicios");
                    c.setEstado(total > 0 ? "Activo" : "Inactivo");

                    lista.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Obtener cliente por id
    public Cliente obtenerCliente(int idCliente) {
        Cliente c = null;
        String sql = "SELECT c.*, COUNT(sv.idServicio) AS totalServicios "
                + "FROM cliente c "
                + "LEFT JOIN solicitudcapacidad sc ON c.idCliente = sc.idCliente "
                + "LEFT JOIN servicio sv ON sv.idSolicitudCapacidad = sc.idSolicitudCapacidad AND sv.fechaCaducidad >= CURDATE() "
                + "WHERE c.idCliente = ? "
                + "GROUP BY c.idCliente";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idCliente);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    c = new Cliente();
                    c.setIdCliente(rs.getInt("idCliente"));
                    c.setIdentificador(rs.getString("identificador"));
                    c.setFechaRegistro(rs.getDate("fechaRegistro"));
                    c.setRazonSocial(rs.getString("razonSocial"));

                    int total = rs.getInt("totalServicios");
                    c.setEstado(total > 0 ? "Activo" : "Inactivo");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return c;
    }

    // Registrar cliente
    public void registrarCliente(String razonSocial) {
        String sqlIdentificador = "SELECT COALESCE(MAX(idCliente), 0) + 1 AS siguiente FROM cliente";
        String sqlInsert = "INSERT INTO cliente (identificador, fechaRegistro, razonSocial, estado) "
                + "VALUES (?, CURDATE(), ?, 'Inactivo')";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sqlIdentificador)) {

            int siguienteId = 1;
            if (rs.next()) {
                siguienteId = rs.getInt("siguiente");
            }

            String identificador = "Cliente " + siguienteId;

            try (PreparedStatement pstmt = conn.prepareStatement(sqlInsert)) {
                pstmt.setString(1, identificador);
                pstmt.setString(2, razonSocial);
                pstmt.executeUpdate();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Eliminar cliente
    public void borrarCliente(int idCliente) {
        String sqlServicios = "DELETE FROM servicio WHERE idSolicitudCapacidad IN "
                + "(SELECT idSolicitudCapacidad FROM solicitudcapacidad WHERE idCliente = ?)";
        String sqlSolicitudes = "DELETE FROM solicitudcapacidad WHERE idCliente = ?";
        String sqlCliente = "DELETE FROM cliente WHERE idCliente = ?";

        try (Connection conn = getConnection()) {
            try (PreparedStatement pstmt1 = conn.prepareStatement(sqlServicios)) {
                pstmt1.setInt(1, idCliente);
                pstmt1.executeUpdate();
            }
            try (PreparedStatement pstmt2 = conn.prepareStatement(sqlSolicitudes)) {
                pstmt2.setInt(1, idCliente);
                pstmt2.executeUpdate();
            }
            try (PreparedStatement pstmt3 = conn.prepareStatement(sqlCliente)) {
                pstmt3.setInt(1, idCliente);
                pstmt3.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}