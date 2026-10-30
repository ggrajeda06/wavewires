package com.oceanlink.servlets;

import com.oceanlink.beans.Cliente;
import com.oceanlink.daos.ClienteDao;
import com.oceanlink.daos.ServicioDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "ClienteServlet", value = "/ClienteServlet")
public class ClienteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        ClienteDao clienteDao = new ClienteDao();
        ServicioDao servicioDao = new ServicioDao();
        RequestDispatcher view;

        switch (action) {
            case "lista":
                String textoBuscar = request.getParameter("buscar");
                ArrayList<Cliente> lista;

                if (textoBuscar != null && !textoBuscar.trim().isEmpty()) {
                    lista = clienteDao.buscarClientes(textoBuscar);
                } else {
                    lista = clienteDao.listarClientes();
                }

                request.setAttribute("listaClientes", lista);
                request.setAttribute("listaServicios", servicioDao.listarServicios());
                view = request.getRequestDispatcher("CapacityPlanner/clientes.jsp");
                view.forward(request, response);
                break;

            case "borrar":
                if (clienteDao.borrarCliente(numero(request.getParameter("id")))) {
                    response.sendRedirect(request.getContextPath() + "/ClienteServlet");
                } else {
                    response.sendRedirect(request.getContextPath() + "/ClienteServlet?error=enUso");
                }
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/ClienteServlet");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        ClienteDao clienteDao = new ClienteDao();

        int idCliente = numero(request.getParameter("idCliente"));
        String razonSocial = texto(request.getParameter("razonSocial"));
        String ruc = texto(request.getParameter("ruc"));
        String correo = texto(request.getParameter("correo"));

        String error = null;
        if (razonSocial.isEmpty() || correo.isEmpty()) {
            error = "vacio";
        } else if (razonSocial.length() > 100 || correo.length() > 100) {
            error = "largo";
        } else if (!ruc.matches("[0-9]{11}")) {
            error = "ruc";
        } else if (!correo.contains("@")) {
            error = "correo";
        } else if (clienteDao.existeRuc(ruc, action.equals("crear") ? 0 : idCliente)) {
            error = "rucRepetido";
        }

        if (error != null) {
            response.sendRedirect(request.getContextPath() + "/ClienteServlet?error=" + error);
            return;
        }

        switch (action) {
            case "crear":
                clienteDao.registrarCliente(razonSocial, ruc, correo);
                response.sendRedirect(request.getContextPath() + "/ClienteServlet");
                break;

            case "actualizar":
                clienteDao.actualizarCliente(idCliente, razonSocial, ruc, correo);
                response.sendRedirect(request.getContextPath() + "/ClienteServlet");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/ClienteServlet");
                break;
        }
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