package com.oceanlink.daos;

import com.oceanlink.beans.Cliente;

import java.sql.*;
import java.util.ArrayList;

public class ClienteDao extends DaoBase {

    // Listar todos los clientes
    public ArrayList<Cliente> listarClientes() {
        ArrayList<Cliente> lista = new ArrayList<>();
        // Verificamos si tiene servicios vinculados mediante un LEFT JOIN
        String sql = "SELECT c.*, COUNT(sv.idServicio) AS totalServicios "
                + "FROM cliente c "
                + "LEFT JOIN solicitudcapacidad sc ON c.idCliente = sc.idCliente "
                + "LEFT JOIN servicio sv ON sv.idSolicitudCapacidad = sc.idSolicitudCapacidad AND sv.estado = 'Activo' "
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
                c.setRuc(rs.getString("ruc"));
                c.setCorreo(rs.getString("correo"));

                // Si tiene al menos una solicitud/servicio es Activo, sino Inactivo
                int total = rs.getInt("totalServicios");
                c.setEstado(total > 0 ? "Activo" : "Inactivo");

                lista.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Obtener cliente por su ID
    public Cliente obtenerCliente(int idCliente) {
        Cliente c = null;
        String sql = "SELECT c.*, COUNT(sv.idServicio) AS totalServicios "
                + "FROM cliente c "
                + "LEFT JOIN solicitudcapacidad sc ON c.idCliente = sc.idCliente "
                + "LEFT JOIN servicio sv ON sv.idSolicitudCapacidad = sc.idSolicitudCapacidad AND sv.estado = 'Activo' "
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
                    c.setRuc(rs.getString("ruc"));
                    c.setCorreo(rs.getString("correo"));

                    int total = rs.getInt("totalServicios");
                    c.setEstado(total > 0 ? "Activo" : "Inactivo");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return c;
    }

    // Registrar cliente (Para el modal "Registrar Cliente")
    public void registrarCliente(String razonSocial, String ruc, String correo) {
        String sqlIdentificador = "SELECT COALESCE(MAX(idCliente), 0) + 1 AS siguiente FROM cliente";
        // nace como Inactivo porque recien se crea y no tiene servicios
        String sqlInsert = "INSERT INTO cliente (identificador, fechaRegistro, razonSocial, estado, ruc, correo) "
                + "VALUES (?, CURDATE(), ?, 'Inactivo', ?, ?)";

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
                pstmt.setString(3, ruc);
                pstmt.setString(4, correo);
                pstmt.executeUpdate();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void actualizarCliente(int idCliente, String razonSocial, String ruc, String correo) {
        String sql = "UPDATE cliente SET razonSocial = ?, ruc = ?, correo = ? WHERE idCliente = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, razonSocial);
            pstmt.setString(2, ruc);
            pstmt.setString(3, correo);
            pstmt.setInt(4, idCliente);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // true si otro cliente ya tiene ese RUC (idExcluir = el que se esta editando, 0 al crear)
    public boolean existeRuc(String ruc, int idExcluir) {
        boolean existe = false;
        String sql = "SELECT COUNT(*) FROM cliente WHERE ruc = ? AND idCliente <> ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, ruc);
            pstmt.setInt(2, idExcluir);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    existe = rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return existe;
    }

    // si el cliente tiene solicitudes la llave foranea no deja borrarlo y devuelve false
    public boolean borrarCliente(int idCliente) {
        boolean borrado = false;
        String sql = "DELETE FROM cliente WHERE idCliente = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idCliente);
            borrado = pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return borrado;
    }
}