package com.oceanlink.util;

import com.oceanlink.beans.Usuario;
import com.oceanlink.daos.UsuarioDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

// Reglas de sesion y de roles que usan todos los servlets y JSP.
// Regla del equipo: el Administrador VE todos los modulos, pero cada modulo solo lo GESTIONA
// (crear, editar, borrar, cambiar estados) el rol duenio. Los historiales son solo de consulta.
public final class Seguridad {

    // Nombres exactos de los roles de la base de datos (tabla roles).
    public static final String ADMIN = "Administrador";
    public static final String OPERADOR = "Network Operator";
    public static final String MANTENIMIENTO = "Maintenance Coordinator";
    public static final String PLANIFICADOR = "Capacity Planner";
    public static final String SUPERVISOR = "Supervisor";

    private Seguridad() {
    }

    // Usuario autenticado de esta peticion, o null si no hay una sesion valida.
    // Se vuelve a leer de la base en cada peticion: si lo desactivaron, lo borraron
    // o le cambiaron el rol mientras estaba conectado, deja de pasar al instante.
    public static Usuario obtenerUsuario(HttpServletRequest request) {
        // si ya se reviso en esta misma peticion (servlet y luego JSP), no se consulta otra vez
        Object revisado = request.getAttribute("usuarioRevisado");
        if (revisado instanceof Usuario) {
            return (Usuario) revisado;
        }

        // false: consultar la sesion sin crear una nueva.
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }

        Object atributo = session.getAttribute("usuarioLogueado");
        if (!(atributo instanceof Usuario)) {
            return null;
        }

        Usuario enSesion = (Usuario) atributo;
        if (enSesion.getIdUsuario() <= 0) {
            return null;
        }

        Usuario actual;
        try {
            actual = new UsuarioDao().obtenerUsuarioActivo(enSesion.getIdUsuario());
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }

        if (actual == null) {
            return null;
        }

        // la sesion se queda con los datos al dia (por ejemplo, si le cambiaron el rol)
        session.setAttribute("usuarioLogueado", actual);
        request.setAttribute("usuarioRevisado", actual);
        return actual;
    }

    public static boolean tieneRol(Usuario usuario, String... rolesPermitidos) {
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

    public static boolean esAdmin(HttpServletRequest request) {
        return tieneRol(obtenerUsuario(request), ADMIN);
    }

    // true si el usuario de la sesion es el rol duenio del modulo (el unico que crea, edita y borra).
    // Los JSP lo usan para mostrar u ocultar los botones.
    public static boolean puedeGestionar(HttpServletRequest request, String rolDuenio) {
        return tieneRol(obtenerUsuario(request), rolDuenio);
    }

    public static void evitarCache(HttpServletResponse response) {
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }

    // Puerta de entrada de cada servlet: hay sesion valida y el rol esta en la lista.
    // Sin sesion -> al login. Con sesion pero sin permiso -> 403 (pagina de error propia).
    public static boolean permitir(HttpServletRequest request, HttpServletResponse response,
                                   String... rolesPermitidos) throws IOException {
        evitarCache(response);

        Usuario usuario = obtenerUsuario(request);

        if (usuario == null) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return false;
        }

        if (!tieneRol(usuario, rolesPermitidos)) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return false;
        }
        return true;
    }

    // Para las acciones que modifican (o abren un formulario para modificar):
    // solo pasa el rol duenio del modulo; el Administrador, que solo consulta, recibe 403.
    public static boolean exigirGestion(HttpServletRequest request, HttpServletResponse response,
                                        String rolDuenio) throws IOException {
        if (puedeGestionar(request, rolDuenio)) {
            return true;
        }
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return false;
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