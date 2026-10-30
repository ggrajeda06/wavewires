package com.oceanlink.daos;

import com.oceanlink.beans.Usuario;
import com.oceanlink.beans.Rol;

import java.sql.*;
import java.util.ArrayList;

public class UsuarioDao extends DaoBase{
    // Listar usuarios con el nombre de su rol
    public ArrayList<Usuario> listarUsuarios() {
        ArrayList<Usuario> lista = new ArrayList<>();
        String sql = "SELECT u.*, r.rol AS nombreRol "
                + "FROM usuario u "
                + "JOIN Roles r ON u.Roles_idRoles = r.idRoles "
                + "ORDER BY u.idUsuario ASC";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Usuario u = mapearUsuario(rs);
                lista.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // true si otro usuario ya usa ese correo (idExcluir = el que se esta editando, 0 al crear)
    public boolean existeCorreo(String correo, int idExcluir) {
        boolean existe = false;
        String sql = "SELECT COUNT(*) FROM usuario WHERE correo = ? AND idUsuario <> ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, correo);
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

    // Listar roles (para el select del formulario)
    public ArrayList<Rol> listarRoles() {
        ArrayList<Rol> lista = new ArrayList<>();
        String sql = "SELECT * FROM Roles ORDER BY idRoles ASC";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Rol r = new Rol();
                r.setIdRoles(rs.getInt("idRoles"));
                r.setRol(rs.getString("rol"));
                lista.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Metodo privado para mapear y no repetir codigo
    private Usuario mapearUsuario(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setIdUsuario(rs.getInt("idUsuario"));
        u.setNombre(rs.getString("nombre"));
        u.setCorreo(rs.getString("correo"));
        u.setEstado(rs.getString("estado"));
        u.setIdRol(rs.getInt("Roles_idRoles"));
        u.setNombreRol(rs.getString("nombreRol"));
        return u;
    }

    // Registrar usuario (Para el modal "Nuevo usuario")
    public void registrarUsuario(String nombre, String correo, String estado, String contrasenia, int idRol) {
        String sql = "INSERT INTO usuario (nombre, correo, estado, contrasenia, Roles_idRoles) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, nombre);
            pstmt.setString(2, correo);
            pstmt.setString(3, estado);
            pstmt.setString(4, contrasenia);
            pstmt.setInt(5, idRol);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void actualizarUsuario(int idUsuario, String nombre, String correo, String estado,
                                  String contrasenia, int idRol) {
        boolean cambiarClave = contrasenia != null && !contrasenia.isEmpty();

        String sql;
        if (cambiarClave) {
            sql = "UPDATE usuario SET nombre = ?, correo = ?, estado = ?, Roles_idRoles = ?, contrasenia = ? "
                    + "WHERE idUsuario = ?";
        } else {
            sql = "UPDATE usuario SET nombre = ?, correo = ?, estado = ?, Roles_idRoles = ? "
                    + "WHERE idUsuario = ?";
        }

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, nombre);
            pstmt.setString(2, correo);
            pstmt.setString(3, estado);
            pstmt.setInt(4, idRol);

            if (cambiarClave) {
                pstmt.setString(5, contrasenia);
                pstmt.setInt(6, idUsuario);
            } else {
                pstmt.setInt(5, idUsuario);
            }

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void borrarUsuario(int idUsuario) {
        String sql = "DELETE FROM usuario WHERE idUsuario = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idUsuario);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}