package com.oceanlink.servlets;

import com.oceanlink.daos.UsuarioDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "UsuarioServlet", value = "/UsuarioServlet")
public class    UsuarioServlet extends HttpServlet {

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
                int idBorrar = Integer.parseInt(request.getParameter("id"));
                usuarioDao.borrarUsuario(idBorrar);
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

        switch (action) {
            case "crear":
                String nombre = request.getParameter("nombre");
                String correo = request.getParameter("correo");
                String estado = request.getParameter("estado");
                String contrasenia = request.getParameter("contrasenia");
                String confirmar = request.getParameter("confirmar");
                int idRol = Integer.parseInt(request.getParameter("idRol"));

                if (!contrasenia.equals(confirmar)) {
                    response.sendRedirect(request.getContextPath() + "/UsuarioServlet?error=clave");
                    break;
                }

                usuarioDao.registrarUsuario(nombre, correo, estado, contrasenia, idRol);
                response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
                break;

            case "actualizar":
                int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
                String nombreEdit = request.getParameter("nombre");
                String correoEdit = request.getParameter("correo");
                String estadoEdit = request.getParameter("estado");
                String contraseniaEdit = request.getParameter("contrasenia");
                String confirmarEdit = request.getParameter("confirmar");
                int idRolEdit = Integer.parseInt(request.getParameter("idRol"));

                if (!contraseniaEdit.isEmpty() && !contraseniaEdit.equals(confirmarEdit)) {
                    response.sendRedirect(request.getContextPath() + "/UsuarioServlet?error=clave");
                    break;
                }

                usuarioDao.actualizarUsuario(idUsuario, nombreEdit, correoEdit, estadoEdit, contraseniaEdit, idRolEdit);
                response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
                break;
        }
    }
}
