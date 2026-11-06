package com.oceanlink.util;

import com.oceanlink.beans.Usuario;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public final class Seguridad {

    // Nombres exactos de los roles de tu base de datos.
    public static final String ADMIN = "Administrador";
    public static final String OPERADOR = "Network Operator";
    public static final String MANTENIMIENTO = "Maintenance Coordinator";
    public static final String PLANIFICADOR = "Capacity Planner";
    public static final String SUPERVISOR = "Supervisor";

    private Seguridad() {
    }

    public static Usuario obtenerUsuario(HttpServletRequest request) {
        // false: consultar la sesión sin crear una nueva.
        HttpSession session = request.getSession(false);

        if (session == null) {
            return null;
        }

        Object atributo = session.getAttribute("usuarioLogueado");

        if (!(atributo instanceof Usuario)) {
            return null;
        }

        Usuario usuario = (Usuario) atributo;

        if (usuario.getIdUsuario() <= 0
                || !"Activo".equals(usuario.getEstado())) {
            return null;
        }

        return usuario;
    }

    public static boolean tieneRol(
            Usuario usuario, String... rolesPermitidos) {

        if (usuario == null || usuario.getNombreRol() == null) {
            return false;
        }

        String rolActual = usuario.getNombreRol().trim();

        for (String rolPermitido : rolesPermitidos) {
            if (rolActual.equals(rolPermitido)) {
                return true;
            }
        }

        return false;
    }

    public static void evitarCache(HttpServletResponse response) {
        response.setHeader(
                "Cache-Control", "no-store, no-cache, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }

    public static boolean permitir(
            HttpServletRequest request,
            HttpServletResponse response,
            String... rolesPermitidos) throws IOException {

        evitarCache(response);

        Usuario usuario = obtenerUsuario(request);

        // No existe una identidad autenticada válida.
        if (usuario == null) {
            HttpSession session = request.getSession(false);

            if (session != null) {
                session.invalidate();
            }

            response.sendRedirect(
                    request.getContextPath() + "/LoginServlet");
            return false;
        }

        // Existe sesión, pero el rol no tiene acceso.
        if (!tieneRol(usuario, rolesPermitidos)) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "No tienes permiso para acceder a este módulo.");
            return false;
        }

        return true;
    }

    // Para mostrar textos de la BD dentro de HTML.
    public static String escaparHtml(String texto) {
        if (texto == null) {
            return "";
        }

        return texto.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}
