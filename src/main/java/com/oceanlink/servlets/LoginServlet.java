package com.oceanlink.servlets;

import com.oceanlink.beans.Usuario;
import com.oceanlink.daos.UsuarioDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    // Ruta de inicio segun el rol
    private String inicio(Usuario u) {
        if (u.getNombreRol() == null) return null;
        return switch (u.getNombreRol().trim()) {
            case "Administrador" -> "/ResumenServlet";
            case "Capacity Planner" -> "/CapacidadServlet";
            case "Network Operator" -> "/IncidenciaServlet";
            case "Maintenance Coordinator" -> "/MantenimientoServlet";
            case "Supervisor" -> "/SupervisorServlet";
            default -> null;
        };
    }

    // Mostrar login o redirigir si ya tiene sesion activa
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader("Cache-Control", "no-store");
        HttpSession session = request.getSession(false);
        Usuario usuario = session == null ? null : (Usuario) session.getAttribute("usuarioLogueado");

        if (usuario != null && usuario.getIdUsuario() > 0) {
            String ruta = inicio(usuario);
            if (ruta != null) {
                response.sendRedirect(request.getContextPath() + ruta);
                return;
            }
            session.invalidate();
        }

        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    // Validar credenciales y crear sesion
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");

        HttpSession previa = request.getSession(false);
        Usuario actual = previa == null ? null : (Usuario) previa.getAttribute("usuarioLogueado");
        if (actual != null && actual.getIdUsuario() > 0 && inicio(actual) != null) {
            response.sendRedirect(request.getContextPath() + inicio(actual));
            return;
        }

        String correo = request.getParameter("correo");
        String clave = request.getParameter("contrasenia");

        if (correo == null || correo.isBlank() || clave == null || clave.isEmpty()) {
            mostrarError(request, response, "Completa ambos campos.");
            return;
        }

        try {
            UsuarioDao usuarioDao = new UsuarioDao();
            Usuario usuario = usuarioDao.validarCredenciales(correo, clave);

            if (usuario == null) {
                mostrarError(request, response, "Credenciales incorrectas o cuenta inactiva.");
                return;
            }

            String ruta = inicio(usuario);
            if (ruta == null) {
                mostrarError(request, response, "La cuenta no tiene un rol habilitado.");
                return;
            }

            // Iniciar sesion
            HttpSession anterior = request.getSession(false);
            if (anterior != null) anterior.invalidate();

            HttpSession session = request.getSession(true);
            session.setAttribute("usuarioLogueado", usuario);
            session.setMaxInactiveInterval(30 * 60); // 30 minutos de inactividad

            response.sendRedirect(request.getContextPath() + ruta);

        } catch (SQLException e) {
            getServletContext().log("Error al autenticar", e);
            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            mostrarError(request, response, "No se pudo conectar con la base de datos.");
        }
    }

    // Enviar mensaje de error a la vista
    private void mostrarError(HttpServletRequest request, HttpServletResponse response, String mensaje)
            throws ServletException, IOException {
        request.setAttribute("error", mensaje);
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }
}