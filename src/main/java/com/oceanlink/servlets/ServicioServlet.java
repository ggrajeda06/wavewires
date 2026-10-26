package com.oceanlink.servlets;

import com.oceanlink.beans.Servicio;
import com.oceanlink.daos.ServicioDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "ServicioServlet", value = "/ServicioServlet")
public class ServicioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        ServicioDao servicioDao = new ServicioDao();
        RequestDispatcher view;

        switch (action) {
            case "lista":
                String textoBuscar = request.getParameter("buscar");
                ArrayList<Servicio> lista;

                if (textoBuscar != null && !textoBuscar.trim().isEmpty()) {
                    lista = servicioDao.buscarServicios(textoBuscar);
                } else {
                    lista = servicioDao.listarServicios();
                }

                request.setAttribute("listaServicios", lista);
                view = request.getRequestDispatcher("CapacityPlanner/servicios.jsp");
                view.forward(request, response);
                break;

            case "borrar":
                int idBorrar = Integer.parseInt(request.getParameter("id"));
                servicioDao.eliminarServicio(idBorrar);
                response.sendRedirect(request.getContextPath() + "/ServicioServlet");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        doGet(request, response);
    }
}