package com.oceanlink.servlets;

import com.oceanlink.beans.Rol;
import com.oceanlink.daos.UsuarioDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "UsuarioServlet", value = "/UsuarioServlet")
public class UsuarioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        UsuarioDao usuarioDao = new UsuarioDao();
        RequestDispatcher view;

        switch (action) {
            case "lista":
                request.setAttribute("listaRoles", usuarioDao.listarRoles());
                request.setAttribute("lista", usuarioDao.listarUsuarios());
                view = request.getRequestDispatcher("Administrador/admin_usuarios.jsp");
                view.forward(request, response);
                break;

            case "borrar":
                usuarioDao.borrarUsuario(numero(request.getParameter("id")));
                response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        UsuarioDao usuarioDao = new UsuarioDao();

        int idUsuario = numero(request.getParameter("idUsuario"));
        String nombre = texto(request.getParameter("nombre"));
        String correo = texto(request.getParameter("correo"));
        String estado = texto(request.getParameter("estado"));
        String contrasenia = texto(request.getParameter("contrasenia"));
        String confirmar = texto(request.getParameter("confirmar"));
        int idRol = numero(request.getParameter("idRol"));

        // al crear la contrasena es obligatoria; al editar, vacia significa que no se cambia
        boolean creando = action.equals("crear");
        String error = null;
        if (nombre.isEmpty() || correo.isEmpty() || (creando && contrasenia.isEmpty())) {
            error = "vacio";
        } else if (nombre.length() > 100 || correo.length() > 100) {
            error = "largo";
        } else if (!correo.contains("@")) {
            error = "correo";
        } else if (!rolValido(usuarioDao, idRol) || (!estado.equals("Activo") && !estado.equals("Inactivo"))) {
            error = "rol";
        } else if (!contrasenia.equals(confirmar)) {
            error = "clave";
        } else if (usuarioDao.existeCorreo(correo, creando ? 0 : idUsuario)) {
            error = "correoRepetido";
        }

        if (error != null) {
            response.sendRedirect(request.getContextPath() + "/UsuarioServlet?error=" + error);
            return;
        }

        switch (action) {
            case "crear":
                usuarioDao.registrarUsuario(nombre, correo, estado, contrasenia, idRol);
                response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
                break;

            case "actualizar":
                usuarioDao.actualizarUsuario(idUsuario, nombre, correo, estado, contrasenia, idRol);
                response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
                break;
        }
    }

    private boolean rolValido(UsuarioDao usuarioDao, int idRol) {
        for (Rol r : usuarioDao.listarRoles()) {
            if (r.getIdRoles() == idRol) {
                return true;
            }
        }
        return false;
    }

    private String texto(String valor) {
        return valor == null ? "" : valor.trim();
    }

    private int numero(String valor) {
        try {
            return Integer.parseInt(valor);
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}