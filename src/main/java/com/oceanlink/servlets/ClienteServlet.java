package com.oceanlink.servlets;

import com.oceanlink.beans.Cliente;
import com.oceanlink.daos.ClienteDao;
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
        RequestDispatcher view;

        switch (action) {
            case "lista":
                // Si el usuario escribió algo en el buscador, filtramos; si no, traemos todos
                String textoBuscar = request.getParameter("buscar");
                ArrayList<Cliente> lista;

                if (textoBuscar != null && !textoBuscar.trim().isEmpty()) {
                    lista = clienteDao.buscarClientes(textoBuscar);
                } else {
                    lista = clienteDao.listarClientes();
                }

                // Guardamos la lista en la "mochila" de la petición
                request.setAttribute("listaClientes", lista);
                view = request.getRequestDispatcher("CapacityPlanner/clientes.jsp");
                view.forward(request, response);
                break;

            case "borrar":
                int idBorrar = Integer.parseInt(request.getParameter("id"));
                clienteDao.borrarCliente(idBorrar);
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

        switch (action) {
            case "crear":
                String razonSocial = request.getParameter("razonSocial");
                clienteDao.registrarCliente(razonSocial);
                response.sendRedirect(request.getContextPath() + "/ClienteServlet");
                break;
        }
    }
}