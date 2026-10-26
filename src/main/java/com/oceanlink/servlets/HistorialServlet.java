package com.oceanlink.servlets;

import com.oceanlink.beans.Segmento;
import com.oceanlink.beans.Servicio;
import com.oceanlink.daos.SegmentoDao;
import com.oceanlink.daos.ServicioDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "HistorialServlet", value = "/HistorialServlet")
public class HistorialServlet extends HttpServlet {

    // Listar historial de segmentos y caducados
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        SegmentoDao segmentoDao = new SegmentoDao();
        ServicioDao servicioDao = new ServicioDao();
        RequestDispatcher view;

        switch (action) {
            case "lista":
                String textoBuscar = request.getParameter("buscar");
                ArrayList<Segmento> listaSeg;

                if (textoBuscar != null && !textoBuscar.trim().isEmpty()) {
                    listaSeg = segmentoDao.buscarSegmentos(textoBuscar);
                } else {
                    listaSeg = segmentoDao.listarSegmentos();
                }

                ArrayList<Servicio> listaCaducados = servicioDao.listarServiciosCaducados();

                request.setAttribute("listaSegmentos", listaSeg);
                request.setAttribute("listaServiciosCaducados", listaCaducados);

                view = request.getRequestDispatcher("CapacityPlanner/historial.jsp");
                view.forward(request, response);
                break;

            case "borrar":
                int idBorrar = Integer.parseInt(request.getParameter("id"));
                servicioDao.eliminarServicioPermanente(idBorrar);
                response.sendRedirect(request.getContextPath() + "/HistorialServlet");
                break;
        }
    }

    // Procesar peticiones POST
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        doGet(request, response);
    }
}